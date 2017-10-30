require_relative './database'

class EstadoUsuario < Sequel::Model(DB[:estado_usuarios])
  	
end

class Usuario < Sequel::Model(DB[:usuarios])
  	
end

class Acceso < Sequel::Model(DB[:accesos])
  	
end

class Modulo < Sequel::Model(DB[:modulos])
  	
end

class Subtitulo < Sequel::Model(DB[:subtitulos])
  	
end

class Item < Sequel::Model(DB[:items])
  	
end

class Permisos < Sequel::Model(DB[:permisos])
  	
end

class Rol < Sequel::Model(DB[:roles])
  	
end

class Sistema < Sequel::Model(DB[:sistemas])
  	
end

class RolPermiso < Sequel::Model(DB[:roles_permisos])
  	
end

class UsuarioPermiso < Sequel::Model(DB[:usuarios_permisos])
  	
end

class UsuarioRol < Sequel::Model(DB[:usuarios_roles])
  	
end

class UsuarioSistema < Sequel::Model(DB[:usuarios_sistemas])
  	
end