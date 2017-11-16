class MyApp < Sinatra::Base
  get '/modulo/listar/:sistema_id' do
    Modulo.select(:id, :url, :nombre).where(:sistema_id => params['sistema_id']).all().to_a.to_json
  end

  post '/modulo/guardar' do
    data = JSON.parse(params[:data])
	  nuevos = data['nuevos']
 	  editados = data['editados']
	  eliminados = data['eliminados']
	  usuario_id = data['extra']
		sistema_id = data['extra']['sistema_id']
		rpta = []
		array_nuevos = []
		error = false
		execption = nil
	  DB.transaction do
			begin
				if nuevos.length != 0
					nuevos.each do |nuevo|
						n = Modulo.new(:nombre => nuevo['nombre'], :url => nuevo['url'], :sistema_id => sistema_id)
						n.save
						t = {:temporal => nuevo['id'], :nuevo_id => n.id}
						array_nuevos.push(t)
					end
				end
				if editados.length != 0
					editados.each do |editado|
						e = Modulo.where(:id => editado['id']).first
						e.nombre = editado['nombre']
						e.url = editado['url']
						e.save
					end
				end
				if eliminados.length != 0
					eliminados.each do |eliminado|
						Modulo.where(:id => eliminado).delete
					end
				end
			rescue Exception => e
				Sequel::Rollback
				error = true
				execption = e
			end
	  end
		if error == false
			return {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado los cambios en los modulos', array_nuevos]}.to_json
		else
      status 500
			return {:tipo_mensaje => 'error', :mensaje => ['Se ha producido un error en guardar la tabla de modulos', execption.message]}.to_json
		end
  end
end
