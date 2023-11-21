CREATE PROCEDURE CambiarEstodoDeTicket @idTicket INT, @idNuevoEstado VARCHAR(2)
AS
    DECLARE @estadoActual VARCHAR(2);
BEGIN
    SELECT @estadoActual = IdEstado FROM Tickets WHERE Id = @idTicket
    IF(@estadoActual = 'AB' AND @idNuevoEstado != 'EP')
        RAISERROR('Si el ticket esta abierto, solo se lo puede mover a En Progreso', 1, 3);
    ELSE IF(@estadoActual = 'EP' AND NOT @idNuevoEstado IN ('RE', 'PC'))
        RAISERROR('Si el ticket esta En Progreso, solo se lo puede mover a Resuelto o Pendiente Cliente', 1, 3);
    ELSE IF(@estadoActual = 'PC' AND @idNuevoEstado != 'EP')
        RAISERROR('Si el ticket esta Pendiente Cliente, solo se lo puede mover a En Progreso', 1, 3);
    ELSE
        BEGIN
            UPDATE Tickets SET IdEstado = @idNuevoEstado WHERE Id = @idTicket;

            IF(@idNuevoEstado = 'RE')
                UPDATE Tickets SET FechaResolucion = getdate() WHERE Id = @idTicket
            IF(@idNuevoEstado = 'CE')
                UPDATE Tickets SET FechaCierre = getdate() WHERE Id = @idTicket
        END
end
go

