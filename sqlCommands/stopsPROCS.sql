-- CREATE
CREATE PROCEDURE usp_CreateStop
    @name NVARCHAR(100),
    @lat DECIMAL(9,6),
    @lng DECIMAL(9,6)
AS
BEGIN
    INSERT INTO stops (name, lat, lng)
    VALUES (@name, @lat, @lng);

    SELECT SCOPE_IDENTITY() AS NewStopId;
END
GO

-- READ (all)
CREATE PROCEDURE usp_GetStops
AS
BEGIN
    SELECT * FROM stops;
END
GO

-- READ (by ID)
CREATE PROCEDURE usp_GetStopById
    @stop_id INT
AS
BEGIN
    SELECT * FROM stops WHERE stop_id = @stop_id;
END
GO

-- UPDATE
CREATE PROCEDURE usp_UpdateStop
    @stop_id INT,
    @name NVARCHAR(100),
    @lat DECIMAL(9,6),
    @lng DECIMAL(9,6)
AS
BEGIN
    UPDATE stops
    SET name = @name,
        lat = @lat,
        lng = @lng
    WHERE stop_id = @stop_id;
END
GO

-- DELETE
CREATE PROCEDURE usp_DeleteStop
    @stop_id INT
AS
BEGIN
    DELETE FROM stops WHERE stop_id = @stop_id;
END
GO
