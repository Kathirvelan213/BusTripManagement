import 'dart:io';
import 'package:xml/xml.dart';
import 'package:latlong2/latlong.dart';

Future<List<List<LatLng>>> loadRouteFromFile(String filePath) async {
  final rawKml = await File(filePath).readAsString();
  final doc = XmlDocument.parse(rawKml);

  final routes = <List<LatLng>>[];

  for (final line in doc.findAllElements('LineString')) {
    final coordsNode = line.findElements('coordinates').first;
    final coordText = coordsNode.text.trim();
    final coordPairs = coordText.split(RegExp(r'\s+'));

    final points = <LatLng>[];
    for (final pair in coordPairs) {
      final parts = pair.split(',');
      if (parts.length >= 2) {
        final lon = double.tryParse(parts[0]);
        final lat = double.tryParse(parts[1]);
        if (lon != null && lat != null) {
          points.add(LatLng(lat, lon));
        }
      }
    }
    if (points.isNotEmpty) {
      routes.add(points);
    }
  }

  return routes; // list of polylines
}
