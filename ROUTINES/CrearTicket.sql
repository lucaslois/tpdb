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
    BEGIN TRY
        BEGIN TRANSACTION 
        IF NOT EXISTS(SELECT * FROM Tipologias WHERE Id = @idTipologia)
            RAISERROR('La tipologia no existe', 11, 1)
        ELSE IF NOT EXISTS(SELECT * FROM ServiciosContratados WHERE NroServicio = @nroServicio AND IdCliente = @idCliente)
            RAISERROR('El servicio no existe o no le pertenece al usuario', 11, 1)
        ELSE IF NOT EXISTS(SELECT * FROM Empleados WHERE Login = @login)
            RAISERROR('El empelado no existe', 11, 1)
        ELSE IF NOT EXISTS(SELECT * FROM Clientes WHERE Id = @idCliente)
            RAISERROR('El cliente no existe', 11, 1)
        ELSE IF (dbo.ExistetTipologiaParaServicio(@nroServicio, @idTipologia) = 0)
            RAISERROR('No existe dicha tipologia para dicho servicio', 11, 1)
        ELSE
            BEGIN
                INSERT INTO Tickets (FechaApertura, IdTipologia, NroServicio, IdCliente, IdEstado, Login)
                VALUES (getdate(), @idTipologia, @nroServicio, @idCliente, 'AB', 'amartinez')
            
                SELECT @idTicket = SCOPE_IDENTITY();
    
                INSERT INTO HistorialEstados
                    (ViejoEstado, NuevoEstado, IdTicket, FechaHoraInicio)
                VALUES
                    (NULL, 'AB', @idTicket, GETDATE())
                COMMIT TRAN
            END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE(), @idTicket = -1
    END CATCH
END
go

