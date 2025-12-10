import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_app/components/nav_control/widgets/back_button.dart';
import 'package:flutter_app/components/pages/tracking/widgets/bus_info/bus_info.dart';
import 'package:flutter_app/components/pages/tracking/widgets/bus_info/info_panel_header.dart';
import 'package:flutter_app/components/pages/tracking/widgets/stops/stops_panel.dart';
import 'package:flutter_app/components/pages/tracking/widgets/dialogs/stop_reminder_dialog.dart';
import 'package:flutter_app/models/bus_route.dart';
import 'package:flutter_app/services/location_services/trip_status_service.dart';
import 'package:latlong2/latlong.dart';
import './widgets/map_tile.dart';

class TrackingPage extends StatefulWidget {
  final BusRoute? selectedRoute;

  const TrackingPage({super.key, this.selectedRoute});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage>
    with TickerProviderStateMixin {
  late final AnimatedMapController _animatedMapController;

  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(vsync: this);
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  void _centerOnLocation(LatLng newLocation) {
    print("Centering on location: $newLocation");
    _animatedMapController.animateTo(
      dest: newLocation,
      zoom: 16,
      curve: Curves.easeInOut,
    );
  }

  void _showReminderDialog() {
    final stops = TripStatusService.instance.stops;
    showDialog(
      context: context,
      builder: (context) => StopReminderDialog(
        stops: stops,
        route: widget.selectedRoute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(children: [
      CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: screenHeight * 0.8,
            collapsedHeight: screenHeight * 0.4,
            backgroundColor: Colors.white,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final double max = screenHeight * 0.8;
                final double min = screenHeight * 0.4;
                final double current = constraints.maxHeight;

                // Calculate progress: 1.0 = fully expanded, 0.0 = fully collapsed
                final double t =
                    ((current - min) / (max - min)).clamp(0.0, 1.0);

                final double horizontalPadding = (t) * 16.0;

                return Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(
                            left: horizontalPadding,
                            right: horizontalPadding,
                            top: (t) * 16.0,
                            bottom: (t) * 16.0,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16 * t),
                            child: MapTile(
                              selectedRoute: widget.selectedRoute,
                              animatedMapController: _animatedMapController,
                            ),
                          )),
                    ),
                    InfoPanelHeader(
                      onReminderTap: _showReminderDialog,
                    ),
                  ],
                ));
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  BusInfo(selectedRoute: widget.selectedRoute),
                  StopsPanel(
                    animatedMapController: _animatedMapController,
                    centerOnLocation: _centerOnLocation,
                    route: widget.selectedRoute,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      CustomBackButton()
    ]);
  }
}
