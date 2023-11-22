CREATE VIEW ListarCantidadDeTicketsPorServicio
AS
SELECT S.Nombre, COUNT(*) as QuantityOfTickets FROM Tickets
INNER JOIN ServiciosContratados SC on Tickets.NroServicio = SC.NroServicio
INNER JOIN Servicios S on SC.IdServicio = S.Id
GROUP BY S.Nombre