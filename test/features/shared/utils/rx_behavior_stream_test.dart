import 'package:coach_app/features/shared/utils/rx_behavior_stream.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RxBehaviorStream', () {
    late RxBehaviorStream<int> stream;

    setUp(() {
      stream = RxBehaviorStream<int>();
    });

    tearDown(() {
      stream.close();
    });

    test('should emit added values', () {
      expect(stream.stream, emitsInOrder([1, 2, 3]));

      stream.add(1);
      stream.add(2);
      stream.add(3);
    });

    test('should provide the latest value', () {
      stream.add(1);
      expect(stream.value, equals(1));

      stream.add(2);
      expect(stream.value, equals(2));
    });

    test('should close the stream', () {
      expect(stream.stream, emitsThrough(emitsDone));

      stream.add(1);
      stream.close();
    });

    test('should not emit after closing', () {
      stream.close();
      expect(() => stream.add(1), throwsStateError);
    });
  });
}
