CREATE FUNCTION  ExistetTipologiaParaServicio (@nroServicio int, @idTipologia VARCHAR(2))
RETURNS bit
AS
    BEGIN
	declare  @cant int , @existe bit = 0, @idServicio VARCHAR(2)
		select @idServicio = IdServicio FROM ServiciosContratados WHERE NroServicio = @nroServicio
		select @cant = count(*) from SLA where IdServicio = @idServicio AND IdTipologia = @idTipologia
	    if(@cant > 0)
	        select @existe = 1
        RETURN @existe
    END
go

