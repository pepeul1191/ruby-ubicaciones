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
end
