class MyApp < Sinatra::Base
  get '/rol/listar/:sistema_id' do
    Rol.select(:id, :nombre).where(:sistema_id => params[:sistema_id]).to_a.to_json
  end

  post '/rol/guardar' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    usuario_id = data['extra']
    sistema_id = data['extra']['sistema_id']
    rpta = []
    array_nuevos = []
    error = false
    execption = nil
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = Rol.new(:nombre => nuevo['nombre'], :sistema_id => sistema_id)
            n.save
            t = {:temporal => nuevo['id'], :nuevo_id => n.id}
            array_nuevos.push(t)
          end
        end
        if editados.length != 0
          editados.each do |editado|
            e = Rol.where(:id => editado['id']).first
            e.nombre = editado['nombre']
            e.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            Rol.where(:id => eliminado).delete
          end
        end
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
      end
    end
    if error == false
      return {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado los cambios en los roles', array_nuevos]}.to_json
    else
      status 500
      return {:tipo_mensaje => 'error', :mensaje => ['Se ha producido un error en guardar la tabla de roles', e.message]}.to_json
    end
  end

  post '/rol/asociar_permisos' do
    data = JSON.parse(params[:data])
    nuevos = data['nuevos']
    editados = data['editados']
    eliminados = data['eliminados']
    usuario_id = data['extra']
    rol_id = data['extra']['id_rol']
    rpta = []
    error = false
    execption = nil
    DB.transaction do
      begin
        if nuevos.length != 0
          nuevos.each do |nuevo|
            n = RolPermiso.new(:permiso_id => nuevo['id'], :rol_id => rol_id)
            n.save
          end
        end
        if eliminados.length != 0
          eliminados.each do |eliminado|
            RolPermiso.where(:permiso_id => eliminado, :rol_id => rol_id).delete
          end
        end
      rescue Exception => e
        Sequel::Rollback
        error = true
        execption = e
      end
    end
    if error == false
      return {:tipo_mensaje => 'success', :mensaje => ['Se ha registrado la asociación/deasociación de los permisos al rol', []]}.to_json
    else
      status 500
      return {:tipo_mensaje => 'error', :mensaje => ['Ha ocurrido un error en registrar la asociación/deasociación de los permisos al rol', e.message]}.to_json
    end
  end
end
