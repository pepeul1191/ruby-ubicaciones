class MyApp < Sinatra::Base
    get '/usuario/listar' do
        Usuario.all.to_a.to_json
    end
end