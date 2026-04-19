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

-- Tables without dependency
CREATE TABLE clients (
    id_client SERIAL PRIMARY KEY,
    firstname VARCHAR(30),
    lastname VARCHAR(30),
    passport_number VARCHAR(40),
    nationality VARCHAR(40)
);

CREATE TABLE company (
    id_company SERIAL PRIMARY KEY,
    name_company VARCHAR(50),
    phone VARCHAR(40),
    email VARCHAR(100)
);

-- Tables with dependency
CREATE TABLE employee (
    id_employee SERIAL PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    salary INT,
    title VARCHAR(30),
    id_company INT,
    CONSTRAINT fk_company FOREIGN KEY (id_company) REFERENCES company(id_company) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE plane (
    id_plane SERIAL PRIMARY KEY,
    model VARCHAR(30),
    last_maintenance TIMESTAMP,
    id_company INT NOT NULL,
    CONSTRAINT fk_company_plane FOREIGN KEY (id_company) REFERENCES company(id_company) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE flight (
    id_flight SERIAL PRIMARY KEY,
    origin VARCHAR(60),
    destination VARCHAR(60),
    flight_state VARCHAR(40),
    date_flight TIMESTAMP,
    hour_flight TIME,
    id_plane INT,
    CONSTRAINT fk_plane FOREIGN KEY (id_plane) REFERENCES plane(id_plane) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ticket (
    id_ticket SERIAL PRIMARY KEY,
    date_purchase TIMESTAMP,
    id_client INT NOT NULL,
    id_flight INT NOT NULL,
    CONSTRAINT fk_client FOREIGN KEY (id_client) REFERENCES clients(id_client) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_flight FOREIGN KEY (id_flight) REFERENCES flight(id_flight) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE flight_employee (
    id_employee INT NOT NULL,
    id_flight INT NOT NULL,
    CONSTRAINT fk_employee FOREIGN KEY (id_employee) REFERENCES employee(id_employee) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_flight_emp FOREIGN KEY (id_flight) REFERENCES flight(id_flight) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_employee, id_flight)
);

CREATE TABLE seat ( 
    id_seat SERIAL PRIMARY KEY,
    number_seat VARCHAR(3),
    price INT,
    section VARCHAR(30),
    id_ticket INT NOT NULL,
    CONSTRAINT fk_ticket FOREIGN KEY (id_ticket) REFERENCES ticket(id_ticket) ON DELETE CASCADE ON UPDATE CASCADE
);



