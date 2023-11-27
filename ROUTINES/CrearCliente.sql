CREATE PROCEDURE CrearCliente @apellido varchar(255),
                              @nombre varchar(255),
                              @tipoDocumento char(25),
                              @nroDocumento char(98),
                              @fechaNacimiento date,
                              @email varchar(50)
AS
declare
    @esMayor   bit,
    @idCliente int,
    @errorMessage VARCHAR(255),
    @errorCode INT;
select @esMayor = dbo.ValidarFechaMayorEdad(@fechaNacimiento)

BEGIN
    IF (@fechaNacimiento IS NOT NULL AND @esMayor = 0)
        SELECT @errorCode = 4, @errorMessage = 'El cliente es menor de edad';
    ELSE IF(@email IS NOT NULL AND dbo.EmailValido(@email) = 0)
        SELECT @errorCode = 2, @errorMessage = 'El email posee un formato invalido';
    ELSE IF(@nombre IS NULL OR @apellido IS NULL OR @tipoDocumento IS NULL OR @nroDocumento IS NULL)
        SELECT @errorCode = 1, @errorMessage = 'El nombre, apellido, tipodoc y nrodoc son obligatorios';
    ELSE IF(EXISTS(SELECT * FROM Clientes WHERE NroDoc = @nroDocumento AND TipoDoc = @tipoDocumento))
        SELECT @errorCode = 3, @errorMessage = 'Ya existe un cliente con ese tipodoc/nrodoc';
    ELSE
        BEGIN
            insert into Clientes (Apellido, Nombre, IdEstado, TipoDoc, NroDoc, FechaNacimiento, Email)
            VALUES (@apellido, @nombre, 'PR', @tipoDocumento, @nroDocumento, @fechaNacimiento, @email);

            SELECT @idCliente = SCOPE_IDENTITY();
        END

    SELECT @idCliente as 'IdCliente', @errorMessage as 'ErrorMessage', @errorCode as 'ErrorCode';
END
go

