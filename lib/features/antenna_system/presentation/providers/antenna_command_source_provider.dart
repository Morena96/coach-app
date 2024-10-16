import 'package:binary_data_reader/main.dart';
import 'package:coach_app/features/antenna_system/infrastructure/repositories/antenna_command_source.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_system_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'antenna_command_source_provider.g.dart';

@Riverpod(keepAlive: true)
AntennaCommandSource antennaCommandSource(AntennaCommandSourceRef ref) {
  final strategy = GatewayParsingStrategy();
  final parser = FramesParser(strategy);
  final processor = FramesProcessor(strategy);
  final repository = ref.watch(antennaDataRepositoryProvider);
  return AntennaCommandSource(repository, parser, processor);
}
