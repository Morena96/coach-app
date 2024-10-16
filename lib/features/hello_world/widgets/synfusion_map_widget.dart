import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'package:coach_app/core/theme/app_colors.dart';

/// A full-screen map widget with satellite/streets view and dynamic marker functionality.
class SyncfusionMapWidget extends ConsumerStatefulWidget {
  /// The initial center position of the map.
  final MapLatLng initialCenter;

  /// The initial zoom level of the map.
  final double initialZoom;

  /// The URL template for the satellite map tiles.
  final String tileUrlTemplate;

  const SyncfusionMapWidget({
    super.key,
    required this.initialCenter,
    this.initialZoom = 15,
    required this.tileUrlTemplate,
  });

  @override
  ConsumerState<SyncfusionMapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<SyncfusionMapWidget> {
  late MapZoomPanBehavior _zoomPanBehavior;
  late MapLatLng _markerPosition;
  late MapTileLayerController _mapController;
  double _currentZoom = 15;

  @override
  void initState() {
    super.initState();
    _markerPosition = widget.initialCenter;
    _currentZoom = widget.initialZoom;
    _initializeZoomPanBehavior();
    _mapController = MapTileLayerController();
  }

  void _initializeZoomPanBehavior() {
    _zoomPanBehavior = MapZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePinching: true,
      enablePanning: true,
      maxZoomLevel: 22,
      minZoomLevel: 1,
      zoomLevel: widget.initialZoom,
      focalLatLng: _markerPosition,
      showToolbar: false,
    );
  }

  void _updateZoomLevel(double newZoomLevel) {
    setState(() {
      _currentZoom = newZoomLevel;
    });
  }

  /// Calculates the step size for marker movement based on the current zoom level.
  double _calculateStepSize() {
    // Base step size at zoom level 1
    const baseStep = 5;
    // Calculate step size: smaller steps at higher zoom levels
    return baseStep / math.pow(2, _currentZoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: widget.tileUrlTemplate,
              zoomPanBehavior: _zoomPanBehavior,
              initialMarkersCount: 1,
              controller: _mapController,
              onWillZoom: (MapZoomDetails details) {
                _updateZoomLevel(details.newZoomLevel ?? 0);
                return true;
              },
              markerBuilder: (BuildContext context, int index) {
                return MapMarker(
                  latitude: _markerPosition.latitude,
                  longitude: _markerPosition.longitude,
                  child: GestureDetector(
                    onPanUpdate: (details) => _updateMarkerPosition(details),
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.additionalRed,
                      size: 32,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Column(
            children: [
              _buildButton(Icons.arrow_upward, () => _moveMarker(0, 1)),
              Row(
                children: [
                  _buildButton(Icons.arrow_back, () => _moveMarker(-1, 0)),
                  const SizedBox(width: 30),
                  _buildButton(Icons.arrow_forward, () => _moveMarker(1, 0)),
                ],
              ),
              _buildButton(Icons.arrow_downward, () => _moveMarker(0, -1)),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 8,
          child: Row(
            children: [
              _buildButton(Icons.add, _zoomIn),
              _buildButton(Icons.remove, _zoomOut),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onPressed) {
    return IconButton.filled(
      visualDensity: VisualDensity.comfortable,
      iconSize: 20,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
      ),
      icon: Icon(icon),
    );
  }

  void _moveMarker(double lng, double lat) {
    final stepSize = _calculateStepSize();
    setState(() {
      _markerPosition = MapLatLng(
        _markerPosition.latitude + lat * stepSize,
        _markerPosition.longitude + lng * stepSize,
      );
      _mapController.updateMarkers([0]);
    });
  }

  void _updateMarkerPosition(DragUpdateDetails details) {
    setState(() {
      _mapController.updateMarkers([0]);
    });
  }

  void _zoomIn() {
    setState(() {
      _zoomPanBehavior.zoomLevel = (_zoomPanBehavior.zoomLevel + 1)
          .clamp(_zoomPanBehavior.minZoomLevel, _zoomPanBehavior.maxZoomLevel);
      _updateZoomLevel(_zoomPanBehavior.zoomLevel);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomPanBehavior.zoomLevel = (_zoomPanBehavior.zoomLevel - 1)
          .clamp(_zoomPanBehavior.minZoomLevel, _zoomPanBehavior.maxZoomLevel);
      _updateZoomLevel(_zoomPanBehavior.zoomLevel);
    });
  }
}
