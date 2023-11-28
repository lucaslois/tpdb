----- CREAR CLIENTE
DECLARE
    @idCliente INT,
    @errorCode INT,
    @errorMessage VARCHAR(255);

EXEC CrearCliente
    'Lois',
    'Lucas',
    'DNI',
    '38167793',
    '2003-01-30',
    'lucaslois95@gmail.com',
    @idCliente OUTPUT,
    @errorMessage OUTPUT,
    @errorCode OUTPUT

PRINT @idCliente
PRINT @errorCode
PRINT @errorMessage
GO

----- CAMBIAR ESTADO DE TICKET
DECLARE
    @errorCode INT,
    @errorMessage VARCHAR(255);

EXEC CambiarEstodoDeTicket
    24,
    'EP',
    @errorCode OUTPUT,
    @errorMessage OUTPUT

PRINT @errorCode
PRINT @errorMessage
GO

----- CREAR TICKET
DECLARE
    @idServicio INT,
    @errorCode INT,
    @errorMessage VARCHAR(255);

EXEC CrearServicio
    @idTipoServicio = 'TE',
    @idCliente = 1414,
    @telefono = '1157035553',
    @calle = 'Av Cabildo',
    @altura = 2088,
    @piso = '',
    @depto = '',
    @idServicio = @idServicio OUTPUT,
    @errorMessage = @errorMessage OUTPUT,
    @errorCode = @errorCode OUTPUT
;

PRINT @idServicio
PRINT @errorCode
PRINT @errorMessage
GO

----- EditarCliente
DECLARE
    @errorCode INT,
    @errorMessage VARCHAR(255);
EXEC EditarCliente
    14141414,
    'Lucas',
    'Lois',
    '1995-01-30',
    'lucaslois95@gmail.com',
    @errorMessage OUTPUT,
    @errorCode OUTPUT;

PRINT @errorCode
PRINT @errorMessage
GO

----- INACTIVAR SERVICIO
DECLARE
    @errorCode INT,
    @errorMessage VARCHAR(255);
EXEC InactivarServicio
    14,
    @errorMessage OUTPUT,
    @errorCode OUTPUT;
PRINT @errorCode
PRINT @errorMessage
GO

----- REASIGNAR TICKET
DECLARE
    @errorCode INT,
    @errorMessage VARCHAR(255);
EXEC ReasignarTicket
    14,
    'eltucu',
    @errorMessage OUTPUT,
    @errorCode OUTPUT
;
PRINT @errorCode
PRINT @errorMessage
GO

----- CREAR TICKET
DECLARE
    @idTicket INT,
    @errorCode INT,
    @errorMessage VARCHAR(255);
EXEC dbo.CrearTicket
    @idTipologia = 'AS',
    @nroServicio = 1,
    @idCliente = 1,
    @login = 'amartinez',
    @idTicket = @idTicket OUTPUT ,
    @errorCode = @errorCode OUTPUT ,
    @errorMessage = @errorMessage OUTPUT ;

PRINT @idTicket
PRINT @errorCode
PRINT @errorMessage
GO






dbo.CalcularDemoraResolucion 3;

dbo.ExistetTipologiaParaServicio 14, 'AS'