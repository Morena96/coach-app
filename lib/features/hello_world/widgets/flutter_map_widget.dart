import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:coach_app/core/theme/app_colors.dart';

/// A full-screen map widget using flutter_map with satellite/streets view and dynamic marker functionality.
class FlutterMapWidget extends ConsumerStatefulWidget {
  /// The initial center position of the map.
  final LatLng initialCenter;

  /// The initial zoom level of the map.
  final double initialZoom;

  /// The URL template for the map tiles.
  final String tileUrlTemplate;

  const FlutterMapWidget({
    super.key,
    required this.initialCenter,
    this.initialZoom = 15,
    required this.tileUrlTemplate,
  });

  @override
  ConsumerState<FlutterMapWidget> createState() => _FlutterMapWidgetState();
}

class _FlutterMapWidgetState extends ConsumerState<FlutterMapWidget> {
  late MapController _mapController;
  late LatLng _markerPosition;
  double _currentZoom = 15;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _markerPosition = widget.initialCenter;
    _currentZoom = widget.initialZoom;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: widget.initialCenter,
            zoom: widget.initialZoom,
            minZoom: 1,
            maxZoom: 22,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                setState(() {
                  _currentZoom = position.zoom ?? _currentZoom;
                });
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: widget.tileUrlTemplate,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _markerPosition,
                  width: 32,
                  height: 32,
                  child: GestureDetector(
                    onPanUpdate: (details) => _updateMarkerPosition(details),
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.additionalRed,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        _buildControlButtons(),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Stack(
      children: [
        Positioned(
          bottom: 8,
          right: 8,
          child: Column(
            children: [
              _buildButton(Icons.arrow_upward, () => _moveMarker(0, 0.001)),
              Row(
                children: [
                  _buildButton(Icons.arrow_back, () => _moveMarker(-0.001, 0)),
                  const SizedBox(width: 30),
                  _buildButton(
                      Icons.arrow_forward, () => _moveMarker(0.001, 0)),
                ],
              ),
              _buildButton(Icons.arrow_downward, () => _moveMarker(0, -0.001)),
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
    setState(() {
      _markerPosition = LatLng(
        _markerPosition.latitude + lat,
        _markerPosition.longitude + lng,
      );
    });
  }

  void _updateMarkerPosition(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.globalToLocal(details.globalPosition);
    final newLatLng =
        _mapController.pointToLatLng(CustomPoint(offset.dx, offset.dy));

    setState(() {
      _markerPosition = newLatLng;
    });
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(1, 22);
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(1, 22);
      _mapController.move(_mapController.center, _currentZoom);
    });
  }
}
