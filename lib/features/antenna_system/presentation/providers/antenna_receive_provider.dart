import 'package:application/antenna_system/use_cases/get_antenna_data_stream.dart';
import 'package:coach_app/features/antenna_system/infrastructure/adapters/hex_converter_impl.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_system_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'antenna_receive_provider.g.dart';

@Riverpod(keepAlive: true)
GetAntennaDataStreamUseCase getAntennaDataStreamUseCase(
    GetAntennaDataStreamUseCaseRef ref) {
  final repository = ref.watch(antennaDataRepositoryProvider);
  final hexConverter = HexConverterImpl();
  return GetAntennaDataStreamUseCase(repository, hexConverter);
}

@Riverpod(keepAlive: true)
Stream<List<String>> antennaDataStream(
    AntennaDataStreamRef ref, String portName) async* {
  final useCase = ref.watch(getAntennaDataStreamUseCaseProvider);
  var allMessages = const <String>[];
  await for (final message in useCase(portName)) {
    allMessages = [...allMessages, message];
    yield allMessages;
  }
}
