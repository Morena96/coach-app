// Mocks generated by Mockito 5.4.4 from annotations
// in coach_app/test/unit/antenna_system/presentation/providers/antenna_receive_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:application/antenna_system/hex_converter.dart' as _i3;
import 'package:application/antenna_system/use_cases/get_antenna_data_stream.dart'
    as _i4;
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart'
    as _i2;
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

class _FakeAntennaDataRepository_0 extends _i1.SmartFake
    implements _i2.AntennaDataRepository {
  _FakeAntennaDataRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeHexConverter_1 extends _i1.SmartFake implements _i3.HexConverter {
  _FakeHexConverter_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetAntennaDataStreamUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetAntennaDataStreamUseCase extends _i1.Mock
    implements _i4.GetAntennaDataStreamUseCase {
  MockGetAntennaDataStreamUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AntennaDataRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeAntennaDataRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.AntennaDataRepository);

  @override
  _i3.HexConverter get hexConverter => (super.noSuchMethod(
        Invocation.getter(#hexConverter),
        returnValue: _FakeHexConverter_1(
          this,
          Invocation.getter(#hexConverter),
        ),
      ) as _i3.HexConverter);

  @override
  _i5.Stream<String> call(String? portName) => (super.noSuchMethod(
        Invocation.method(
          #call,
          [portName],
        ),
        returnValue: _i5.Stream<String>.empty(),
      ) as _i5.Stream<String>);
}
