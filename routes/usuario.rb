class MyApp < Sinatra::Base
    get '/usuario/listar' do
        Usuario.all.to_a.to_json
    end

    post '/usuario/validar' do
  		rpta = Usuario.where(:usuario => params['usuario'], :contrasenia => params['contrasenia']).count()
    	if rpta == 1
    		usuario_id = Usuario.select(:id).where(:usuario => params['usuario'], :contrasenia => params['contrasenia']).first().id
			Acceso.new(:usuario_id => usuario_id, :momento => Time.now).save
    	end
    	rpta.to_s
    end
end