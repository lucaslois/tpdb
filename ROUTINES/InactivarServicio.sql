CREATE PROCEDURE InactivarServicio 
    @idServicio INT,
    @errorMessage VARCHAR(255) OUTPUT,
    @errorCode INT OUTPUT
AS
DECLARE
    @idCliente                INT,
    @cantidadServiciosActivos INT
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT * FROM ServiciosContratados WHERE NroServicio = @idServicio)
            RAISERROR('El servicio no existe', 11, 1); 
        ELSE
            BEGIN
                BEGIN TRANSACTION
                UPDATE ServiciosContratados SET IdEstadoServicio = 'IN' WHERE NroServicio = @idServicio;
                SELECT @idCliente = IdCliente FROM ServiciosContratados WHERE NroServicio = @idServicio;
                SELECT @cantidadServiciosActivos = COUNT(*)
                FROM ServiciosContratados
                WHERE IdCliente = @idCliente
                  AND IdEstadoServicio = 'AC';
                
                IF (@cantidadServiciosActivos = 0)
                    UPDATE Clientes SET IdEstado = 'IN' where Id = @idCliente;
                    
                COMMIT
            END
    END TRY
    BEGIN CATCH
        IF(@@TRANCOUNT > 0)
            ROLLBACK TRANSACTION
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE()
    END CATCH
end
go

