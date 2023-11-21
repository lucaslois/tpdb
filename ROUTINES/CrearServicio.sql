CREATE PROCEDURE CrearServicio @idTipoServicio char(2), @idCliente int, @telefono int, @calle varchar(255), @altura int,
                               @piso int, @depto varchar(5)
AS
declare
    @fechaInicio date    = getdate(),
    @estado      char(2) = 'AC'
BEGIN
    IF (EXISTS(SELECT * FROM Clientes WHERE Id = @idCliente AND (Email IS NULL OR FechaNacimiento IS NULL)))
        BEGIN
            RAISERROR ('El correo o la fecha de nacimiento no pueden ser nulas.', 1, 2);
        END
    ELSE
        BEGIN TRY
            BEGIN TRAN
                insert ServiciosContratados (IdEstadoServicio, Calle, Numero, Piso, Departamento, FechaInicio,
                                             IdServicio,
                                             Telefono, IdCliente)
                VALUES (@estado, @calle, @altura, @piso, @depto, @fechaInicio, @idTipoServicio, @telefono, @idCliente)
                UPDATE Clientes set IdEstado = 'AC' where Id = @idCliente
            COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
        END CATCH
END
go

