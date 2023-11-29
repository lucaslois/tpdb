-----------------------------------
----- TEST CASE #1
----- Prueba: Intentar dar de alta un cliente (prospecto) sin datos mínimos requeridos o erróneos (probar las distintas alternativas de campos)
----- Resultado Esperado: Se debe devolver el error correspondiente
-----------------------------------
DECLARE @idCliente INT, @errorCode INT, @errorMessage VARCHAR(255);
EXEC CrearCliente
     'Lois',
     'Lucas',
     NULL,
     NULL,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage = 'El nombre, apellido, tipodoc y nrodoc son obligatorios')
    PRINT 'TEST CASE #1 (Faltan campos): OK'
ELSE
    PRINT 'TEST CASE #1 (Faltan campos): FAILED'
GO

-----------------------------------
----- TEST CASE #2
----- Prueba: Intentar dar de alta un cliente y es menor de edad
----- Resultado Esperado: Se debe devolver el error correspondiente
-----------------------------------
DECLARE @idCliente INT, @errorCode INT, @errorMessage VARCHAR(255);
EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     38707793,
     '2008-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage = 'El cliente es menor de edad')
    PRINT 'TEST CASE #2 (menor de edad): OK'
ELSE
    PRINT 'TEST CASE #2 (menor de edad): FAILED'
GO

-----------------------------------
----- TEST CASE #3
----- Prueba: Valido que un nuevo cliente se crea siempre como prospecto
----- Resultado Esperado: El cliente recien creado posee estado PR
-----------------------------------
DECLARE @idCliente INT, @errorCode INT, @errorMessage VARCHAR(255), @estadoRecienCreado VARCHAR(2);
EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     38707792,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

SELECT @estadoRecienCreado = IdEstado
FROM Clientes
WHERE Id = @idCliente;

IF (@estadoRecienCreado = 'PR' AND @errorMessage IS NULL)
    PRINT 'TEST CASE #3 (cliente recien creado es PR): OK'
ELSE
    PRINT 'TEST CASE #3 (cliente recien creado es PR): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #4
----- Prueba: Crear un nuevo servicio a un Prospecto
----- Resultado Esperado: Debe crearse el servicio y cambiarse el cliente a Activo Se debe crear el servicio activo
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @estadoCliente VARCHAR(2);
EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     38111757,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #4 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #4 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

SELECT @estadoCliente = IdEstado
FROM Clientes
WHERE Id = @idCliente;

IF (@estadoCliente = 'AC' AND @idServicio != -1 AND @errorMessage IS NULL)
    PRINT 'TEST CASE #4 (servicio recien creado): OK'
ELSE
    PRINT 'TEST CASE #4 (servicio recien creado): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #5
----- Prueba: Crear un nuevo servicio a un Cliente Inactivo
----- Resultado Esperado: Debe crearse el servicio y cambiarse el cliente a Activo Se debe crear el servicio activo
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @estadoCliente VARCHAR(2);
EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     23232121,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #5 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #5 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC InactivarServicio @idServicio, '', ''

EXEC CrearServicio
     'VO',
     @idCliente,
     1153433232,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

SELECT @estadoCliente = IdEstado
FROM Clientes
WHERE Id = @idCliente;

IF (@estadoCliente = 'AC' AND @idServicio != -1 AND @errorMessage IS NULL)
    PRINT 'TEST CASE #5 (servicio recien creado cambia estado de cliente de inactivo a activo): OK'
ELSE
    PRINT 'TEST CASE #5 (servicio recien creado cambia estado de cliente de inactivo a activo): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #6
----- Prueba: Intentar crear un servicio a un prospecto que no tiene email o fecha de nacimiento
----- Resultado Esperado: Debe devolver un error
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @estadoCliente VARCHAR(2);
EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     342317842,
     '1995-01-30',
     NULL,
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #6 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #6 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

IF (@errorMessage = 'El cliente no posee un email')
    PRINT 'TEST CASE #6 (servicio creado a prospecto sin email tira error): OK'
ELSE
    PRINT 'TEST CASE #6 (servicio creado a prospecto sin email tira error): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #7
----- Prueba: Inactivar servicio desactiva el servicio, y si el cliente tiene 1 solo, tmb al cliente
----- Resultado Esperado: Se inactiva el servicio y el cliente
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @estadoCliente VARCHAR(2), @estadoServicio VARCHAR(2);

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     123123123,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #7 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #7 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC InactivarServicio @idServicio, @errorMessage, @errorCode

SELECT @estadoServicio = IdEstadoServicio
FROM ServiciosContratados
WHERE NroServicio = @idServicio;
SELECT @estadoCliente = IdEstado
FROM Clientes
WHERE Id = @idCliente;

IF (@estadoServicio = 'IN' AND @estadoCliente = 'IN')
    PRINT 'TEST CASE #7 (inactivar servicio desactiva cliente y servicio): OK'
