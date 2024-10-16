import 'package:application/antenna_system/use_cases/send_antenna_command.dart';
import 'package:coach_app/features/antenna_system/infrastructure/adapters/hex_converter_impl.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_system_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendAntennaCommandUseCaseProvider =
    Provider<SendAntennaCommandUseCase>((ref) {
  final repository = ref.watch(antennaCommandRepositoryProvider);
  final hexConverter = HexConverterImpl();
  return SendAntennaCommandUseCase(repository, hexConverter);
});
