class MyApp < Sinatra::Base
  get '/subtitulo/listar/:modulo_id' do
    Subtitulo.select(:id, :nombre).where(:modulo_id => params['modulo_id']).all().to_a.to_json
  end

  post '/subtitulo/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    usuario_id = data['extra']
    modulo_id = data['extra']['id_modulo']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Subtitulo.new(:nombre => nuevo['nombre'], :modulo_id => modulo_id)
            n.save
            t = {:temporal => nuevo['id'], :nuevo_id => n.id}
            array_nuevos.push(t)
          end
        end
        if editados.length != 0
          editados.each do |editado|
            e = Subtitulo.where(:id => editado['id']).first
            e.nombre = editado['nombre']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Subtitulo.where(:id => eliminado).delete
          end
        end
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
      end
    end
    if error == false
      return {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado los cambios en los subtitulos', array_nuevos]}.to_json
    else
      status 500
      return {:tipo_mensaje => 'error', :mensaje => ['Se ha producido un error en guardar la tabla de subtitulos', execption.message]}.to_json
    end
  end
end
