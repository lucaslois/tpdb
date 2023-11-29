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
    @esMayor   bit,
    @estadoCliente VARCHAR(2),
    @query VARCHAR(2000)
BEGIN
    BEGIN TRY
        SELECT @estadoCliente = IdEstado FROM Clientes WHERE Id = @idCliente;
        IF (@fechaNacimiento IS NOT NULL AND @esMayor = 0)
            RAISERROR('El cliente es menor de edad', 11, 1);
        ELSE IF (
            (
                @fechaNacimiento IS NOT NULL
                OR @nombre IS NOT NULL
                OR @apellido IS NOT NULL
            )
            AND @estadoCliente != 'PR')
            RAISERROR('El nombre, apellido y fecha de nacimiento solo pueden ser editados cuando el cliente es un prospecto.', 11, 1);
        ELSE IF(@email IS NOT NULL AND dbo.EmailValido(@email) = 0)
            RAISERROR('El email posee un formato invalido', 11, 1);
        ELSE IF NOT (EXISTS(SELECT Id FROM Clientes WHERE Id = @idCliente))
            RAISERROR('El cliente no existe', 11, 1);
        ELSE IF(EXISTS(SELECT Id FROM Clientes WHERE Id = @idCliente AND IdEstado = 'AC'))
            RAISERROR('El cliente se encuentra activo', 11, 1);
        ELSE
            BEGIN
                BEGIN TRAN
                IF(@nombre IS NOT NULL)
                    UPDATE Clientes SET Nombre = @nombre WHERE Id = @idCliente;
                IF(@apellido IS NOT NULL)
                    UPDATE Clientes SET Apellido = @apellido WHERE Id = @idCliente;
                IF(@fechaNacimiento IS NOT NULL)
                    UPDATE Clientes SET FechaNacimiento = @fechaNacimiento WHERE Id = @idCliente;
                IF(@email IS NOT NULL)
                    UPDATE Clientes SET Email = @email WHERE Id = @idCliente;
                COMMIT
            END
    END TRY
    BEGIN CATCH 
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE()
        IF(@@TRANCOUNT > 0)
            ROLLBACK
    END CATCH
end
go

