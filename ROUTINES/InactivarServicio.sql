CREATE PROCEDURE InactivarServicio @idServicio INT
AS
DECLARE
    @idCliente                INT,
    @cantidadServiciosActivos INT,
    @errorMessage             VARCHAR(255),
    @errorCode                INT;
BEGIN
    IF NOT EXISTS(SELECT * FROM ServiciosContratados WHERE NroServicio = @idServicio)
        SELECT @errorCode = 1, @errorMessage = 'El servicio no existe'
    ELSE
        BEGIN
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
        END

    SELECT @errorMessage as 'ErrorMessage', @errorCode as 'ErrorCode';
end
go

