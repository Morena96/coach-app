import 'package:domain/features/shared/utilities/reactive_stream.dart';
import 'package:rxdart/rxdart.dart';

class RxBehaviorStream<T> implements ReactiveStream<T> {
  final BehaviorSubject<T> _subject;

  RxBehaviorStream()
      : _subject = BehaviorSubject<T>();

  @override
  Stream<T> get stream => _subject.stream;

  @override
  T? get value => _subject.value;

  @override
  void add(T event) {
    _subject.add(event);
  }

  @override
  void close() {
    _subject.close();
  }
}
