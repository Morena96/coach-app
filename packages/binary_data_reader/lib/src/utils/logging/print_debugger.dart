// PrintDebugger class
import 'logger.dart';

class PrintDebugger implements Logger {
  @override
  void log(String message) {
    print(message);
  }
}