CREATE TABLE routes (
    route_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NULL,
    destination NVARCHAR(100) NOT NULL
);
CREATE TABLE route_coordinates (
    coord_id INT IDENTITY(1,1) PRIMARY KEY,
    route_id INT NOT NULL,
    sequence INT NOT NULL,
    lat DECIMAL(9,6) NOT NULL,
    lng DECIMAL(9,6) NOT NULL,
    CONSTRAINT FK_coords_routes FOREIGN KEY (route_id)
        REFERENCES routes(route_id)
        ON DELETE CASCADE
);
CREATE TABLE stops (
    stop_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,	
    lat DECIMAL(9,6) NOT NULL,
    lng DECIMAL(9,6) NOT NULL
);
CREATE TABLE stops_routes (
    stop_route_id INT IDENTITY(1,1) PRIMARY KEY,
    route_id INT NOT NULL,
    stop_id INT NOT NULL,
    sequence INT NOT NULL,  -- order of stops along the route
    CONSTRAINT FK_stops_routes_route FOREIGN KEY (route_id)
        REFERENCES routes(route_id)
        ON DELETE CASCADE,
    CONSTRAINT FK_stops_routes_stop FOREIGN KEY (stop_id)
        REFERENCES stops(stop_id)
        ON DELETE CASCADE
);
