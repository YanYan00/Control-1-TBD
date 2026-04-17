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
USE airport;
-- query 1
SELECT f.destination, COUNT(*) AS total_viajes
FROM ticket t
JOIN clients c ON t.id_client = c.id_client
JOIN flight f ON f.id_flight = t.id_flight
WHERE c.nationality = 'Chile' 
  AND f.date_flight >= NOW() - INTERVAL 4 YEAR
GROUP BY f.destination
ORDER BY total_viajes DESC;


-- query 2 
-- listar las secciones mas compradas por argentinos
SELECT s.section, COUNT(*) AS total_compras 
FROM ticket t 
JOIN clients c ON c.id_client = t.id_client
JOIN seat s ON s.id_ticket = t.id_ticket
WHERE c.nationality = "Argentina"
GROUP BY s.section
ORDER BY total_compras DESC;


-- query 3
SELECT mes, nationality, total_personas
FROM (
    SELECT 
        MONTH(f.date_flight) AS mes, 
        c.nationality, 
        COUNT(*) AS total_personas,
        ROW_NUMBER() OVER(PARTITION BY MONTH(f.date_flight) ORDER BY COUNT(*) DESC) AS ranking -- por cada mes se hace un ranking del total de personas
    FROM ticket t
    JOIN clients c ON t.id_client = c.id_client
    JOIN flight f ON f.id_flight = t.id_flight -- Se crea la tabla que relaciona pasajero con vuelo
    WHERE f.date_flight >= DATE_SUB(CURDATE(), INTERVAL 4 YEAR) -- filtro 4 años
      AND f.date_flight <= CURDATE()
    GROUP BY mes, c.nationality -- Se ordena esta tabla de pasajero vuelo por pais
) AS tabla_ranking
WHERE ranking = 1
ORDER BY mes; -- sacame solo los ranking 1 ordenados por mes


-- query 4
SELECT 
    c.firstname, 
    c.lastname, 
    MONTH(t.date_purchase) AS mes, 
    COUNT(*) AS cantidad_vuelos
FROM ticket t
JOIN clients c ON t.id_client = c.id_client
JOIN seat s ON t.id_ticket = s.id_ticket  -- Tabla union persona asiento por ticket
WHERE s.section = 'First Class' -- todos los primera lase
GROUP BY mes, c.id_client, c.firstname, c.lastname -- se ordena por mes  y persona
HAVING cantidad_vuelos > 4 -- que tenga mas de 4 vuelos
ORDER BY mes ASC, cantidad_vuelos DESC;