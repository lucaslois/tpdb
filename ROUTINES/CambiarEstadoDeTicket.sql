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
    IF(NOT EXISTS(SELECT * FROM Tickets WHERE Id = @idTicket))
        SELECT @errorCode = 1, @errorMessage = 'El ticket especificado no existe';
    ELSE IF(NOT EXISTS(SELECT * FROM EstadoTickets WHERE Id = @idNuevoEstado))
        SELECT @errorCode = 2, @errorMessage = 'El estado especificado no existe';
    ELSE IF (@estadoActual = 'AB' AND @idNuevoEstado != 'EP')
        SELECT @errorCode = 3, @errorMessage = 'Si el ticket esta abierto, solo se lo puede mover a En Progreso';
    ELSE IF (@estadoActual = 'EP' AND NOT @idNuevoEstado IN ('RE', 'PC'))
        SELECT @errorCode = 4, @errorMessage = 'Si el ticket esta En Progreso, solo se lo puede mover a Resuelto o Pendiente Cliente';
    ELSE IF (@estadoActual = 'PC' AND @idNuevoEstado != 'EP')
        SELECT @errorCode = 5, @errorMessage = 'Si el ticket esta Pendiente Cliente, solo se lo puede mover a En Progreso';
    ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRAN
                    UPDATE Tickets SET IdEstado = @idNuevoEstado WHERE Id = @idTicket;
                    INSERT INTO Notificaciones (IdTicket, IdCliente, CuerpoMail)
                    VALUES (@idTicket, @idCliente, FORMATMESSAGE('Se ha cambiado el estado del ticket %d a %s',
                                                                    @idTicket, @idNuevoEstado));

                    IF (@idNuevoEstado = 'RE')
                        UPDATE Tickets SET FechaResolucion = getdate() WHERE Id = @idTicket
                    IF (@idNuevoEstado = 'CE')
                        UPDATE Tickets SET FechaCierre = getdate() WHERE Id = @idTicket

                   INSERT INTO HistorialEstados
                        (ViejoEstado, NuevoEstado, IdTicket, FechaHoraInicio)
                    VALUES
                        (@estadoActual, @idNuevoEstado, @idTicket, GETDATE())
                COMMIT TRAN
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION
            END CATCH
        END
END
go

