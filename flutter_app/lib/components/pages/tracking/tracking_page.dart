import 'package:flutter/material.dart';
import 'package:flutter_app/components/pages/tracking/widgets/bus_info.dart';
import 'package:flutter_app/components/pages/tracking/widgets/info_panel_header.dart';
import 'package:flutter_app/components/pages/tracking/widgets/stops/stops_panel.dart';
import 'package:flutter_app/models/bus_route.dart';
import 'package:flutter_app/services/hub_services/location_hub_service.dart';
import './widgets/map_tile.dart';

class TrackingPage extends StatelessWidget {
  final BusRoute? selectedRoute;

  const TrackingPage({super.key, this.selectedRoute});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
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
                            child: MapTile(selectedRoute: selectedRoute),
                          )),
                    ),
                    InfoPanelHeader(),
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
                  BusInfo(selectedRoute: selectedRoute),
                  StopsPanel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
