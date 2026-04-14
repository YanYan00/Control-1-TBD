/*
	Grupo 4 TBD Aerolineas - Creacion BD
    Integrantes:
		Jean Rojas
        Manuel Orellana
        Manuel Vasquez
        Luciano Carril
        Belen Ibañez
        Vicente Rojas
*/

CREATE TABLE client (
    id_client INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(30),
    lastname VARCHAR(30),
    rut VARCHAR(30),
    nationality VARCHAR(40)
);
CREATE TABLE ticket (
    id_ticket INT PRIMARY KEY AUTO_INCREMENT,
    date_purchase DATETIME,
    id_client INT NOT NULL
);
CREATE TABLE seat ( 
    id_seat INT PRIMARY KEY AUTO_INCREMENT,
    number_seat VARCHAR(3),
    price INT,
    section VARCHAR(30),
    id_ticket INT NOT NULL
);
CREATE TABLE company (
    id_company INT PRIMARY KEY AUTO_INCREMENT,
    name_company VARCHAR(50),
    phone VARCHAR(40),
    email VARCHAR(100),
    id_flight INT NOT NULL
);
CREATE TABLE flight(
    id_flight INT PRIMARY KEY AUTO_INCREMENT,
    origin VARCHAR(60),
    destination VARCHAR(60),
    flight_state VARCHAR(40),
    date_flight DATETIME,
    hour_flight TIME
);
CREATE TABLE plane(
	id_plane INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(15),
    last_maintenance DATETIME,
    id_company INT NOT NULL
);
CREATE TABLE  employee(
	id_employee INT PRIMARY KEY AUTO_INCREMENT,
    salary INT,
    title VARCHAR(30)
);
CREATE TABLE flight_employee(
	id_employee INT NOT NULL,
    id_flight INT NOT NULL
)