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
    IF (@fechaNacimiento IS NOT NULL AND @esMayor = 0)
        SELECT @errorCode = 5, @errorMessage = 'El cliente es menor de edad';
    ELSE IF(@email IS NOT NULL AND dbo.EmailValido(@email) = 0)
        SELECT @errorCode = 2, @errorMessage = 'El email posee un formato invalido';
    ELSE IF(@nombre IS NULL OR @apellido IS NULL)
        SELECT @errorCode = 3, @errorMessage = 'El nombre y apellido son obligatorios';
    ELSE IF NOT (EXISTS(SELECT Id FROM Clientes WHERE Id = @idCliente))
        SELECT @errorCode = 4, @errorMessage = 'El cliente no existe';
    ELSE IF(EXISTS(SELECT Id FROM Clientes WHERE Id = @idCliente AND IdEstado = 'AC'))
        SELECT @errorCode = 1, @errorMessage = 'El cliente se encuentra activo';
    ELSE
        UPDATE Clientes SET Nombre = @nombre, Apellido = @apellido, FechaNacimiento = @fechaNacimiento WHERE Id = @idCliente;
end
go

