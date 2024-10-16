import 'package:coach_app/features/hello_world/presentation/widgets/gps_data_chart.dart';
import 'package:coach_app/features/sessions/infrastructure/data/fake_gps_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_app/l10n.dart';
class ViewSampleGpsData extends ConsumerWidget {
  const ViewSampleGpsData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final velocityDataService1 = FakeGpsDataService();
    final velocityDataService2 = FakeGpsDataService();
    final velocityDataService3 = FakeGpsDataService();
    final velocityDataService4 = FakeGpsDataService();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.viewSampleGpsData),
      ),
      body: ListView(
        children: [
          GpsDataChart(
            key: const ValueKey('velocity_chart_1'),
            title: 'Velocity 1',
            fakeGpsDataService: velocityDataService1,
          ),
          GpsDataChart(
            key: const ValueKey('velocity_chart_2'),
            title: 'Velocity 2',
            fakeGpsDataService: velocityDataService2,
          ),
          GpsDataChart(
            key: const ValueKey('velocity_chart_3'),
            title: 'Velocity 3',
            fakeGpsDataService: velocityDataService3,
          ),
          GpsDataChart(
            key: const ValueKey('velocity_chart_4'),
            title: 'Velocity 4',
            fakeGpsDataService: velocityDataService4,
          ),
        ],
      ),
    );
  }
}
