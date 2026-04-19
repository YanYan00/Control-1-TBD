/*
	Grupo 4 TBD Aerolineas - Sentencias
    Integrantes:
		Jean Rojas
        Manuel Orellana
        Manuel Vasquez
        Luciano Carril
        Belen Ibañez
        Vicente Rojas
*/
-- query 1
SELECT f.destination, COUNT(*) AS total_viajes
FROM ticket t
JOIN clients c ON t.id_client = c.id_client
JOIN flight f ON f.id_flight = t.id_flight
WHERE c.nationality = 'Chile' 
  AND f.date_flight >= NOW() - INTERVAL '4 years'
GROUP BY f.destination
ORDER BY total_viajes DESC;


-- query 2 
-- listar las secciones mas compradas por argentinos
SELECT s.section, COUNT(*) AS total_compras 
FROM ticket t 
JOIN clients c ON c.id_client = t.id_client
JOIN seat s ON s.id_ticket = t.id_ticket
WHERE c.nationality = 'Argentina'
GROUP BY s.section
ORDER BY total_compras DESC;


-- query 3
SELECT mes, nationality, total_personas
FROM (
    SELECT 
        EXTRACT(MONTH FROM f.date_flight) AS mes, 
        c.nationality, 
        COUNT(*) AS total_personas,
        ROW_NUMBER() OVER(PARTITION BY EXTRACT(MONTH FROM f.date_flight) ORDER BY COUNT(*) DESC) AS ranking -- por cada mes se hace un ranking del total de personas
    FROM ticket t
    JOIN clients c ON t.id_client = c.id_client
    JOIN flight f ON f.id_flight = t.id_flight -- Se crea la tabla que relaciona pasajero con vuelo
    WHERE f.date_flight >= CURRENT_DATE - INTERVAL '4 years'  -- filtro 4 años
      AND f.date_flight <= CURRENT_DATE
    GROUP BY mes, c.nationality -- Se ordena esta tabla de pasajero vuelo por pais
) AS tabla_ranking
WHERE ranking = 1
ORDER BY mes; -- sacame solo los ranking 1 ordenados por mes


-- query 4
SELECT 
    c.firstname, 
    c.lastname, 
    EXTRACT(MONTH FROM t.date_purchase) AS mes, 
    COUNT(*) AS cantidad_vuelos
FROM ticket t
JOIN clients c ON t.id_client = c.id_client
JOIN seat s ON t.id_ticket = s.id_ticket  -- Tabla union persona asiento por ticket
WHERE s.section = 'First Class' -- todos los primera lase
GROUP BY mes, c.id_client, c.firstname, c.lastname -- se ordena por mes  y persona
HAVING COUNT(*) > 4 -- que tenga mas de 4 vuelos
ORDER BY mes ASC, cantidad_vuelos DESC;

-- query 5
SELECT p.id_plane, COUNT(f.id_flight) AS total_aviones
FROM plane p
LEFT JOIN flight f ON p.id_plane = f.id_plane
GROUP BY p.id_plane
ORDER BY total_aviones ASC
LIMIT 1;

--query 9
SELECT DISTINCT ON (EXTRACT(YEAR FROM f.date_flight)) c.name_company AS company, AVG(e.salary) AS salary, EXTRACT(YEAR FROM f.date_flight) AS year_counting 
FROM flight f
INNER JOIN flight_employee fe ON fe.id_flight = f.id_flight 
INNER JOIN employee e ON e.id_employee = fe.id_employee
INNER JOIN company c ON e.id_company = c.id_company
WHERE EXTRACT(YEAR FROM f.date_flight) BETWEEN EXTRACT(YEAR FROM CURRENT_DATE) - 9 AND EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY EXTRACT(YEAR FROM f.date_flight), c.name_company
ORDER BY EXTRACT(YEAR FROM f.date_flight), AVG(e.salary) DESC;

--query 10
SELECT c.name_company, p.model,COUNT(f.id_flight) AS flights
FROM plane p
INNER JOIN company c ON p.id_company = c.id_company
INNER JOIN flight f ON p.id_plane = f.id_plane
WHERE EXTRACT(YEAR FROM f.date_flight) = 2021
GROUP BY p.id_company ,c.name_company,p.model
HAVING COUNT(f.id_flight) = (
	SELECT COUNT(f2.id_flight)
	FROM plane p2
	INNER JOIN company c2 ON p2.id_company = c2.id_company
	INNER JOIN flight f2 ON p2.id_plane = f2.id_plane
	WHERE EXTRACT(YEAR FROM f2.date_flight) = 2021 AND p2.id_company = p.id_company
	GROUP BY p2.model
	ORDER BY COUNT(f2.id_flight) DESC
	LIMIT 1
);
