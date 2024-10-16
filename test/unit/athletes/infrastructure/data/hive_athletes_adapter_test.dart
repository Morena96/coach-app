import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_athlete.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([BinaryReader, BinaryWriter])
import 'hive_athletes_adapter_test.mocks.dart';

void main() {
  group('HiveAthleteAdapter', () {
    late HiveAthleteAdapter adapter;

    setUp(() {
      adapter = HiveAthleteAdapter();
    });

    test('typeId should be 1', () {
      expect(adapter.typeId, 1);
    });

    test('read should correctly deserialize HiveAthlete', () {
      final mockReader = MockBinaryReader();
      when(mockReader.readByte()).thenReturnInOrder([5, 0, 1, 2, 3, 4]);
      when(mockReader.read()).thenReturnInOrder(['id', 'name', 'avatarId', null, false]);
      final result = adapter.read(mockReader);
      expect(result, isA<HiveAthlete>());
      expect(result.id, 'id');
      expect(result.name, 'name');
      expect(result.avatarId, 'avatarId');
      expect(result.sportIds, null);
      expect(result.archived, false);
    });

    test('write should correctly serialize HiveAthlete', () {
      final mockWriter = MockBinaryWriter();
      final hiveAthlete = HiveAthlete(
        id: '1',
        name: 'John Doe',
        avatarId: 'avatar123',
        sportIds: ['sport1', 'sport2'],
        archived: true,
      );

      adapter.write(mockWriter, hiveAthlete);

      verifyInOrder([
        mockWriter.writeByte(5),
        mockWriter.writeByte(0),
        mockWriter.write('1'),
        mockWriter.writeByte(1),
        mockWriter.write('John Doe'),
        mockWriter.writeByte(2),
        mockWriter.write('avatar123'),
        mockWriter.writeByte(3),
        mockWriter.write(['sport1', 'sport2']),
        mockWriter.writeByte(4),
        mockWriter.write(true),
      ]);
    });

    test('hashCode should be based on typeId', () {
      expect(adapter.hashCode, adapter.typeId.hashCode);
    });

    test('equality operator should work correctly', () {
      final adapter1 = HiveAthleteAdapter();
      final adapter2 = HiveAthleteAdapter();

      expect(adapter1 == adapter2, isTrue);
    });
  });
}

class MockTypeAdapter extends TypeAdapter<dynamic> {
  @override
  dynamic read(BinaryReader reader) => throw UnimplementedError();

  @override
  int get typeId => 999;

  @override
  void write(BinaryWriter writer, dynamic obj) => throw UnimplementedError();
}
