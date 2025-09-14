-- CREATE
CREATE PROCEDURE usp_CreateStopRoute
    @route_id INT,
    @stop_id INT,
    @sequence INT
AS
BEGIN
    INSERT INTO stopsRoutes (routeId, stopId, sequence)
    VALUES (@route_id, @stop_id, @sequence);

    SELECT SCOPE_IDENTITY() AS stopRouteId;
END
GO

-- READ (all for a route)
CREATE PROCEDURE usp_GetStopsForRoute
    @route_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        sr.stopRouteId,
        sr.sequence,
        sr.routeId,
        s.stopId,
        s.Name,
        s.lat,
        s.lng
    FROM stopsRoutes sr
    INNER JOIN stops s 
        ON sr.stopId = s.stopId
    WHERE sr.routeId = @route_id
    ORDER BY sr.sequence;
END
GO


-- UPDATE
CREATE PROCEDURE usp_UpdateStopRoute
    @stop_route_id INT,
    @sequence INT
AS
BEGIN
    UPDATE stops_routes
    SET sequence = @sequence
    WHERE stopRouteId = @stop_route_id;
END
GO

-- DELETE
CREATE PROCEDURE usp_DeleteStopRoute
    @stop_route_id INT
AS
BEGIN
    DELETE FROM stopsRoutes WHERE stopRouteId = @stop_route_id;
END
GO

