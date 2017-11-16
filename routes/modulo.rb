class MyApp < Sinatra::Base
  get '/modulo/listar/:sistema_id' do
    Modulo.select(:id, :url, :nombre).where(:sistema_id => params['sistema_id']).all().to_a.to_json
  end
end
