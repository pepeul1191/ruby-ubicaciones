# Ruby Accesos - SQLite3

Basado en boilerplate wixel de Sinatra. Gestión de las ubicaciones (departamento, provincia y distritos) del Perú.

### Antes de usar

  $ bundler install

### Rutas

  + 

### Migraciones

Ejecutar migración

    $ sequel -m path/to/migrations postgres://host/database
    $ sequel -m path/to/migrations sqlite://db/db_ubicaciones.db
    $ sequel -m path/to/migrations mysql://root:123@localhost/db_ubicaciones

Ejecutar el 'down' de las migraciones de la última a la primera:

    $ sequel -m db/migrations -M 0 mysql://root:123@localhost/db_ubicaciones

Ejecutar el 'up' de las migraciones hasta un versión especifica:

    $ sequel -m db/migrations -M #version mysql://root:123@localhost/db_ubicaciones

Crear Vista de distrito/provincia/departamento

    >> CREATE VIEW vw_distrito_provincia_departamento AS select DI.id AS id,concat(DI.nombre,', ',PR.nombre,', ',DE.nombre) AS nombre from ((distritos DI join provincias PR on((DI.provincia_id = PR.id))) join departamentos DE on((PR.departamento_id = DE.id))) limit 2000;

Tipos de Datos de Columnas

+ :string=>String
+ :integer=>Integer
+ :date=>Date
+ :datetime=>[Time, DateTime].freeze, 
+ :time=>Sequel::SQLTime, 
+ :boolean=>[TrueClass, FalseClass].freeze, 
+ :float=>Float
+ :decimal=>BigDecimal
+ :blob=>Sequel::SQL::Blob

# Fuentes:

+ https://github.com/Wixel/Frank-Sinatra
+ https://github.com/jeremyevans/sequel
+ http://sequel.jeremyevans.net/rdoc/files/doc/dataset_filtering_rdoc.html
+ http://sequel.jeremyevans.net/rdoc/files/doc/cheat_sheet_rdoc.html