ELSE
    PRINT 'TEST CASE #7 (inactivar servicio desactiva cliente y servicio): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #8
----- Prueba: Generar un nuevo ticket
----- Resultado Esperado: Ticket Creado en estado Abierto con el usuario creador como dueño
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @estadoTicket VARCHAR(2), @idOwner INT, @idTicket INT;

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     54236453,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #8 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #8 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC CrearTicket
     'AS',
     @idServicio,
     @idCliente,
     'amartinez',
     @idTicket OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

SELECT @estadoTicket = IdEstado, @idOwner = IdCliente
FROM Tickets
WHERE Id = @idTicket;

IF (@estadoTicket = 'AB' AND @idCliente = @idOwner)
    PRINT 'TEST CASE #8 (ticket recien creado en AB y con owner = cliente): OK'
ELSE
    PRINT 'TEST CASE #8 (ticket recien creado en AB y con owner = cliente): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #9
----- Prueba: Cambio estado de ticket
----- Resultado Esperado: La operacion es permitida y se crea registro en notificaciones
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @idTicket INT;

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     878756434,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #9 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #9 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC CrearTicket
     'AS',
     @idServicio,
     @idCliente,
     'amartinez',
     @idTicket OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

EXEC CambiarEstodoDeTicket
     @idTicket,
     'EP',
     @errorCode OUTPUT,
     @errorMessage OUTPUT

IF EXISTS(SELECT *
          FROM Notificaciones
          WHERE IdTicket = @idTicket
            AND @errorMessage IS NULL)
    PRINT 'TEST CASE #9 (cambiar estado de ticket no genera error y crea notificacion): OK'
ELSE
    PRINT 'TEST CASE #9 (cambiar estado de ticket no genera error y crea notificacion): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #10
----- Prueba: Cambiar el estado de un Ticket a Resuelto
----- Resultado Esperado: La operacion es permitida y se crea registro en notificaciones. El ticket marca fecha de resolucion
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @idTicket INT, @fechaResolucion DATE;

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     12356736,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #10 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #10 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC CrearTicket
     'AS',
     @idServicio,
     @idCliente,
     'amartinez',
     @idTicket OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

EXEC CambiarEstodoDeTicket
     @idTicket,
     'EP',
     @errorCode OUTPUT,
     @errorMessage OUTPUT

EXEC CambiarEstodoDeTicket
     @idTicket,
     'RE',
     @errorCode OUTPUT,
     @errorMessage OUTPUT

SELECT @fechaResolucion = FechaResolucion
FROM Tickets
WHERE Id = @idTicket

IF (@fechaResolucion IS NOT NULL AND @errorMessage IS NULL)
    PRINT 'TEST CASE #10 (cambiar ticket a resuelto marca fecha resolucion): OK'
ELSE
    PRINT 'TEST CASE #10 (cambiar ticket a resuelto marca fecha resolucion): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #11
----- Prueba: Cambiar el estado de un Ticket a uno no permitido
----- Resultado Esperado: Se debe devolver error
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @idTicket INT, @fechaResolucion DATE;

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     12356738,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #11 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #11 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC CrearTicket
     'AS',
     @idServicio,
     @idCliente,
     'amartinez',
     @idTicket OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

EXEC CambiarEstodoDeTicket
     @idTicket,
     'RE',
     @errorCode OUTPUT,
     @errorMessage OUTPUT

IF (@errorMessage = 'Si el ticket está abierto, solo se puede mover a En Progreso')
    PRINT 'TEST CASE #11 (cambiar ticket a invalido marca error): OK'
ELSE
    PRINT 'TEST CASE #11 (cambiar ticket a invalido marca error): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #12
----- Prueba: Reasignar ticket a nuevo empleado
----- Resultado Esperado: Ticket reasignado al nuevo usuario
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @idTicket INT, @nuevoLogin VARCHAR(255)

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     16356532,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #12 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #12 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC CrearTicket
     'AS',
     @idServicio,
     @idCliente,
     'amartinez',
     @idTicket OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

EXEC ReasignarTicket
     @idTicket,
     'mperez',
     @errorMessage OUTPUT,
     @errorCode OUTPUT

SELECT @nuevoLogin = login
FROM Tickets
WHERE Id = @idTicket;

IF (@nuevoLogin = 'mperez' AND @errorMessage IS NULL)
    PRINT 'TEST CASE #12 (Reasignar ticket a nuevo empleado): OK'
ELSE
    PRINT 'TEST CASE #12 (Reasignar ticket a nuevo empleado): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #13
----- Prueba: Intentar reasignar un Ticket a un usuario Inactivo
----- Resultado Esperado: Se devuelve un error
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @idTicket INT

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     16350532,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #13 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #13 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC CrearTicket
     'AS',
     @idServicio,
     @idCliente,
     'amartinez',
     @idTicket OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

