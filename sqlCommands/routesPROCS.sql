-- CREATE
CREATE PROCEDURE usp_CreateRoute
    @name NVARCHAR(100),
    @destination NVARCHAR(100)
AS
BEGIN
    INSERT INTO routes (name, destination)
    VALUES (@name, @destination);

    SELECT SCOPE_IDENTITY() AS NewRouteId;
END
GO

-- READ (all)
CREATE PROCEDURE usp_GetRoutes
AS
BEGIN
    SELECT * FROM routes;
END
GO

-- READ (by ID)
CREATE PROCEDURE usp_GetRouteById
    @route_id INT
AS
BEGIN
    SELECT * FROM routes WHERE route_id = @route_id;
END
GO

-- UPDATE
CREATE PROCEDURE usp_UpdateRoute
    @route_id INT,
    @name NVARCHAR(100),
    @destination NVARCHAR(100)
AS
BEGIN
    UPDATE routes
    SET name = @name,
        destination = @destination
    WHERE route_id = @route_id;
END
GO

-- DELETE
CREATE PROCEDURE usp_DeleteRoute
    @route_id INT
AS
BEGIN
    DELETE FROM routes WHERE route_id = @route_id;
END
GO
