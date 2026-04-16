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
JOIN client c ON t.id_client = c.id_client
JOIN flight f ON f.id_flight = t.id_flight
WHERE c.nationality = 'Chile' 
  AND f.date_flight >= NOW() - INTERVAL 4 YEAR
GROUP BY f.destination
ORDER BY total_viajes DESC;


-- query 2 
-- listar las secciones mas compradas por argentinos
SELECT s.section, COUNT(*) AS total_compras 
FROM ticket t 
JOIN client c ON c.id_client = t.id_client
JOIN seat s ON s.id_ticket = t.id_ticket
WHERE c.nationality = "Argentina"
GROUP BY s.section
ORDER BY total_compras DESC;
