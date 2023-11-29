CREATE PROCEDURE CrearTicket
    @idTipologia VARCHAR(2),
    @nroServicio INT,
    @idCliente INT,
    @login VARCHAR(25),
    @idTicket INT OUTPUT,
    @errorMessage VARCHAR(255) OUTPUT,
    @errorCode INT OUTPUT
AS
    DECLARE
        @estadoCliente VARCHAR(2),
        @idDueño INT;
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT * FROM Tipologias WHERE Id = @idTipologia)
            RAISERROR('La tipologia no existe', 11, 1)
        ELSE IF NOT EXISTS(SELECT @idDueño = IdCliente FROM ServiciosContratados WHERE NroServicio = @nroServicio AND IdCliente = @idCliente)
            RAISERROR('El servicio no existe', 11, 1)
        ELSE IF (@idDueño != @idCliente)
            RAISERROR('El servicio no le pertenece al cliente', 11, 1)
        ELSE IF NOT EXISTS(SELECT * FROM Empleados WHERE Login = @login)
            RAISERROR('El empelado no existe', 11, 1)
        ELSE IF NOT EXISTS(SELECT @estadoCliente = IdEstado FROM Clientes WHERE Id = @idCliente)
            RAISERROR('El cliente no existe', 11, 1)
        ELSE IF @estadoCliente != 'AC'
            RAISERROR('El cliente no esta activo', 11, 1)
        ELSE IF (dbo.ExistetTipologiaParaServicio(@nroServicio, @idTipologia) = 0)
            RAISERROR('No existe dicha tipologia para dicho servicio', 11, 1)
        ELSE
            BEGIN
                BEGIN TRANSACTION
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
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE(), @idTicket = -1
        if(@@TRANCOUNT > 0)
            ROLLBACK TRANSACTION
    END CATCH
END
go

