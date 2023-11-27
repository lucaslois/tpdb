CREATE PROCEDURE ReasignarTicket @idTicket INT, @login VARCHAR(25)
AS
DECLARE
    @errorMessage  VARCHAR(255),
    @errorCode     INT;
BEGIN
    IF NOT EXISTS(SELECT * FROM Tickets WHERE Id = @idTicket)
        SELECT @errorCode = 1, @errorMessage = 'El ticket no existe'
    ELSE IF NOT EXISTS(SELECT * FROM Empleados WHERE Login = @login)
        SELECT @errorCode = 2, @errorMessage = 'El empleado no existe'
    ELSE IF NOT EXISTS(SELECT * FROM Empleados WHERE Login = @login AND IdEstado = 'AC')
        SELECT @errorCode = 3, @errorMessage = 'El empleado no esta activo'
    ELSE IF NOT EXISTS(SELECT * FROM Tickets WHERE Id = @idTicket AND IdEstado IN ('CE', 'RE'))
        SELECT @errorCode = 4, @errorMessage = 'No se puede reasignar un ticket cerrado o resuelto'
    ELSE
        BEGIN
            BEGIN TRAN
            UPDATE Tickets SET Login = @login WHERE Id = @idTicket;
            COMMIT TRAN
        END
        
    SELECT @errorMessage as 'ErrorMessage', @errorCode as 'ErrorCode';
end
go

