class MyApp < Sinatra::Base
  get '/departamento/listar' do
    Departamento.all.to_a.to_json
  end
end