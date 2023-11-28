CREATE PROCEDURE EditarCliente
    @idCliente INT,
    @nombre VARCHAR(255),
    @apellido VARCHAR(255),
    @fechaNacimiento DATE,
    @email VARCHAR(255),
    @errorMessage VARCHAR(255) OUTPUT,
    @errorCode INT OUTPUT
AS
    DECLARE
    @esMayor   bit;
BEGIN
    BEGIN TRY
        IF (@fechaNacimiento IS NOT NULL AND @esMayor = 0)
            RAISERROR('El cliente es menor de edad', 11, 1);
        ELSE IF(@email IS NOT NULL AND dbo.EmailValido(@email) = 0)
            RAISERROR('El email posee un formato invalido', 11, 1);
        ELSE IF(@nombre IS NULL OR @apellido IS NULL)
            RAISERROR('El nombre y apellido son obligatorios', 11, 1);
        ELSE IF NOT (EXISTS(SELECT Id FROM Clientes WHERE Id = @idCliente))
            RAISERROR('El cliente no existe', 11, 1);
        ELSE IF(EXISTS(SELECT Id FROM Clientes WHERE Id = @idCliente AND IdEstado = 'AC'))
            RAISERROR('El cliente se encuentra activo', 11, 1);
        ELSE
            UPDATE Clientes SET Nombre = @nombre, Apellido = @apellido, FechaNacimiento = @fechaNacimiento WHERE Id = @idCliente;
    END TRY
    BEGIN CATCH
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE()
    END CATCH
end
go

