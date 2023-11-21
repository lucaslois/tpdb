CREATE PROCEDURE EditarCliente @idCliente INT, @nombre VARCHAR(255), @apellido VARCHAR(255), @fechaNacimiento DATE
AS
BEGIN
    IF(EXISTS(SELECT Id FROM Clientes WHERE Id = @idCliente AND IdEstado = 'AC'))
        RAISERROR('No se puede editar un cliente activo', 1, 5)
    ELSE
    UPDATE Clientes SET Nombre = @nombre, Apellido = @apellido, FechaNacimiento = @fechaNacimiento WHERE Id = @idCliente;
end
go

