import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_app/features/sessions/infrastructure/data/fake_gps_data_service.dart';

final fakeGpsDataServiceProvider = Provider.autoDispose<FakeGpsDataService>((ref) {
  final service = FakeGpsDataService();

  ref.onDispose(() {
    service.stopGeneratingData();
  });
  
  return service;
}, name: 'fakeGpsDataServiceProvider');
