class MyApp < Sinatra::Base
  get '/subtitulo/listar/:modulo_id' do
    Subtitulo.select(:id, :nombre).where(:modulo_id => params['modulo_id']).all().to_a.to_json
  end
end
