import 'dart:typed_data';

import 'package:application/antenna_system/hex_converter.dart';
import 'package:application/antenna_system/use_cases/get_antenna_system_state_usecase.dart';
import 'package:application/antenna_system/use_cases/receive_commands_usecase.dart';
import 'package:application/antenna_system/use_cases/send_command_to_antenna_state_machine_use_case.dart';
import 'package:application/antenna_system/use_cases/start_calibration_use_case.dart';
import 'package:binary_data_reader/main.dart';
import 'package:application/antenna_system/use_cases/get_antenna_data_stream.dart';
import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart';
import 'package:domain/features/antenna_system/repositories/antenna_system_repository.dart';
import 'package:domain/features/antenna_system/repositories/command_source.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  AntennaStateMachine,
  CommandSource,
  AntennaSystemRepository,
  AntennaDataRepository,
  HexConverter
])
import 'send_command_to_antenna_state_machine_use_case_test.mocks.dart';

void main() {
  group('SendCommandToAntennaStateMachineUseCase', () {
    late MockAntennaStateMachine mockStateMachine;
    late SendCommandToAntennaStateMachineUseCase useCase;

    setUp(() {
      mockStateMachine = MockAntennaStateMachine();
      useCase = SendCommandToAntennaStateMachineUseCase(mockStateMachine);
    });

    test('should send command to state machine', () {
      final command =
          StartLiveModeCommand(); // Replace with actual command initialization

      useCase.execute(command);

      verify(mockStateMachine.sendCommand(command)).called(1);
    });
  });

  group('StartCalibrationUseCase', () {
    late MockAntennaStateMachine mockStateMachine;
    late StartCalibrationUseCase useCase;

    setUp(() {
      mockStateMachine = MockAntennaStateMachine();
      useCase = StartCalibrationUseCase(mockStateMachine);
    });

    test('should start calibration', () {
      useCase.execute();

      verify(mockStateMachine.startCalibration()).called(1);
    });
  });

  group('ReceiveCommandsUseCase', () {
    late MockCommandSource mockCommandSource;
    late ReceiveCommandsUseCase useCase;

    setUp(() {
      mockCommandSource = MockCommandSource();
      useCase = ReceiveCommandsUseCase(mockCommandSource);
    });

    test('should receive commands from command source', () {
      final command = StartLiveModeCommand();
      final commandStream = Stream<Command>.fromIterable([command]);

      when(mockCommandSource.getCommands()).thenAnswer((_) => commandStream);

      expectLater(useCase.execute(), emitsInOrder([command]));
      verify(mockCommandSource.getCommands()).called(1);
    });
  });

  group('GetAntennaSystemStateUseCase', () {
    late MockAntennaSystemRepository mockRepository;
    late GetAntennaSystemStateUseCase useCase;

    setUp(() {
      mockRepository = MockAntennaSystemRepository();
      useCase = GetAntennaSystemStateUseCase(mockRepository);
    });

    test('should get antenna system state from repository', () {
      const state = AntennaSystemState
          .connected; // Replace with actual state initialization
      final antennaInfoList = [
        AntennaInfo(
          portName: 'COM2',
          description: 'Antenna 2',
          serialNumber: '789012',
          vendorId: 1002,
          productId: 2002,
        ),
      ]; // Replace with actual antenna info initialization
      final stateStream =
          Stream<(AntennaSystemState, List<AntennaInfo>)>.fromIterable(
              [(state, antennaInfoList)]);

      when(mockRepository.getAntennaSystemStream())
          .thenAnswer((_) => stateStream);

      expectLater(useCase(), emitsInOrder([(state, antennaInfoList)]));
      verify(mockRepository.getAntennaSystemStream()).called(1);
    });
  });

  group('GetAntennaDataStream', () {
    late MockAntennaDataRepository mockRepository;
    late GetAntennaDataStreamUseCase useCase;
    late MockHexConverter mockHexConverter;

    setUp(() {
      mockRepository = MockAntennaDataRepository();
      mockHexConverter = MockHexConverter();
      useCase = GetAntennaDataStreamUseCase(mockRepository, mockHexConverter);
    });

    test('should get hex stream from repository', () async {
      // Arrange
      const portName = 'COM1';
      final rawStream = Stream<Uint8List>.fromIterable([
        Uint8List.fromList([0x48, 0x65, 0x6C, 0x6C, 0x6F]), // "Hello" in ASCII
        Uint8List.fromList([0x57, 0x6F, 0x72, 0x6C, 0x64]) // "World" in ASCII
      ]);
      when(mockRepository.getDataStream(portName)).thenAnswer((_) => rawStream);
      when(mockHexConverter.streamToHex(rawStream)).thenAnswer((_) =>
          Stream<String>.fromIterable(['48 65 6c 6c 6f', '57 6f 72 6c 64']));
      // Act
      final resultStream = useCase.call(portName);

      // Assert
      expect(
          resultStream,
          emitsInOrder([
            '48 65 6c 6c 6f', // "Hello" in hex
            '57 6f 72 6c 64', // "World" in hex
            emitsDone
          ]));

      verify(mockRepository.getDataStream(portName)).called(1);
    });

    test('should handle empty stream', () async {
      // Arrange
      const portName = 'COM2';
      final emptyStream = Stream<Uint8List>.fromIterable([]);
      when(mockRepository.getDataStream(portName))
          .thenAnswer((_) => emptyStream);
      when(mockHexConverter.streamToHex(emptyStream))
          .thenAnswer((_) => const Stream<String>.empty());

      // Act
      final resultStream = useCase.call(portName);

      // Assert
      expect(resultStream, emitsDone);

      verify(mockRepository.getDataStream(portName)).called(1);
    });
  });
}
