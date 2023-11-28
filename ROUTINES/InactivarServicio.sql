CREATE PROCEDURE InactivarServicio 
    @idServicio INT,
    @errorMessage VARCHAR(255) OUTPUT,
    @errorCode INT OUTPUT
AS
DECLARE
    @idCliente                INT,
    @cantidadServiciosActivos INT
BEGIN
    IF NOT EXISTS(SELECT * FROM ServiciosContratados WHERE NroServicio = @idServicio)
        SELECT @errorCode = 1, @errorMessage = 'El servicio no existe'
    ELSE
        BEGIN
            BEGIN TRY
                BEGIN TRAN
                    UPDATE ServiciosContratados SET IdEstadoServicio = 'IN' WHERE NroServicio = @idServicio;
                    SELECT @idCliente = IdCliente FROM ServiciosContratados WHERE NroServicio = @idServicio;
                    SELECT @cantidadServiciosActivos = COUNT(*)
                    FROM ServiciosContratados
                    WHERE IdCliente = @idCliente
                      AND IdEstadoServicio = 'AC';
                    IF (@cantidadServiciosActivos = 0)
                        UPDATE Clientes SET IdEstado = 'IN' where Id = @idCliente;
                COMMIT TRAN
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION
            END CATCH
        END
end
go

