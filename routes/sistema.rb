class MyApp < Sinatra::Base
    get '/sistema/listar' do
        Sistema.all.to_a.to_json
    end
end