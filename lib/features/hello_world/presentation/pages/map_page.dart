import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'package:coach_app/core/widgets/app_tabs.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/features/hello_world/widgets/flutter_map_widget.dart';
import 'package:coach_app/features/hello_world/widgets/synfusion_map_widget.dart';
import 'package:coach_app/shared/constants/app_keys.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageLayout(
        header: const PageHeader(title: 'Map'),
        child: AppTabs(
          tabs: const [
            'Syncfusion MapBox',
            'FlutterMap MapBox',
            'Syncfusion GoogleMaps',
            'FlutterMap GoogleMaps',
          ],
          distance: 16,
          tabContents: const [
            SyncfusionMapWidget(
              initialCenter: MapLatLng(51.509364, -0.128928),
              initialZoom: 15,
              tileUrlTemplate:
                  'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}?access_token=${AppKeys.mapBox}',
            ),
            FlutterMapWidget(
              initialCenter: LatLng(51.509364, -0.128928),
              initialZoom: 15,
              tileUrlTemplate:
                  'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}?access_token=${AppKeys.mapBox}',
            ),
            SyncfusionMapWidget(
              initialCenter: MapLatLng(51.509364, -0.128928),
              initialZoom: 15,
              tileUrlTemplate:
                  'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}&key=${AppKeys.googleMaps}',
            ),
            FlutterMapWidget(
              initialCenter: LatLng(51.509364, -0.128928),
              initialZoom: 15,
              tileUrlTemplate:
                  'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}&key=${AppKeys.googleMaps}',
            ),
          ],
        ),
      ),
    );
  }
}
