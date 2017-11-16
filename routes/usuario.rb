class MyApp < Sinatra::Base
  get '/usuario/listar' do
    DB.fetch('
      SELECT U.id AS id, U.usuario AS usuario, A.momento AS momento, U.correo AS correo
      FROM usuarios U INNER JOIN accesos A ON U.id = A.usuario_id GROUP BY U.usuario ORDER BY U.id').to_a.to_json
  end

  post '/usuario/validar' do
    rpta = Usuario.where(:usuario => params['usuario'], :contrasenia => params['contrasenia']).count()
    if rpta == 1
      usuario_id = Usuario.select(:id).where(:usuario => params['usuario'], :contrasenia => params['contrasenia']).first().id
      Acceso.new(:usuario_id => usuario_id, :momento => Time.now).save
    end
    rpta.to_s
  end

  get '/usuario/listar_accesos/:usuario_id' do
    Acceso.select(:id, :momento).where(:usuario_id => params['usuario_id']).all().to_a.to_json
  end

  get '/usuario/obtener_usuario_correo/:usuario_id' do
    Usuario.select(:usuario, :correo).where(:id => params[:usuario_id]).first.to_json
  end

  post '/usuario/nombre_repetido' do
    data = JSON.parse(params[:data])
	  usuario_id = data['id']
 	  usuario = data['usuario']
		rpta = 0
		if usuario_id == 'E'
			#SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ?
			rpta = Usuario.where(:usuario => usuario).count
		else
			#SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ? AND id = ?
			rpta = Usuario.where(:usuario => usuario, :id => usuario_id).count
			if rpta == 1
				rpta = 0
			else
				#SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ?
				rpta = Usuario.where(:usuario => usuario).count
			end
		end
		rpta.to_s
  end

  post '/usuario/correo_repetido' do
    data = JSON.parse(params[:data])
    usuario_id = data['id']
    correo = data['correo']
    rpta = 0
    if usuario_id == 'E'
      #SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ?
      rpta = Usuario.where(:correo => correo).count
    else
      #SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ? AND id = ?
      rpta = Usuario.where(:correo => correo, :id => usuario_id).count
      if rpta == 1
        rpta = 0
      else
        #SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ?
        rpta = Usuario.where(:correo => correo).count
      end
    end
    rpta.to_s
  end

  post '/usuario/guardar_usuario_correo' do
		data = JSON.parse(params[:usuario])
		error = false
		execption = nil
		id = data['id']
	  usuario = data['usuario']
 	  correo = data['correo']
		DB.transaction do
			begin
				e = Usuario.where(:id => id).first
				e.usuario = usuario
				e.correo = correo
				e.save
			rescue Exception => e
				error = true
				execption = e
				Sequel::Rollback
			end
	  end
		if error == false
			return {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado los cambios en los datos generales del usuario', []]}.to_json
		else
      status 500
			return {:tipo_mensaje => 'error', :mensaje => ['Se ha producido un error en guardar los datos generales del usuario', execption.message]}.to_json
		end
	end

  get '/usuario/listar_permisos/:sistema_id/:usuario_id' do
    DB.fetch('
			SELECT T.id AS id, T.nombre AS nombre, (CASE WHEN (P.existe = 1) THEN 1 ELSE 0 END) AS existe, T.llave AS llave FROM
			(
				SELECT id, nombre, llave, 0 AS existe FROM permisos WHERE sistema_id = ' + params[:sistema_id] + '
			) T
			LEFT JOIN
			(
				SELECT P.id, P.nombre,  P.llave, 1 AS existe  FROM permisos P
				INNER JOIN usuarios_permisos UP ON P.id = UP.permiso_id
				WHERE UP.usuario_id = ' + params[:usuario_id] + '
			) P
			ON T.id = P.id').to_a.to_json
  end

  get '/usuario/listar_roles/:sistema_id/:usuario_id' do
    DB.fetch('
			SELECT T.id AS id, T.nombre AS nombre, (CASE WHEN (P.existe = 1) THEN 1 ELSE 0 END) AS existe FROM
			(
				SELECT id, nombre, 0 AS existe FROM roles WHERE sistema_id = ' + params[:sistema_id] + '
			) T
			LEFT JOIN
			(
				SELECT R.id, R.nombre, 1 AS existe  FROM roles R
				INNER JOIN usuarios_roles UR ON R.id = UR.rol_id
				WHERE UR.usuario_id = ' + params[:usuario_id] + '
			) P
			ON T.id = P.id').to_a.to_json
  end

  post '/usuario/guardar_sistemas' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    usuario_id = data['extra']
    usuario_id = data['extra']['usuario_id']
    rpta = []
    error = false
    execption = nil
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = UsuarioSistema.new(:sistema_id => nuevo['id'], :usuario_id => usuario_id)
            n.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            UsuarioSistema.where(:sistema_id => eliminado, :usuario_id => usuario_id).delete
          end
        end
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
      end
    end
    if error == false
      {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado la asociación/deasociación de los sistemas al usuario', []]}.to_json
    else
      status 500
      {:tipo_mensaje => 'error', :mensaje => ['Se ha producido un error en asociar/deasociar los sistemas al usuario', execption.message]}.to_json
    end
  end
end
