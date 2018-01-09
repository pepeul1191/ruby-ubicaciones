require_relative './database'

class Departamento < Sequel::Model(DB[:departamentos])

end

class Provincia < Sequel::Model(DB[:provincias])

end

class Distrito < Sequel::Model(DB[:distritos])

end

class DistritoProvinciaDepartamento < Sequel::Model(DB[:vw_distrito_provincia_departamento])

end