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
join clients c on t.id_client = c.id_client
join flight f on f.id_flight = t.id_flight
WHERE c.nationality = 'Chile' AND f.date_flight >= now() - interval 4 year
GROUP BY f.Destination
ORDER By total_viajes DESC;


-- query 2 
-- listar las secciones mas compradas por argentinos

SELECT s.seccion, count(*) AS total_compras 
FROM ticket t 
JOIN clients c on c.id_client = t.id_client
JOIN seat s on s.id_ticket=t.id_ticket
where c.nationality = "Argentino"
GROUP BY s.section
ORDER BY total_compras desc;
