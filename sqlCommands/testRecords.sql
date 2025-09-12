USE [db-bus-trips-local]

INSERT INTO routes (name, destination)
VALUES ('1', N'Mall Y');

INSERT INTO stops (name, lat, lng) VALUES
(N'Maraimalai Nagar', 12.823456, 80.045678),
(N'Potheri', 12.828765, 80.050123),
(N'Kattankulathur', 12.833987, 80.055432),
(N'Guduvancherry', 12.839876, 80.060987);
 
INSERT INTO stopsRoutes (routeId, stopId, sequence) VALUES
(1, 1, 1),  -- Maraimalai Nagar
(1, 2, 2),  -- Potheri
(1, 3, 3),  -- Kattankulathur
(1, 4, 4);  -- Guduvancherry
