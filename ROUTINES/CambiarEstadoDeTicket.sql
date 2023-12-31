CREATE PROCEDURE CambiarEstodoDeTicket
    @idTicket INT,
    @idNuevoEstado VARCHAR(2),
    @errorCode INT OUTPUT,
    @errorMessage VARCHAR(255) OUTPUT
AS
DECLARE
    @estadoActual VARCHAR(2),
    @idCliente INT
BEGIN
    SELECT @estadoActual = IdEstado, @idCliente = IdCliente FROM Tickets WHERE Id = @idTicket
    BEGIN TRY
        IF NOT EXISTS (SELECT * FROM Tickets WHERE Id = @idTicket)
            RAISERROR  ('El ticket especificado no existe', 11, 1);
        ELSE IF NOT EXISTS (SELECT * FROM EstadoTickets WHERE Id = @idNuevoEstado)
            RAISERROR  ('El estado especificado no existe', 11, 1);
        ELSE IF (@estadoActual = 'AB' AND @idNuevoEstado != 'EP')
            RAISERROR  ('Si el ticket está abierto, solo se puede mover a En Progreso', 11, 1);
        ELSE IF (@estadoActual = 'EP' AND NOT @idNuevoEstado IN ('RE', 'PC'))
            RAISERROR  ('Si el ticket está En Progreso, solo se puede mover a Resuelto o Pendiente Cliente', 11, 1);
        ELSE IF (@estadoActual = 'PC' AND @idNuevoEstado != 'EP')
            RAISERROR  ('Si el ticket está Pendiente Cliente, solo se puede mover a En Progreso', 11, 1);
        ELSE
            BEGIN
                BEGIN TRANSACTION ;
                UPDATE Tickets SET IdEstado = @idNuevoEstado WHERE Id = @idTicket;

                IF (@idNuevoEstado = 'RE')
                    UPDATE Tickets SET FechaResolucion = getdate() WHERE Id = @idTicket
                IF (@idNuevoEstado = 'CE')
                    UPDATE Tickets SET FechaCierre = getdate() WHERE Id = @idTicket

                INSERT INTO HistorialEstados
                    (ViejoEstado, NuevoEstado, IdTicket, FechaHoraInicio)
                VALUES
                    (@estadoActual, @idNuevoEstado, @idTicket, GETDATE())

                COMMIT
            END
    END TRY
    BEGIN CATCH
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE()
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRANSACTION
    END CATCH
END
go

