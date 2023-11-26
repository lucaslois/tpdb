CREATE PROCEDURE CrearCliente @apellido varchar(255), @nombre varchar(255), @tipoDocumento char(25),
                              @nroDocumento varchar(98), @fechaNacimiento date, @email varchar(50)
AS
declare @esMayor bit;
select @esMayor = dbo.ValidarFechaMayorEdad(@fechaNacimiento)

BEGIN
    if (@esMayor = 1)
        insert into Clientes (Apellido, Nombre, IdEstado, TipoDoc, NroDoc, FechaNacimiento, Email)
        VALUES (@apellido, @nombre, 'PR', @tipoDocumento, @nroDocumento, @fechaNacimiento, @email)
    ELSE
        BEGIN
            DECLARE @ErrorMessage VARCHAR(4000);
            DECLARE @ErrorCode INT;
            SELECT @ErrorMessage = 'El cliente es menor de edad',
                   @ErrorCode = 1
            RAISERROR (@ErrorMessage, @ErrorCode, 1);
        END
END
go

