CREATE VIEW ListarTicketsYSLA
AS
SELECT Tickets.IdCliente, FechaApertura, FechaResolucion, dbo.CalcularDemoraResolucion(Id) as TiempoDemora, SLA.TiempoMaximo
FROM Tickets
INNER JOIN ServiciosContratados ON ServiciosContratados.NroServicio = Tickets.NroServicio
INNER JOIN SLA on SLA.IdServicio = ServiciosContratados.IdServicio AND SLA.IdTipologia = Tickets.IdTipologia