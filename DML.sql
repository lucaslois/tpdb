INSERT INTO EstadoClientes (Id, Nombre)
VALUES ('AC', 'Activo'),
       ('IN', 'Inactivo'),
       ('PR', 'Prospecto');

INSERT INTO EstadoEmpleados (Id, Nombre)
VALUES ('AC', 'Activo'),
       ('IN', 'Inactivo');

INSERT INTO Clientes (Id, Nombre, Apellido, TipoDoc, NroDoc, Email, FechaNacimiento, IdEstado)
VALUES (1, 'Juan Pablo', 'Rodriguez', 'DNI', '24892045', 'juanpablo.r@gmail.com', '1986-03-08', 'AC'),
       (2, 'María Teresa', 'González', 'DNI', '30547896', 'maria.gonzalez@gmail.com', '1990-05-15', 'AC'),
       (3, 'Carlos Alberto', 'López', 'Carnet', '12654832', 'carlos.lopez@hotmail.com', '1982-11-25', 'AC'),
       (4, 'Ana María', 'Martínez', 'Pasap', '78965412', 'ana.martinez@yahoo.com', '1988-07-03', 'AC'),
       (5, 'Luis Fernando', 'Pérez', 'DNI', '56231478', 'luis.perez@gmail.com', '1995-09-12', 'AC'),
       (6, 'Laura Beatriz', 'Fernández', 'Carnet', '48796523', 'laura.fernandez@hotmail.com', '1980-04-18', 'PR'),
       (7, 'Martín Alejandro', 'Gómez', 'Pasaporte', '63258741', 'martin.gomez@yahoo.com', '1993-12-07', 'IN'),
       (8, 'Valeria Soledad', 'Díaz', 'DNI', '74581236', 'valeria.diaz@gmail.com', '1984-08-29', 'AC'),
       (9, 'Ignacio Javier', 'Hernández', 'Carnet', '89632514', 'ignacio.hernandez@hotmail.com', '1997-02-22', 'IN'),
       (10, 'Silvia Carolina', 'Torres', 'Pasaporte', '54123698', 'silvia.torres@yahoo.com', '1989-06-14', 'AC'),
       (11, 'Federico Andrés', 'Ramírez', 'DNI', '47896325', 'federico.ramirez@gmail.com', '1991-10-05', 'AC');

INSERT INTO EstadoTickets (Id, Nombre)
VALUES ('AB', 'Abierto'),
       ('EP', 'En Progreso'),
       ('PC', 'Pendiente Cliente'),
       ('RE', 'Resuelto'),
       ('CE', 'Cerrado');

INSERT INTO Servicios (Id, Nombre)
VALUES ('TE', 'Telefonia'),
       ('IN', 'Internet'),
       ('VO', 'VOIP');

INSERT INTO Tipologias (Id, Nombre)
VALUES ('PR', 'Problemas con la red'),
       ('ST', 'Telefono sin tono'),
       ('SE', 'Telefono sin enlace'),
       ('LR', 'Lentitud en la red'),
       ('CR', 'Cambio de router '),
       ('UV', 'Upgrade de velocidad'),
       ('CG', 'Caida general'),
       ('AS', 'Alta de servicio'),
       ('PE', 'Problema electrico'),
       ('CS', 'Consulta por servicio'),
       ('CP', 'Consulta por pago de servicio'),
       ('CW', 'Configuracion de Wifi');

INSERT INTO Empleados (Login, Nombre, Apellido, IdEstado)
VALUES ('amartinez', 'Alejandro', 'Martinez', 'AC'),
       ('pgomez', 'Pablo', 'Gomez', 'IN');

INSERT INTO ServiciosContratados (NroServicio, Telefono, FechaInicio, IdCliente, IdServicio, Calle, Piso, Numero,
                                  Departamento, Activo)
VALUES (1, '1157035553', '2023-01-20', 1, 'TE', 'Av. Alvarez Thomas 1503', '1', '1', '-', true),
       (2, '1145689321', '2023-02-10', 2, 'TE', 'Calle San Martín 789', '2', '5', 'B', false),
       (3, '1165478965', '2023-03-05', 3, 'VO', 'Av. Rivadavia 2300', '5', '12', 'C', false),
       (4, '1132145789', '2023-04-15', 4, 'IN', 'Calle Uruguay 987', '3', '8', 'D', false),
       (5, '1158965423', '2023-05-20', 5, 'VO', 'Av. Corrientes 456', '4', '3', 'A', true),
       (6, '1147852369', '2023-06-10', 6, 'TE', 'Av. Santa Fe 789', '1', '7', 'F', true),
       (7, '1163254789', '2023-07-15', 7, 'IN', 'Calle Junín 654', '2', '11', 'E', false),
       (8, '1136985472', '2023-08-05', 8, 'IN', 'Av. Córdoba 1234', '6', '9', 'G', false),
       (9, '1154872369', '2023-09-18', 9, 'IN', 'Calle Paraguay 567', '3', '4', 'H', true),
       (10, '1145623789', '2023-10-22', 10, 'VO', 'Av. Scalabrini Ortiz 876', '5', '10', 'I', true);

INSERT INTO Tickets (Id, FechaApertura, FechaResolucion, FechaCierre, TiempoPendiente, IdTipologia, NroServicio,
                     IdCliente, IdEstado, Login)
VALUES (1, '2023-11-10', null, null, 8, 'PR', 2, 1, 'AB', 'pgomez'),
       (2, '2023-11-12', '2023-11-14', '2023-11-14', 2, 'PR', 2, 2, 'RE', 'pgomez'),
       (3, '2023-11-15', '2023-11-18', null, 3, 'PR', 4, 3, 'RE', 'pgomez'),
       (4, '2023-11-18', null, null, 3, 'CS', 5, 1, 'CE', 'pgomez'),
       (5, '2023-11-20', null, null, 6, 'CS', 6, 2, 'PC', 'amartinez'),
       (6, '2023-11-22', null, null, 4, 'CS', 7, 3, 'EP', 'amartinez'),
       (7, '2023-11-25', null, null, 2, 'CS', 8, 1, 'AB', 'amartinez'),
       (8, '2023-11-28', null, null, 6, 'CS', 9, 2, 'AB', 'amartinez'),
       (9, '2023-12-01', null, null, 5, 'CS', 10, 3, 'EP', 'amartinez'),
       (10, '2023-12-05', null, null, 3, 'CS', 1, 1, 'CE', 'amartinez');

insert into HistorialEstados (Id, ViejoEstado, NuevoEstado, IdTicket)
VALUES (1, 'AB', 'RE', 2);

INSERT INTO Actividades (Id, IdTicket, Descripcion, Fecha)
VALUES (1, 1, 'Se envia servicio tecnico para resolver el problema', '2023-11-11');