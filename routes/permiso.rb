class MyApp < Sinatra::Base
  get '/permiso/listar/:sistema_id' do
    Permiso.select(:id, :nombre, :llave).where(:sistema_id => params[:sistema_id]).to_a.to_json
  end
end
