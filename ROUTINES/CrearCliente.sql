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
    BEGIN TRY
    SELECT @esMayor = dbo.ValidarFechaMayorEdad(@fechaNacimiento)
    IF (@fechaNacimiento IS NOT NULL AND @esMayor = 0)
        RAISERROR ('El cliente es menor de edad', 11, 1)
    ELSE IF(@email IS NOT NULL AND dbo.EmailValido(@email) = 0)
        RAISERROR ('El email posee un formato invalido', 11, 1)
    ELSE IF(@nombre IS NULL OR @apellido IS NULL OR @tipoDocumento IS NULL OR @nroDocumento IS NULL)
        RAISERROR ('El nombre, apellido, tipodoc y nrodoc son obligatorios', 11, 1)
    ELSE IF(EXISTS(SELECT * FROM Clientes WHERE NroDoc = @nroDocumento AND TipoDoc = @tipoDocumento))
        RAISERROR ('Ya existe un cliente con ese tipodoc/nrodoc', 11, 1)
    ELSE
        BEGIN
            insert into Clientes (Apellido, Nombre, IdEstado, TipoDoc, NroDoc, FechaNacimiento, Email)
            VALUES (@apellido, @nombre, 'PR', @tipoDocumento, @nroDocumento, @fechaNacimiento, @email);

            SELECT @idCliente = SCOPE_IDENTITY();
        END
    END TRY
    BEGIN CATCH 
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE(), @idCliente = -1
    END CATCH
END
go

