CrearCliente 'Lois', 'Lucas', 'DNI', '38707793', '2010-01-30', 'lucaslois95@gmail.com';

dbo.CrearServicio @idTipoServicio = 'IN', @idCliente = 18, @telefono = '1157035553', @calle = 'Av Cabildo', @altura = 2088, @piso = '', @depto = '';

dbo.InactivarServicio 14;

dbo.CrearTicket @idTipologia = 'AS', @nroServicio = 2, @idUsuario = 1;

dbo.CambiarEstodoDeTicket 14, 'PC';

dbo.ReasignarTicket 14, 7;

dbo.EditarCliente 7, 'Lucas', 'Lois', '1995-01-30';

dbo.CalcularDemoraResolucion 3;

dbo.ExistetTipologiaParaServicio 14, 'AS'