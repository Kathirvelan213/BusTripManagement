import 'package:flutter/material.dart';
import 'package:flutter_app/components/pages/tracking/widgets/stops/stops_panel.dart';
import 'package:flutter_app/models/bus_route.dart';
import './widgets/map_tile.dart';

class TrackingPage extends StatelessWidget {
  final BusRoute? selectedRoute;

  const TrackingPage({super.key, this.selectedRoute});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mapHeight = screenHeight * 0.9; // 60% of screen
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedRoute?.name ?? "Tracking"),
        centerTitle: true,
        actions: [
          if (selectedRoute != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(selectedRoute!.name),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Route ID: ${selectedRoute!.routeId}'),
                        const SizedBox(height: 8),
                        Text('Destination: ${selectedRoute!.destination}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Map in a card
              SizedBox(
                height: mapHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MapTile(selectedRoute: selectedRoute),
                ),
              ),

              const SizedBox(height: 20),
              StopsPanel(),
              // Location info
              // SizedBox(
              //   height: 1000,
              //   child: Card(
              //     elevation: 4,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(16),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const Text(
              //             "Location Details",
              //             style: TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           const Divider(),
              //           ListTile(
              //             leading: const Icon(Icons.place, color: Colors.blue),
              //             title: const Text("Latitude: 37.4219983"),
              //             subtitle: const Text("Longitude: -122.084"),
              //             trailing: IconButton(
              //               icon: const Icon(Icons.copy),
              //               onPressed: () {
              //                 // Copy coords to clipboard
              //               },
              //             ),
              //           ),
              //           ListTile(
              //             leading: const Icon(Icons.access_time,
              //                 color: Colors.green),
              //             title: const Text("Last updated"),
              //             subtitle: const Text("2 minutes ago"),
              //           ),
              //           const Spacer(),
              //           SizedBox(
              //             width: double.infinity,
              //             child: ElevatedButton.icon(
              //               onPressed: () {
              //                 // trigger live tracking update
              //               },
              //               icon: const Icon(Icons.refresh),
              //               label: const Text("Refresh Location"),
              //               style: ElevatedButton.styleFrom(
              //                 padding: const EdgeInsets.symmetric(vertical: 14),
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(12),
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Recenter map
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
