class MyApp < Sinatra::Base
  get '/distrito/listar/:provincia_id' do
  	Distrito.select(:id, :nombre).where(:provincia_id => params['provincia_id']).all().to_a.to_json
  end

  get '/distrito/buscar' do
  	DistritoProvinciaDepartamento.where(Sequel.like(:nombre, params['nombre'] + '%')).limit(10).to_a.to_json
  end

  post '/distrito/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    usuario_id = data['extra']
    provincia_id = data['extra']['provincia_id']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Distrito.new(:nombre => nuevo['nombre'], :provincia_id => provincia_id)
            n.save
            t = {:temporal => nuevo['id'], :nuevo_id => n.id}
            array_nuevos.push(t)
          end
        end
        if editados.length != 0
          editados.each do |editado|
            e = Distrito.where(:id => editado['id']).first
            e.nombre = editado['nombre']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Distrito.where(:id => eliminado).delete
          end
        end
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
      end
    end
    if error == false
      return {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado los cambios en los distritos', array_nuevos]}.to_json
    else
      status 500
      return {:tipo_mensaje => 'error', :mensaje => ['Se ha producido un error en guardar la tabla de distritos', execption.message]}.to_json
    end
  end
end