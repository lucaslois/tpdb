CREATE VIEW ListarCantidadDeServiciosPorUsuario
AS
SELECT C.Nombre, COUNT(*) as QuantityOfServices FROM ServiciosContratados
INNER JOIN Clientes C on ServiciosContratados.IdCliente = C.Id
GROUP BY C.Nombre