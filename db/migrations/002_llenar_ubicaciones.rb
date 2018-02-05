require 'sequel'

Sequel.migration do
  up do
    Sequel.connect('sqlite://db/gestion.db')
    #Sequel.connect('mysql2://localhost/gestion?user=root&password=123')
		DB.transaction do
	  	file = File.new('db/data/departamentos.txt', 'r')
			while (line = file.gets)
				line_array = line.split('::')
				id = line_array[0]
				nombre = line_array[1].strip
				#puts id + " - " + nombre
				DB[:departamentos].insert(id: id, nombre: nombre)
      end
      file = File.new('db/data/provincias.txt', 'r')
			while (line = file.gets)
				line_array = line.split('::')
				id = line_array[0]
        nombre = line_array[1]
        departamento_id = line_array[2].strip
				#puts id + " - " + nombre
				DB[:provincias].insert(id: id, nombre: nombre, departamento_id: departamento_id)
      end
      file = File.new('db/data/distritos.txt', 'r')
			while (line = file.gets)
				line_array = line.split('::')
				id = line_array[0]
				nombre = line_array[1]
        provincia_id = line_array[2].strip
				#puts id + " - " + nombre
				DB[:distritos].insert(id: id, nombre: nombre, provincia_id: provincia_id)
			end
		end
  end

	down do
		DB = Sequel.connect('sqlite://db/gestion.db')
    DB[:paises].delete
    DB[:departamentos].delete
    DB[:provincias].delete
    DB[:distritos].delete
	end
end