abstract class ReactiveStream<T> {
  Stream<T> get stream;

  T? get value;

  void add(T event);

  void close();
}
