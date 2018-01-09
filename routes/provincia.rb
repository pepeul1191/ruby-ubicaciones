class MyApp < Sinatra::Base
  get '/provincia/listar/:departamento_id' do
  	Provincia.select(:id, :nombre).where(:departamento_id => params['departamento_id']).all().to_a.to_json
  end
end