require_relative './datbase'

class EstadoUsuario < Sequel::Model(DB)
  	:estado_usuarios
end

class Usuario < Sequel::Model(DB)
  	:usuarios
end