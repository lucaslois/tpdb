CREATE PROCEDURE CrearServicio
    @idTipoServicio char(2),
    @idCliente int,
    @telefono int,
    @calle varchar(255),
    @altura int,
    @piso int,
    @depto varchar(5),
    @idServicio INT OUTPUT,
    @errorMessage VARCHAR(255) OUTPUT,
    @errorCode INT OUTPUT
AS
declare
    @fechaInicio  date    = getdate(),
    @estado       char(2) = 'AC',
    @emailCliente VARCHAR(255),
    @fechaNacimientoCliente DATE;
BEGIN
    BEGIN TRY
    SELECT @emailCliente = Email, @fechaNacimientoCliente = FechaNacimiento FROM Clientes WHERE Id = @idCliente;
    IF NOT EXISTS(SELECT Id FROM Clientes WHERE Id = @idCliente)
        RAISERROR ('El cliente no existe', 11, 1);
    ELSE IF(@emailCliente IS NULL)
        RAISERROR ('El cliente no posee un email', 11, 1);
    ELSE IF(@fechaNacimientoCliente IS NULL)
        RAISERROR ('El cliente no posee fecha de nacimiento', 11, 1);
    ELSE IF NOT EXISTS(SELECT * FROM Servicios WHERE Id = @idTipoServicio)
        RAISERROR ('El servicio no existe', 11, 1);
    ELSE IF (@calle IS NULL OR @altura IS NULL)
        RAISERROR ('La direccion y altura son obligatorios', 11, 1);
    ELSE IF (@idTipoServicio IN ('TE', 'VO') AND @telefono IS NULL)
        RAISERROR ('El telefono es obligatorio para los servicios TE y VO', 11, 1);
    ELSE IF (@telefono IS NOT NULL AND @idTipoServicio = 'IN')
        RAISERROR ('El telefono no debe ser enviado para servicio de internet', 11, 1);
    ELSE
        BEGIN TRAN
        insert ServiciosContratados (IdEstadoServicio, Calle, Numero, Piso, Departamento, FechaInicio,
                                     IdServicio,
                                     Telefono, IdCliente)
        VALUES (@estado, @calle, @altura, @piso, @depto, @fechaInicio, @idTipoServicio, @telefono, @idCliente)
        SELECT @idServicio = SCOPE_IDENTITY();
        UPDATE Clientes set IdEstado = 'AC' WHERE Id = @idCliente
        COMMIT
    END TRY
    BEGIN CATCH
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE(), @idServicio = -1
        if(@@TRANCOUNT > 0)
            ROLLBACK
    END CATCH
END
go

