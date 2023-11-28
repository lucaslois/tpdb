CREATE PROCEDURE CrearCliente
    @apellido VARCHAR(255),
    @nombre VARCHAR(255),
    @tipoDocumento VARCHAR(25),
    @nroDocumento VARCHAR(98),
    @fechaNacimiento DATE,
    @email VARCHAR(50),
    @idCliente INT OUTPUT,
    @errorMessage VARCHAR(255) OUTPUT,
    @errorCode INT OUTPUT
AS
DECLARE
    @esMayor   bit;
BEGIN
    select @esMayor = dbo.ValidarFechaMayorEdad(@fechaNacimiento)
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

            SET @idCliente = SCOPE_IDENTITY();
        END
END
go

