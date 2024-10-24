// Mocks generated by Mockito 5.4.4 from annotations
// in domain/test/unit/features/antenna_system/state_machine/antenna_state_factory_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:binary_data_reader/main.dart' as _i3;
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart'
    as _i2;
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart'
    as _i5;
import 'package:domain/features/logging/repositories/logger.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAntennaCommandRepository_0 extends _i1.SmartFake
    implements _i2.AntennaCommandRepository {
  _FakeAntennaCommandRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFrameParsingStrategy_1 extends _i1.SmartFake
    implements _i3.FrameParsingStrategy {
  _FakeFrameParsingStrategy_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLoggerRepository_2 extends _i1.SmartFake
    implements _i4.LoggerRepository {
  _FakeLoggerRepository_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AntennaContext].
///
/// See the documentation for Mockito's code generation for more information.
class MockAntennaContext extends _i1.Mock implements _i5.AntennaContext {
  MockAntennaContext() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AntennaCommandRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeAntennaCommandRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.AntennaCommandRepository);

  @override
  _i3.FrameParsingStrategy get parsingStrategy => (super.noSuchMethod(
        Invocation.getter(#parsingStrategy),
        returnValue: _FakeFrameParsingStrategy_1(
          this,
          Invocation.getter(#parsingStrategy),
        ),
      ) as _i3.FrameParsingStrategy);

  @override
  _i4.LoggerRepository get logger => (super.noSuchMethod(
        Invocation.getter(#logger),
        returnValue: _FakeLoggerRepository_2(
          this,
          Invocation.getter(#logger),
        ),
      ) as _i4.LoggerRepository);
}
