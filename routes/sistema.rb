class MyApp < Sinatra::Base
  get '/sistema/listar' do
    Sistema.all.to_a.to_json
  end

  get '/sistema/usuario/:usuario_id' do
    DB.fetch('
      SELECT T.id AS id, T.nombre AS nombre, (CASE WHEN (P.existe = 1) THEN 1 ELSE 0 END) AS existe FROM
      (
        SELECT id, nombre, 0 AS existe FROM sistemas
      ) T
      LEFT JOIN
      (
        SELECT S.id, S.nombre, 1 AS existe FROM sistemas S
        INNER JOIN usuarios_sistemas US ON US.sistema_id = S.id
        WHERE US.usuario_id = ?
      ) P
      ON T.id = P.id', params[:usuario_id]).to_a.to_json
  end

  post '/sistema/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    usuario_id = data['extra']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Sistema.new(:nombre => nuevo['nombre'], :version => nuevo['version'], :repositorio => nuevo['repositorio'])
            n.save
            t = {:temporal => nuevo['id'], :nuevo_id => n.id}
            array_nuevos.push(t)
          end
        end
        if editados.length != 0
          editados.each do |editado|
            e = Sistema.where(:id => editado['id']).first
            e.nombre = editado['nombre']
            e.version = editado['version']
            e.repositorio = editado['repositorio']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Sistema.where(:id => eliminado).delete
          end
        end
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
      end
    end
    if error == false
      return {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado los cambios en los sistemas', array_nuevos]}.to_json
    else
      status 500
      return {:tipo_mensaje => 'error', :mensaje => ['Se ha producido un error en guardar la tabla de sistemas', execption.message]}.to_json
    end
  end
end
