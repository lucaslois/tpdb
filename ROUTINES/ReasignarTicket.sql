CREATE PROCEDURE ReasignarTicket @idTicket INT, @idCliente INT
AS
BEGIN
    IF(EXISTS(SELECT Id FROM Clientes WHERE Id = @idCliente AND IdEstado = 'IN'))
        RAISERROR('No se puede asignar un ticket a un cliente inactivo', 1, 4)
    ELSE
    UPDATE Tickets SET IdCliente = @idCliente WHERE Id = @idTicket;
end
go

