CREATE PROCEDURE InactivarServicio @idServicio INT
AS
DECLARE
    @idCliente         INT,
    @cantidadServiciosActivos INT
BEGIN
    UPDATE ServiciosContratados SET IdEstadoServicio = 'IN' WHERE NroServicio = @idServicio;
    SELECT @idCliente = IdCliente FROM ServiciosContratados WHERE NroServicio = @idServicio;
    SELECT @cantidadServiciosActivos = COUNT(*) FROM ServiciosContratados WHERE IdCliente = @idCliente AND IdEstadoServicio = 'AC';
    IF (@cantidadServiciosActivos = 0)
        UPDATE Clientes SET IdEstado = 'IN' where Id = @idCliente;
end
go