EXEC ReasignarTicket
     @idTicket,
     'pgomez',
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage = 'El empleado no esta activo')
    PRINT 'TEST CASE #13 (Asignar ticket a empleado inactivo devuelve error): OK'
ELSE
    PRINT 'TEST CASE #13 (Asignar ticket a empleado inactivo devuelve error): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #14
----- Prueba: Cambiar el estado de un Ticket a Cerrado
----- Resultado Esperado: Se cambiar el estado y registrar la fecha y hora del cambio.
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @idTicket INT, @fechaCierre DATE;

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     52357836,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage IS NULL)
    PRINT 'TEST CASE #14 (cliente creado correctamente): OK'
ELSE
    BEGIN
        PRINT 'TEST CASE #14 (cliente creado correctamente): FAILED'
        PRINT @errorMessage
    END

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC CrearTicket
     'AS',
     @idServicio,
     @idCliente,
     'amartinez',
     @idTicket OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

EXEC CambiarEstodoDeTicket
     @idTicket,
     'EP',
     @errorCode OUTPUT,
     @errorMessage OUTPUT

EXEC CambiarEstodoDeTicket
     @idTicket,
     'CE',
     @errorCode OUTPUT,
     @errorMessage OUTPUT

SELECT @fechaCierre = FechaCierre
FROM Tickets
WHERE Id = @idTicket

IF (@fechaCierre IS NOT NULL AND @errorMessage IS NULL)
    PRINT 'TEST CASE #10 (cambiar ticket a cerrado marca fecha cierre): OK'
ELSE
    PRINT 'TEST CASE #10 (cambiar ticket a cerrado marca fecha cierre): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #15
----- Prueba: Intentar modificar el nombre o apellido para un cliente activo
----- Resultado Esperado: Error
-----------------------------------
DECLARE @idCliente INT, @idServicio INT, @errorCode INT, @errorMessage VARCHAR(255), @idTicket INT, @fechaCierre DATE;

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     52372836,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC EditarCliente
     @idCliente,
     'Lucas',
     NULL,
     NULL,
     NULL,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage =
    'El nombre, apellido y fecha de nacimiento solo pueden ser editados cuando el cliente es un prospecto.')
    PRINT 'TEST CASE #15 (nombre no se puede editar en cliente activo): OK'
ELSE
    PRINT 'TEST CASE #15 (nombre no se puede editar en cliente activo): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #16
----- Prueba: Modificar el nombre, apellido o fecha de nacimiento para un prospecto
----- Resultado Esperado: Se debe modificar el dato

-----------------------------------
DECLARE @idCliente INT, @errorCode INT, @errorMessage VARCHAR(255), @nuevoNombre VARCHAR(255), @nuevoApellido VARCHAR(255), @nuevaFecha VARCHAR(255)

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     5231,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

EXEC EditarCliente
     @idCliente,
     'Martin',
     'Pepe',
     '1994-02-02',
     NULL,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

SELECT @nuevoNombre = Nombre, @nuevoApellido = Apellido, @nuevaFecha = FechaNacimiento
FROM Clientes
WHERE Id = @idCliente;

IF (@nuevoNombre = 'Martin' AND @nuevoApellido = 'Pepe' AND @nuevaFecha = '1994-02-02')
    PRINT 'TEST CASE #15 (edito cliente prospecto): OK'
ELSE
    PRINT 'TEST CASE #15 (edito cliente prospecto): FAILED'
PRINT @errorMessage
GO

-----------------------------------
----- TEST CASE #16
----- Prueba: Modificar el nombre, apellido o fecha de nacimiento para un prospecto
----- Resultado Esperado: Se debe modificar el dato

-----------------------------------
DECLARE @idCliente INT, @errorCode INT, @errorMessage VARCHAR(255), @idServicio INT;

EXEC CrearCliente
     'Lois',
     'Lucas',
     'DNI',
     1234,
     '1995-01-30',
     'lucaslois95@gmail.com',
     @idCliente OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

EXEC CrearServicio
     'IN',
     @idCliente,
     NULL,
     'Avenida Cabildo',
     '123',
     NULL,
     NULL,
     @idServicio OUTPUT,
     @errorMessage OUTPUT,
     @errorCode OUTPUT;

EXEC EditarCliente
     @idCliente,
     NULL,
     NULL,
     '1994-02-02',
     NULL,
     @errorMessage OUTPUT,
     @errorCode OUTPUT

IF (@errorMessage = 'El nombre, apellido y fecha de nacimiento solo pueden ser editados cuando el cliente es un prospecto.')
    PRINT 'TEST CASE #16 (no puedo editar fechanac de cliente activo): OK'
ELSE
    PRINT 'TEST CASE #16 (no puedo editar fechanac de cliente activo): FAILED'
PRINT @errorMessage
GO