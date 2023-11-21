CREATE FUNCTION dbo.CalcularDemoraResolucion(@idTicket int)
    RETURNS int
AS
BEGIN
    declare @fechaResolucion datetime, @demora int
    select @fechaResolucion = FechaResolucion from Tickets where Id = @idTicket

    if (@fechaResolucion IS NOT NULL)
        select @demora = DATEDIFF(hour, FechaApertura, FechaResolucion) from Tickets where Id = @idTicket
    else
        select @demora = 0
    RETURN @demora
END
go

