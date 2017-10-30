class MyApp < Sinatra::Base
    get '/sistema/listar' do
        Sistema.all.to_a.to_json
    end

    get '/sistema/usuario/:usuario_id' do
        DB.fetch('
        	SELECT T.id AS id, T.nombre AS nombre, (CASE WHEN (P.existe = 1) THEN 1 ELSE 0 END) AS existe FROM
	        (
	            SELECT id, nombre, 0 AS existe FROM sistemas
	        ) T
	        LEFT JOIN
	        (
	            SELECT S.id, S.nombre, 1 AS existe FROM sistemas S
	            INNER JOIN usuarios_sistemas US ON US.sistema_id = S.id
	            WHERE US.usuario_id = ?
	        ) P
	        ON T.id = P.id', params['usuario_id']).to_a.to_json
    end
end