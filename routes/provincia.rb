class MyApp < Sinatra::Base
  get '/provincia/listar/:departamento_id' do
  	Provincia.select(:id, :nombre).where(:departamento_id => params['departamento_id']).all().to_a.to_json
  end

  post '/provincia/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    usuario_id = data['extra']
    departamento_id = data['extra']['departamento_id']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Provincia.new(:nombre => nuevo['nombre'], :departamento_id => departamento_id)
            n.save
            t = {:temporal => nuevo['id'], :nuevo_id => n.id}
            array_nuevos.push(t)
          end
        end
        if editados.length != 0
          editados.each do |editado|
            e = Provincia.where(:id => editado['id']).first
            e.nombre = editado['nombre']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Provincia.where(:id => eliminado).delete
          end
        end
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
      end
    end
    if error == false
      return {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado los cambios en las provincias', array_nuevos]}.to_json
    else
      status 500
      return {:tipo_mensaje => 'error', :mensaje => ['Se ha producido un error en guardar la tabla de provincias', execption.message]}.to_json
    end
  end
end