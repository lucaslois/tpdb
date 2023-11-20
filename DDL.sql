DROP DATABASE tp_db;
create database tp_db;

use tp_db;

CREATE TABLE EstadoTickets (
	Id VARCHAR(2) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE EstadoClientes (
	Id VARCHAR(2) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE EstadoEmpleados (
	Id VARCHAR(2) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Empleados(
	Login VARCHAR(255) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL,
	Apellido VARCHAR(255) NOT NULL,
	IdEstado VARCHAR(2),

	FOREIGN KEY (IdEstado) REFERENCES EstadoEmpleados(Id)
);

CREATE TABLE Clientes (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(255) NOT NULL,
    Apellido VARCHAR(255) NOT NULL,
    TipoDoc VARCHAR(25) NOT NULL,
    NroDoc INT NOT NULL,
    Email VARCHAR(255),
    FechaNacimiento DATE,
    IdEstado VARCHAR(2),

    FOREIGN KEY (IdEstado) REFERENCES EstadoClientes(Id)
);

CREATE TABLE Servicios (
	Id VARCHAR(2) PRIMARY KEY,
	Nombre VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE EstadoServicios (
    Id VARCHAR(2) PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE ServiciosContratados (
	NroServicio INT PRIMARY KEY IDENTITY(1,1),
	Telefono INT,
	FechaInicio DateTime NOT NULL,
	IdCliente INT NOT NULL,
	IdServicio VARCHAR(2) NOT NULL,
	Calle VARCHAR(255) NOT NULL,
	Piso INT,
	Numero VARCHAR(255),
	Departamento VARCHAR(5),
	IdEstadoServicio VARCHAR(2),

	FOREIGN KEY (IdCliente) REFERENCES Clientes(Id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (IdServicio) REFERENCES Servicios(Id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
	FOREIGN KEY (IdEstadoServicio) REFERENCES EstadoServicios(Id)
);

CREATE TABLE Tipologias (
	Id VARCHAR(2) PRIMARY KEY,
	Nombre VARCHAR(255) UNIQUE
);

CREATE TABLE SLA (
	IdTipologia VARCHAR(2) NOT NULL,
	IdServicio VARCHAR(2) NOT NULL,
	TiempoMaximo INT,

	PRIMARY KEY (IdTipologia, IdServicio),

	FOREIGN KEY (IdServicio) REFERENCES Servicios(Id)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (IdTipologia) REFERENCES Tipologias(Id)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
);

CREATE TABLE Tickets (
	Id INT PRIMARY KEY IDENTITY(1,1),
	FechaApertura DateTime,
	FechaResolucion DateTime,
	FechaCierre DateTime,
	TiempoPendiente INT,
	IdTipologia VARCHAR(2) NOT NULL,
	NroServicio INT,
	IdCliente INT NOT NULL, 
	IdEstado VARCHAR(2) NOT NULL,
	Login VARCHAR(255) NOT NULL,

	FOREIGN KEY (IdTipologia) REFERENCES Tipologias(Id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (NroServicio) REFERENCES ServiciosContratados(NroServicio)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (IdCliente) REFERENCES Clientes(Id),
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (IdEstado) REFERENCES EstadoTickets(Id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	FOREIGN KEY (Login) REFERENCES Empleados(Login)
		ON DELETE SET NULL
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
	ViejoEstado VARCHAR(2),
	NuevoEstado VARCHAR(2),
	IdTicket INT,
	FechaHoraInicio DATETIME,
    FechaHoraFin DATETIME,
	
	FOREIGN KEY (ViejoEstado) REFERENCES EstadoTickets(Id),
    FOREIGN KEY (NuevoEstado) REFERENCES EstadoTickets(Id),
    FOREIGN KEY (IdTicket) REFERENCES Tickets(Id)
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