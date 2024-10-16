import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SportView', () {
    test('should create a SportView instance with correct properties', () {
      const sportView = SportView(id: '1', name: 'Football');

      expect(sportView.id, '1');
      expect(sportView.name, 'Football');
    });

    test('fromDomain should create a SportView from a Sport instance', () {
      const sport = Sport(id: '2', name: 'Basketball');
      final sportView = SportView.fromDomain(sport);

      expect(sportView.id, sport.id);
      expect(sportView.name, sport.name);
    });

    test(
        'fromDomain should create different SportView instances for different Sport instances',
        () {
      const sport1 = Sport(id: '1', name: 'Football');
      const sport2 = Sport(id: '2', name: 'Basketball');

      final sportView1 = SportView.fromDomain(sport1);
      final sportView2 = SportView.fromDomain(sport2);

      expect(sportView1.id, '1');
      expect(sportView1.name, 'Football');
      expect(sportView2.id, '2');
      expect(sportView2.name, 'Basketball');
    });
  });
}
