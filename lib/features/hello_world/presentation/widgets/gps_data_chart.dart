
import 'dart:async';

import 'package:coach_app/features/sessions/infrastructure/data/fake_gps_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_data_analysis/gps_data_analysis.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GpsDataChart extends ConsumerStatefulWidget {
  final String title;
  final FakeGpsDataService fakeGpsDataService;

  const GpsDataChart({
    super.key,
    required this.title,
    required this.fakeGpsDataService,
  });

  @override
  ConsumerState<GpsDataChart> createState() => _GpsDataChartState();
}

class _GpsDataChartState extends ConsumerState<GpsDataChart> {
  List<GpsData> chartData = [];
  StreamSubscription<GpsData>? _subscription;
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    _subscription = widget.fakeGpsDataService.gpsDataStream.listen((data) {
      setState(() {
        _startTime ??= DateTime.fromMillisecondsSinceEpoch(data.timestamp);
        _endTime ??= DateTime.fromMillisecondsSinceEpoch(data.timestamp + 10000);

        final currentTime = DateTime.fromMillisecondsSinceEpoch(data.timestamp);
        
        if (currentTime.isAfter(_endTime!)) {
          _endTime = currentTime.add(const Duration(seconds: 10));
        }

        chartData.add(data);
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(
          height: 300,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              minimum: _startTime,
              maximum: _endTime,
            ),
            series: <LineSeries<GpsData, DateTime>>[
              LineSeries<GpsData, DateTime>(
                dataSource: chartData,
                xValueMapper: (GpsData gps, _) => 
                    DateTime.fromMillisecondsSinceEpoch(gps.timestamp),
                yValueMapper: (GpsData gps, _) => gps.velocity,
              )
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.fakeGpsDataService.isGeneratingData()) {
              widget.fakeGpsDataService.stopGeneratingData();
            } else {
              setState(() {
                _startTime = null;
                chartData.clear();
              });
              widget.fakeGpsDataService.startGeneratingData();
            }
          },
          child: StreamBuilder<bool>(
            stream: widget.fakeGpsDataService.isGeneratingDataStream,
            builder: (context, snapshot) {
              return Icon(
                snapshot.data == true ? Icons.stop : Icons.play_arrow,
              );
            },
          ),
        ),
      ],
    );
  }
}
