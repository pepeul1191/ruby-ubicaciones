class MyApp < Sinatra::Base
  get '/item/listar/:subtitulo_id' do
    Item.select(:id, :nombre, :url).where(:subtitulo_id => params['subtitulo_id']).all().to_a.to_json
  end
end
