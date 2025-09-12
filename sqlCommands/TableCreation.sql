CREATE TABLE routes (
    routeId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NULL,
    destination NVARCHAR(100) NOT NULL
);
CREATE TABLE routeCoordinates (
    coordId INT IDENTITY(1,1) PRIMARY KEY,
    routeId INT NOT NULL,
    sequence INT NOT NULL,
    lat DECIMAL(9,6) NOT NULL,
    lng DECIMAL(9,6) NOT NULL,
    CONSTRAINT FK_coords_routes FOREIGN KEY (routeId)
        REFERENCES routes(routeId)
        ON DELETE CASCADE
);
CREATE TABLE stops (
    stopId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,	
    lat DECIMAL(9,6) NOT NULL,
    lng DECIMAL(9,6) NOT NULL
);
CREATE TABLE stopsRoutes (
    stopRouteId INT IDENTITY(1,1) PRIMARY KEY,
    routeId INT NOT NULL,
    stopId INT NOT NULL,
    sequence INT NOT NULL,  -- order of stops along the route
    CONSTRAINT FK_stops_routes_route FOREIGN KEY (routeId)
        REFERENCES routes(routeId)
        ON DELETE CASCADE,
    CONSTRAINT FK_stops_routes_stop FOREIGN KEY (stopId)
        REFERENCES stops(stopId)
        ON DELETE CASCADE
);
