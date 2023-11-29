CREATE TRIGGER CrearNotificacion
    ON dbo.Tickets
    AFTER UPDATE
    AS
    DECLARE
        @idTicket      INT,
        @idCliente     INT,
        @idNuevoEstado VARCHAR(2)
BEGIN
    SELECT @idTicket = Id, @idCliente = IdCliente, @idNuevoEstado = IdEstado from inserted;
    INSERT INTO Notificaciones (IdTicket, IdCliente, CuerpoMail, FechaEnvio)
    VALUES (@idTicket, @idCliente, FORMATMESSAGE('Se ha cambiado el estado del ticket %d a %s',
                                                 @idTicket, @idNuevoEstado), GETDATE());

end
go

