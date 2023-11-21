CREATE PROCEDURE CrearTicket @idTipologia VARCHAR(2), @nroServicio INT, @idUsuario INT
AS
BEGIN
    INSERT INTO Tickets (FechaApertura, IdTipologia, NroServicio, IdCliente, IdEstado, Login)
    VALUES (getdate(), @idTipologia,  @nroServicio, @idUsuario, 'AB', 'amartinez')
end
go

