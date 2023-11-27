CREATE PROCEDURE CrearServicio @idTipoServicio char(2), @idCliente int, @telefono int, @calle varchar(255), @altura int,
                               @piso int, @depto varchar(5)
AS
declare
    @fechaInicio  date    = getdate(),
    @estado       char(2) = 'AC',
    @idServicio   INT,
    @errorMessage VARCHAR(255),
    @errorCode    INT;
BEGIN
    IF (EXISTS(SELECT * FROM Clientes WHERE Id = @idCliente AND (Email IS NULL OR FechaNacimiento IS NULL)))
        SELECT @errorCode = 2, @errorMessage = 'El cliente no existe o no posee un email/fecha de nacimiento';
    ELSE IF NOT EXISTS(SELECT * FROM Servicios WHERE Id = @idTipoServicio)
        SELECT @errorCode = 1, @errorMessage = 'El servicio no existe';
    ELSE IF (@calle IS NULL OR @altura IS NULL)
        SELECT @errorCode = 3, @errorMessage = 'La direccion y altura son obligatorios';
    ELSE IF (@idTipoServicio IN ('TE', 'VO') AND @telefono IS NULL)
        SELECT @errorCode = 4, @errorMessage = 'El telefono es obligatorio para los servicios TE y VO';
    ELSE
        BEGIN TRY
            BEGIN TRAN
                insert ServiciosContratados (IdEstadoServicio, Calle, Numero, Piso, Departamento, FechaInicio,
                                             IdServicio,
                                             Telefono, IdCliente)
                VALUES (@estado, @calle, @altura, @piso, @depto, @fechaInicio, @idTipoServicio, @telefono, @idCliente)
                UPDATE Clientes set IdEstado = 'AC' WHERE Id = @idCliente
                
                SELECT @idServicio = SCOPE_IDENTITY();
            COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
        END CATCH

    SELECT @idServicio as 'IdServicio', @errorMessage as 'ErrorMessage', @errorCode as 'ErrorCode';
END
go

