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
    @estado       char(2) = 'AC';
BEGIN
    BEGIN TRY
        BEGIN TRAN
        
    IF NOT (EXISTS(SELECT * FROM Clientes WHERE Id = @idCliente AND (Email IS NULL OR FechaNacimiento IS NULL)))
        RAISERROR ('El cliente no existe o no posee un email/fecha de nacimiento', 11, 1);
    ELSE IF NOT EXISTS(SELECT * FROM Servicios WHERE Id = @idTipoServicio)
        RAISERROR ('El servicio no existe', 11, 1);
    ELSE IF (@calle IS NULL OR @altura IS NULL)
        RAISERROR ('La direccion y altura son obligatorios', 11, 1);
    ELSE IF (@idTipoServicio IN ('TE', 'VO') AND @telefono IS NULL)
        RAISERROR ('El telefono es obligatorio para los servicios TE y VO', 11, 1);
    ELSE
        insert ServiciosContratados (IdEstadoServicio, Calle, Numero, Piso, Departamento, FechaInicio,
                                     IdServicio,
                                     Telefono, IdCliente)
        VALUES (@estado, @calle, @altura, @piso, @depto, @fechaInicio, @idTipoServicio, @telefono, @idCliente)
        UPDATE Clientes set IdEstado = 'AC' WHERE Id = @idCliente

        SELECT @idServicio = SCOPE_IDENTITY();
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE(), @idServicio = -1        
    END CATCH
END
go

