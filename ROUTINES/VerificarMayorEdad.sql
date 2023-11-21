CREATE FUNCTION ValidarFechaMayorEdad(@fechaNacimiento date)
RETURNS bit
AS
	BEGIN
		declare @esMayor bit = 0
		if (DATEDIFF (year, @fechaNacimiento, getdate()) > 18)
		select @esMayor = 1
	RETURN @esMayor
	END
go

