import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/infrastructure/data/models/hive_group.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_member.dart';

@GenerateMocks([BinaryReader, BinaryWriter])
import 'hive_group_adapter_test.mocks.dart';

void main() {
  group('HiveGroupAdapter', () {
    late HiveGroupAdapter adapter;

    setUp(() {
      adapter = HiveGroupAdapter();
    });

    test('typeId should be 2', () {
      expect(adapter.typeId, 2);
    });

    test('read should correctly deserialize HiveGroup', () {
      final mockReader = MockBinaryReader();
      when(mockReader.readByte()).thenReturnInOrder([3, 0, 1, 2]);
      when(mockReader.read()).thenReturnInOrder(['id', 'name', [HiveMember(id: 'member1', athleteId: 'athlete1', groupId: 'id', role: GroupRole.athlete.name), HiveMember(id: 'member2', athleteId: 'athlete2', groupId: 'id', role: GroupRole.athlete.name)]]);
      final result = adapter.read(mockReader);
      expect(result, isA<HiveGroup>());
      expect(result.id, 'id');
      expect(result.name, 'name');
    });

    test('write should correctly serialize HiveGroup', () {
      final mockWriter = MockBinaryWriter();
      final hiveGroup = HiveGroup(
        id: '1',
        name: 'Test Group',
      );

      adapter.write(mockWriter, hiveGroup);

      verifyInOrder([
        mockWriter.writeByte(2),
        mockWriter.writeByte(0),
        mockWriter.write('1'),
        mockWriter.writeByte(1),
        mockWriter.write('Test Group'),
      ]);
    });

    test('hashCode should be based on typeId', () {
      expect(adapter.hashCode, adapter.typeId.hashCode);
    });

    test('equality operator should work correctly', () {
      final adapter1 = HiveGroupAdapter();
      final adapter2 = HiveGroupAdapter();

      expect(adapter1 == adapter2, isTrue);
    });
  });

  group('HiveGroup', () {
    test('fromDomain should correctly create HiveGroup from Group', () {
      const group = Group(id: '1', name: 'Test Group', );
      final hiveGroup = HiveGroup.fromDomain(group);

      expect(hiveGroup.id, '1');
      expect(hiveGroup.name, 'Test Group');
    });

    test('toDomain should correctly create Group from HiveGroup', () {
      final hiveGroup = HiveGroup(id: '1', name: 'Test Group');
      final group = hiveGroup.toDomain();

      expect(group.id, '1');
      expect(group.name, 'Test Group');
      
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
