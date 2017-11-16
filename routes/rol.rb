class MyApp < Sinatra::Base
  get '/rol/listar/:sistema_id' do
    Rol.select(:id, :nombre).where(:sistema_id => params[:sistema_id]).to_a.to_json
  end
end
