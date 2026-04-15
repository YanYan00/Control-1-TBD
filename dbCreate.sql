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

-- Tables without dependency of other
CREATE TABLE client (
    id_client INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(30),
    lastname VARCHAR(30),
    passport_number VARCHAR(40),
    nationality VARCHAR(40)
);
CREATE TABLE  employee(
	id_employee INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    salary INT,
    title VARCHAR(30)
);
CREATE TABLE company (
    id_company INT PRIMARY KEY AUTO_INCREMENT,
    name_company VARCHAR(50),
    phone VARCHAR(40),
    email VARCHAR(100)
);
-- Tables with dependency of other
CREATE TABLE flight(
    id_flight INT PRIMARY KEY AUTO_INCREMENT,
    origin VARCHAR(60),
    destination VARCHAR(60),
    flight_state VARCHAR(40),
    date_flight DATETIME,
    hour_flight TIME,
    id_plane INT,
    FOREIGN KEY (id_plane) REFERENCES plane(id_plane) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE ticket (
    id_ticket INT PRIMARY KEY AUTO_INCREMENT,
    date_purchase DATETIME,
    id_client INT NOT NULL
    FOREIGN KEY (id_client) REFERENCES client(id_client) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE seat ( 
    id_seat INT PRIMARY KEY AUTO_INCREMENT,
    number_seat VARCHAR(3),
    price INT,
    section VARCHAR(30),
    id_ticket INT NOT NULL,
    FOREIGN KEY (id_ticket) REFERENCES ticket(id_ticket) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE plane(
	id_plane INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(15),
    last_maintenance DATETIME,
    id_company INT NOT NULL,
    FOREIGN KEY (id_company) REFERENCES company(id_company) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE flight_employee(
	id_employee INT NOT NULL,
    id_flight INT NOT NULL,
    FOREIGN KEY (id_employee) REFERENCES employee(id_employee) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_flight) REFERENCES flight(id_flight) ON DELETE CASCADE ON UPDATE CASCADE
)