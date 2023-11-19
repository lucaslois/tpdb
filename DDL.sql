DROP DATABASE tp_db;
create database tp_db;

use tp_db;

CREATE TABLE EstadoTickets (
	Id VARCHAR(2) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL
);

CREATE TABLE EstadoClientes (
	Id VARCHAR(2) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL
);

CREATE TABLE EstadoEmpleados (
	Id VARCHAR(2) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Empleados(
	Login VARCHAR(255) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL,
	Apellido VARCHAR(255) NOT NULL,
	IdEstado VARCHAR(2),

	FOREIGN KEY (IdEstado) REFERENCES EstadoEmpleados(Id)
);

CREATE TABLE Clientes (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Apellido VARCHAR(255) NOT NULL,
    TipoDoc VARCHAR(25) NOT NULL,
    NroDoc INT NOT NULL,
    Email VARCHAR(255) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    IdEstado VARCHAR(2),

    FOREIGN KEY (IdEstado) REFERENCES EstadoClientes(Id)
);

CREATE TABLE Servicios (
	Id VARCHAR(2) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL
);

CREATE TABLE ServiciosContratados (
	NroServicio INT PRIMARY KEY,
	Telefono INT NOT NULL,
	FechaInicio DateTime NOT NULL,
	IdCliente INT NOT NULL,
	IdServicio VARCHAR(2),
	Calle VARCHAR(255) NOT NULL,
	Piso INT,
	Numero INT,
	Departamento VARCHAR(5),
	Activo BOOLEAN,

	FOREIGN KEY (IdCliente) REFERENCES Clientes(Id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (IdServicio) REFERENCES Servicios(Id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE Tipologias (
	Id VARCHAR(2) PRIMARY KEY ,
	Nombre VARCHAR(255)
);

CREATE TABLE SLA (
	IdTipologia VARCHAR(2),
	IdServicio VARCHAR(2),
	TiempoMaximo INT,

	PRIMARY KEY (IdTipologia, IdServicio),

	FOREIGN KEY (IdServicio) REFERENCES Servicios(Id),
	FOREIGN KEY (IdTipologia) REFERENCES Tipologias(Id)
);

CREATE TABLE Tickets (
	Id INT PRIMARY KEY,
	FechaApertura DateTime,
	FechaResolucion DateTime,
	FechaCierre DateTime,
	TiempoPendiente INT,
	IdTipologia VARCHAR(2),
	NroServicio INT,
	IdCliente INT,
	IdEstado VARCHAR(2),
	Login VARCHAR(255),

	FOREIGN KEY (IdTipologia) REFERENCES Tipologias(Id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (NroServicio) REFERENCES ServiciosContratados(NroServicio)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (IdCliente) REFERENCES Clientes(Id),
	FOREIGN KEY (IdEstado) REFERENCES EstadoTickets(Id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (Login) REFERENCES Empleados(Login)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE Actividades(
	Id INT PRIMARY KEY,
	IdTicket INT,
	Descripcion VARCHAR(255),
	Fecha DATETIME NOT NULL,

	FOREIGN KEY (IdTicket) REFERENCES Tickets(Id)
);

CREATE TABLE HistorialEstados (
	Id INT PRIMARY KEY,
	ViejoEstado VARCHAR(2) REFERENCES EstadoTickets(Id),
	NuevoEstado VARCHAR(2) REFERENCES EstadoTickets(Id),
	IdTicket INT
);

CREATE TABLE Notificaciones (
	Id INT PRIMARY KEY,
	IdTicket INT NOT NULL,
	IdCliente INT NOT NULL,
	CuerpoMail VARCHAR(255),
	FechaEnvio DATETIME,

	FOREIGN KEY (IdTicket) REFERENCES Tickets(Id),
	FOREIGN KEY (IdCliente) REFERENCES Clientes(Id)
);