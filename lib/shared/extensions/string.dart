extension StringExtension on String {
  /// String like `hello world` converts to `Hello world`
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// String like `helloWorld` converts to `Hello World`
  String convertCamelCaseToSpacedUpperCase() {
    if (isEmpty) return '';
    final result = StringBuffer(this[0].toUpperCase());
    for (int i = 1; i < length; i++) {
      if (this[i].toUpperCase() == this[i] &&
          this[i].toLowerCase() != this[i]) {
        result.write(' ${this[i]}');
      } else {
        result.write(this[i]);
      }
    }
    return result.toString();
  }
}
