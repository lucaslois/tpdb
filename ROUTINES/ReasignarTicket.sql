CREATE PROCEDURE ReasignarTicket
    @idTicket INT,
    @login VARCHAR(25),
    @errorMessage VARCHAR(255) OUTPUT,
    @errorCode INT OUTPUT
AS
BEGIN
    BEGIN TRY
    IF NOT EXISTS(SELECT * FROM Tickets WHERE Id = @idTicket)
        RAISERROR('El ticket no existe', 11, 1);
    ELSE IF NOT EXISTS(SELECT * FROM Empleados WHERE Login = @login)
        RAISERROR('El empleado no existe', 11, 1);
    ELSE IF NOT EXISTS(SELECT * FROM Empleados WHERE Login = @login AND IdEstado = 'AC')
        RAISERROR('El empleado no esta activo', 11, 1);
    ELSE IF NOT EXISTS(SELECT * FROM Tickets WHERE Id = @idTicket AND IdEstado IN ('CE', 'RE'))
        RAISERROR('No se puede reasignar un ticket cerrado o resuelto', 11, 1);
    ELSE
        UPDATE Tickets SET Login = @login WHERE Id = @idTicket;
    END TRY
    BEGIN CATCH
        SELECT @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE();
    END CATCH
end
go

