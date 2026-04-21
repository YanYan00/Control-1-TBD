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
--Lista de lugares al que más viajan los chilenos por año (durante los últimos 4 años)
SELECT f.destination, COUNT(*) AS total_viajes
FROM ticket t
JOIN clients c ON t.id_client = c.id_client
JOIN flight f ON f.id_flight = t.id_flight
WHERE c.nationality = 'Chile' 
  AND f.date_flight >= NOW() - INTERVAL '4 years'
GROUP BY f.destination
ORDER BY total_viajes DESC;


-- query 2 
-- Lista con las secciones de vuelos más compradas por argentinos
SELECT s.section, COUNT(*) AS total_compras 
FROM ticket t 
JOIN clients c ON c.id_client = t.id_client
JOIN seat s ON s.id_ticket = t.id_ticket
WHERE c.nationality = 'Argentina'
GROUP BY s.section
ORDER BY total_compras DESC;


-- query 3
-- Lista mensual de países que más gastan en volar (durante los últimos 4 años)
-- query 3
SELECT DISTINCT ON (mes)
    EXTRACT(MONTH FROM f.date_flight) AS mes,
    c.nationality,
    COUNT(*) AS total_personas
FROM ticket t
JOIN clients c ON t.id_client = c.id_client
JOIN flight f ON f.id_flight = t.id_flight
WHERE f.date_flight >= NOW() - INTERVAL '4 years'
GROUP BY mes, c.nationality
ORDER BY mes, total_personas DESC;

-- query 4
-- Lista de pasajeros que viajan en “First Class” más de 4 veces al mes
SELECT 
    c.firstname, 
    c.lastname, 
    EXTRACT(MONTH FROM t.date_purchase) AS mes, 
    COUNT(*) AS cantidad_vuelos
FROM ticket t
JOIN clients c ON t.id_client = c.id_client
JOIN seat s ON t.id_ticket = s.id_ticket
WHERE s.section = 'First Class'
GROUP BY mes, c.id_client, c.firstname, c.lastname
HAVING COUNT(*) > 4 -- 4 Veces no existen pero 2 si
ORDER BY mes ASC, cantidad_vuelos DESC;

-- query 5
-- Avión con menos vuelos
SELECT p.id_plane, COUNT(f.id_flight) AS total_aviones
FROM plane p
LEFT JOIN flight f ON p.id_plane = f.id_plane
GROUP BY p.id_plane
ORDER BY total_aviones ASC
LIMIT 1;


-- query 6
-- Lista mensual de pilotos con mayor sueldo (durante los últimos 4 años)
SELECT
	e.firstname,
	e.lastname,
	e.salary,
	EXTRACT(MONTH FROM f.date_flight) AS mes,
	EXTRACT(YEAR FROM f.date_flight) AS anio
FROM employee e
JOIN flight_employee f_e ON e.id_employee = f_e.id_employee
JOIN flight f ON f_e.id_flight = f.id_flight
WHERE e.title = 'Piloto'
	AND f.date_flight >= CURRENT_DATE - INTERVAL '4 years'
	AND e.salary = (
		SELECT MAX(es.salary)
		FROM employee es
		JOIN flight_employee f_es ON es.id_employee = f_es.id_employee
		JOIN flight fse ON f_es.id_flight = fse.id_flight
		WHERE es.title = 'Piloto'
			AND EXTRACT(MONTH FROM fse.date_flight) = EXTRACT(MONTH FROM f.date_flight)
			AND EXTRACT(YEAR FROM fse.date_flight) = EXTRACT(YEAR FROM f.date_flight)
	)
ORDER BY anio DESC, mes DESC;
	
--query 7
-- Lista de compañías indicando cuál es el avión que más ha recaudado en los últimos 4 años y cuál es el monto recaudado
WITH recaudation AS (
    SELECT
        c.id_company,
        c.name_company,
        p.id_plane,
        p.model AS plane_model,
        SUM(s.price) AS total_recaudation,
        ROW_NUMBER() OVER (
            PARTITION BY c.id_company
            ORDER BY SUM(s.price) DESC
        ) AS rn
    FROM company c
    JOIN plane p ON p.id_company = c.id_company
    JOIN flight f ON f.id_plane = p.id_plane
    JOIN ticket t ON t.id_flight = f.id_flight
    JOIN seat s ON s.id_ticket = t.id_ticket
    WHERE f.date_flight >= NOW() - INTERVAL '4 years'
    GROUP BY c.id_company, c.name_company, p.id_plane, p.model
)
SELECT
    id_company,
    name_company,
    id_plane,
    plane_model,
    total_recaudation
FROM recaudation
WHERE rn = 1
ORDER BY id_company;


--query 8
-- Lista de compañías y total de aviones por año (en los últimos 10 años)
SELECT
    c.id_company,
    c.name_company,
    EXTRACT(YEAR FROM f.date_flight) AS years,
    COUNT(DISTINCT p.id_plane) AS total_planes
FROM company c
JOIN plane p ON p.id_company = c.id_company
JOIN flight f ON f.id_plane = p.id_plane
WHERE f.date_flight >= NOW() - INTERVAL '10 years'
GROUP BY c.id_company, c.name_company, EXTRACT(YEAR FROM f.date_flight)
ORDER BY years;


--query 9
-- Lista anual de compañías que en promedio han pagado más a sus empleados (durante los últimos 10 años).
SELECT DISTINCT ON (EXTRACT(YEAR FROM f.date_flight)) c.name_company AS company, AVG(e.salary) AS salary, EXTRACT(YEAR FROM f.date_flight) AS year_counting 
FROM flight f
INNER JOIN flight_employee fe ON fe.id_flight = f.id_flight 
INNER JOIN employee e ON e.id_employee = fe.id_employee
INNER JOIN company c ON e.id_company = c.id_company
WHERE EXTRACT(YEAR FROM f.date_flight) BETWEEN EXTRACT(YEAR FROM CURRENT_DATE) - 9 AND EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY EXTRACT(YEAR FROM f.date_flight), c.name_company
ORDER BY EXTRACT(YEAR FROM f.date_flight), AVG(e.salary) DESC;


--query 10
-- Modelo de avión más usado por compañía durante el 2021
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