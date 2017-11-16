class MyApp < Sinatra::Base
  get '/item/listar/:subtitulo_id' do
    Item.select(:id, :nombre, :url).where(:subtitulo_id => params['subtitulo_id']).all().to_a.to_json
  end

  post '/item/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    usuario_id = data['extra']
    subtitulo_id = data['extra']['id_subtitulo']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Item.new(:nombre => nuevo['nombre'], :url => nuevo['url'], :subtitulo_id => subtitulo_id)
            n.save
            t = {:temporal => nuevo['id'], :nuevo_id => n.id}
            array_nuevos.push(t)
          end
        end
        if editados.length != 0
          editados.each do |editado|
            e = Item.where(:id => editado['id']).first
            e.nombre = editado['nombre']
            e.url = editado['url']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Item.where(:id => eliminado).delete
          end
        end
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
      end
    end
    if error == false
      return {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado los cambios en los items', array_nuevos]}.to_json
    else
      status 500
      return {:tipo_mensaje => 'error', :mensaje => ['Se ha producido un error en guardar la tabla de items', execption.message]}.to_json
    end
  end
end
