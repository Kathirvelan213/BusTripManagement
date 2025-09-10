-- CREATE
CREATE PROCEDURE usp_CreateStopRoute
    @route_id INT,
    @stop_id INT,
    @sequence INT
AS
BEGIN
    INSERT INTO stops_routes (route_id, stop_id, sequence)
    VALUES (@route_id, @stop_id, @sequence);

    SELECT SCOPE_IDENTITY() AS NewStopRouteId;
END
GO

-- READ (all for a route)
CREATE PROCEDURE usp_GetStopsForRoute
    @route_id INT
AS
BEGIN
    SELECT sr.stop_route_id, sr.sequence, s.stop_id, s.name, s.lat, s.lng
    FROM stops_routes sr
    JOIN stops s ON sr.stop_id = s.stop_id
    WHERE sr.route_id = @route_id
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
    WHERE stop_route_id = @stop_route_id;
END
GO

-- DELETE
CREATE PROCEDURE usp_DeleteStopRoute
    @stop_route_id INT
AS
BEGIN
    DELETE FROM stops_routes WHERE stop_route_id = @stop_route_id;
END
GO
