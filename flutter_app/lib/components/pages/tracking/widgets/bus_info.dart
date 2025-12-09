import 'package:flutter/material.dart';
import 'package:flutter_app/components/pages/tracking/widgets/pinging_location_icon.dart';
import 'package:flutter_app/models/bus_route.dart';

class BusInfo extends StatelessWidget {
  final BusRoute? selectedRoute;

  const BusInfo({super.key, required this.selectedRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 243, 245),
        ),
        padding: EdgeInsets.only(left: 0, top: 24, bottom: 24),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Image(
                image: AssetImage('assets/images/yellow_bus_3d_front.png'),
                width: 60,
                height: 60,
              ),
            ),
            Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Route: ${selectedRoute?.name ?? 'N/A'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                Text("Guduvancherry -> SSN College",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    )),
                Row(
                  children: [
                    PingingRedDotIcon(),
                    Text("Guduvancherry",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ))
                  ],
                ),
                Text(TimeOfDay.now().format(context),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    )),
              ],
            )
          ],
        ));
  }
}
