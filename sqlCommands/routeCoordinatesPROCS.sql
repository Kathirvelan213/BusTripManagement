-- First, define a custom type if not already created
CREATE TYPE dbo.RouteCoordinateType AS TABLE
(
    routeId INT NOT NULL,
    sequence INT NOT NULL,
    lat DECIMAL(9,6) NOT NULL,
    lng DECIMAL(9,6) NOT NULL
);
GO

-- Then, create the stored procedure
CREATE PROCEDURE usp_InsertRouteCoordinates
    @Coordinates dbo.RouteCoordinateType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO routeCoordinates (routeId, sequence, lat, lng)
    SELECT routeId, sequence, lat, lng
    FROM @Coordinates;
END
GO

CREATE PROCEDURE usp_GetRouteCoordinates
    @Route_Id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CoordId, RouteId, Sequence, Lat, Lng
    FROM routeCoordinates
    WHERE RouteId = @Route_Id
    ORDER BY Sequence;
END
GO

