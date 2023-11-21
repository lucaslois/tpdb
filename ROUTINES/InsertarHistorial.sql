CREATE TRIGGER InsertarEnHistorial
    ON Tickets
    FOR UPDATE
    AS
BEGIN
    declare @idEstado varchar(2), @viejoEstado varchar(2), @id INT, @fecha DATETIME
    select @idEstado = IdEstado from inserted
    select @viejoEstado = IdEstado from deleted
    select @id = Id from inserted
    select @fecha = getdate()

    if (@idEstado != @viejoEstado)
        INSERT INTO HistorialEstados (ViejoEstado, NuevoEstado, IdTicket, FechaHoraInicio)
        values (@viejoEstado, @idEstado, @id, @fecha)
END
go

