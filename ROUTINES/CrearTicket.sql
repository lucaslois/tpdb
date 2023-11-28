CREATE PROCEDURE CrearTicket
    @idTipologia VARCHAR(2),
    @nroServicio INT,
    @idCliente INT,
    @login VARCHAR(25),
    @idTicket INT OUTPUT,
    @errorMessage VARCHAR(255) OUTPUT,
    @errorCode INT OUTPUT
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Tipologias WHERE Id = @idTipologia)
        SELECT @errorCode = 4, @errorMessage = 'La tipologia no existe'
    ELSE IF NOT EXISTS(SELECT * FROM ServiciosContratados WHERE NroServicio = @nroServicio AND IdCliente = @idCliente)
        SELECT @errorCode = 7, @errorMessage = 'El servicio no existe o no le pertenece al usuario'
    ELSE IF NOT EXISTS(SELECT * FROM Empleados WHERE Login = @login)
        SELECT @errorCode = 6, @errorMessage = 'El empelado no existe'
    ELSE IF NOT EXISTS(SELECT * FROM Clientes WHERE Id = @idCliente)
        SELECT @errorCode = 5, @errorMessage = 'El cliente no existe'
    ELSE IF (dbo.ExistetTipologiaParaServicio(@nroServicio, @idTipologia) = 0)
        SELECT @errorCode = 2, @errorMessage = 'No existe dicha tipologia para dicho servicio'
    ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRAN
                    INSERT INTO Tickets (FechaApertura, IdTipologia, NroServicio, IdCliente, IdEstado, Login)
                    VALUES (getdate(), @idTipologia, @nroServicio, @idCliente, 'AB', 'amartinez')
                
                    SELECT @idTicket = SCOPE_IDENTITY();
        
                    INSERT INTO HistorialEstados
                        (ViejoEstado, NuevoEstado, IdTicket, FechaHoraInicio)
                    VALUES
                        (NULL, 'AB', @idTicket, GETDATE())
                COMMIT TRAN
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION
            END CATCH
        END
END
go

