class MyApp < Sinatra::Base
    get '/estado_usuario/listar' do
        EstadoUsuario.all.to_a.to_json
    end
end