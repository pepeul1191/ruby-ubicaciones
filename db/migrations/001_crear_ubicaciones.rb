require 'sequel'

Sequel.migration do
  up do
    create_table(:departamentos) do
      primary_key :id
      String :nombre, null: false, size: 30
    end

    create_table(:provincias) do
      primary_key :id
      String :nombre, null: false, size: 30
    end

    alter_table(:provincias) do
      add_foreign_key :departamento_id, :departamentos
    end
    
    create_table(:distritos) do
      primary_key :id
      String :nombre, null: false, size: 30
    end

    alter_table(:distritos) do
      add_foreign_key :provincia_id, :provincias
    end
	end

  down do
    drop_column :distritos, :provincia_id
    drop_table(:distritos)
    drop_column :provincias, :departamento_id
    drop_table(:provincias)
    drop_column :departamentos, :pais_id
    drop_table(:departamentos)
    drop_table(:paises)
	end
end