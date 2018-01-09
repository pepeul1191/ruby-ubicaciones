class MyApp < Sinatra::Base
  get '/distrito/listar/:provincia_id' do
  	Distrito.select(:id, :nombre).where(:provincia_id => params['provincia_id']).all().to_a.to_json
  end

  get '/distrito/buscar' do
  	DistritoProvinciaDepartamento.where(Sequel.like(:nombre, params['nombre'] + '%')).limit(10).to_a.to_json
  end
end