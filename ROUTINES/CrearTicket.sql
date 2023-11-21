CREATE PROCEDURE CrearTicket @idTipologia VARCHAR(2), @nroServicio INT, @idUsuario INT
AS
BEGIN
    IF (dbo.ExistetTipologiaParaServicio(@nroServicio, @idTipologia) = 0)
        RAISERROR ('No existe una tipologia para tal servicio', 1, 5)
    ELSE
        INSERT INTO Tickets (FechaApertura, IdTipologia, NroServicio, IdCliente, IdEstado, Login)
        VALUES (getdate(), @idTipologia, @nroServicio, @idUsuario, 'AB', 'amartinez')
end
go

