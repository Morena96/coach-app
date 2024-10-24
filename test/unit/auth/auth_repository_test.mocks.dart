// Mocks generated by Mockito 5.4.4 from annotations
// in coach_app/test/unit/auth/auth_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:coach_app/features/auth/data/auth_storage.dart' as _i5;
import 'package:coach_app/shared/services/api/api_service.dart' as _i3;
import 'package:hive_flutter/hive_flutter.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

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

class _FakeFuture_0<T1> extends _i1.SmartFake implements _i2.Future<T1> {
  _FakeFuture_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PublicApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPublicApiService extends _i1.Mock implements _i3.PublicApiService {
  MockPublicApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Future<T> get<T>(
    String? path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [path],
          {
            #queryParameters: queryParameters,
            #fromJson: fromJson,
          },
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #get,
                  [path],
                  {
                    #queryParameters: queryParameters,
                    #fromJson: fromJson,
                  },
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #get,
                [path],
                {
                  #queryParameters: queryParameters,
                  #fromJson: fromJson,
                },
              ),
            ),
      ) as _i2.Future<T>);

  @override
  _i2.Future<T> post<T>(
    String? path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [path],
          {
            #data: data,
            #fromJson: fromJson,
          },
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #post,
                  [path],
                  {
                    #data: data,
                    #fromJson: fromJson,
                  },
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #post,
                [path],
                {
                  #data: data,
                  #fromJson: fromJson,
                },
              ),
            ),
      ) as _i2.Future<T>);

  @override
  _i2.Future<T> put<T>(
    String? path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [path],
          {
            #data: data,
            #fromJson: fromJson,
          },
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #put,
                  [path],
                  {
                    #data: data,
                    #fromJson: fromJson,
                  },
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #put,
                [path],
                {
                  #data: data,
                  #fromJson: fromJson,
                },
              ),
            ),
      ) as _i2.Future<T>);

  @override
  _i2.Future<T> delete<T>(
    String? path, {
    T Function(dynamic)? fromJson,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [path],
          {#fromJson: fromJson},
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #delete,
                  [path],
                  {#fromJson: fromJson},
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #delete,
                [path],
                {#fromJson: fromJson},
              ),
            ),
      ) as _i2.Future<T>);

  @override
  _i2.Future<T> handleErrors<T>(_i2.Future<T> Function()? apiCall) =>
      (super.noSuchMethod(
        Invocation.method(
          #handleErrors,
          [apiCall],
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #handleErrors,
                  [apiCall],
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #handleErrors,
                [apiCall],
              ),
            ),
      ) as _i2.Future<T>);
}

/// A class which mocks [PrivateApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockPrivateApiService extends _i1.Mock implements _i3.PrivateApiService {
  MockPrivateApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Future<T> get<T>(
    String? path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [path],
          {
            #queryParameters: queryParameters,
            #fromJson: fromJson,
          },
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #get,
                  [path],
                  {
                    #queryParameters: queryParameters,
                    #fromJson: fromJson,
                  },
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #get,
                [path],
                {
                  #queryParameters: queryParameters,
                  #fromJson: fromJson,
                },
              ),
            ),
      ) as _i2.Future<T>);

  @override
  _i2.Future<T> post<T>(
    String? path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [path],
          {
            #data: data,
            #fromJson: fromJson,
          },
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #post,
                  [path],
                  {
                    #data: data,
                    #fromJson: fromJson,
                  },
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #post,
                [path],
                {
                  #data: data,
                  #fromJson: fromJson,
                },
              ),
            ),
      ) as _i2.Future<T>);

  @override
  _i2.Future<T> put<T>(
    String? path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [path],
          {
            #data: data,
            #fromJson: fromJson,
          },
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #put,
                  [path],
                  {
                    #data: data,
                    #fromJson: fromJson,
                  },
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #put,
                [path],
                {
                  #data: data,
                  #fromJson: fromJson,
                },
              ),
            ),
      ) as _i2.Future<T>);

  @override
  _i2.Future<T> delete<T>(
    String? path, {
    T Function(dynamic)? fromJson,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [path],
          {#fromJson: fromJson},
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #delete,
                  [path],
                  {#fromJson: fromJson},
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #delete,
                [path],
                {#fromJson: fromJson},
              ),
            ),
      ) as _i2.Future<T>);

  @override
  _i2.Future<T> handleErrors<T>(_i2.Future<T> Function()? apiCall) =>
      (super.noSuchMethod(
        Invocation.method(
          #handleErrors,
          [apiCall],
        ),
        returnValue: _i4.ifNotNull(
              _i4.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #handleErrors,
                  [apiCall],
                ),
              ),
              (T v) => _i2.Future<T>.value(v),
            ) ??
            _FakeFuture_0<T>(
              this,
              Invocation.method(
                #handleErrors,
                [apiCall],
              ),
            ),
      ) as _i2.Future<T>);
}

/// A class which mocks [AuthStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthStorage extends _i1.Mock implements _i5.AuthStorage {
  MockAuthStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set box(_i6.Box<dynamic>? _box) => super.noSuchMethod(
        Invocation.setter(
          #box,
          _box,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get isInitialized => (super.noSuchMethod(
        Invocation.getter(#isInitialized),
        returnValue: false,
      ) as bool);

  @override
  _i2.Future<void> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i2.Future<void>.value(),
        returnValueForMissingStub: _i2.Future<void>.value(),
      ) as _i2.Future<void>);

  @override
  _i2.Future<void> saveAuthData(
    String? token,
    String? refreshToken,
    DateTime? expiresAt,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveAuthData,
          [
            token,
            refreshToken,
            expiresAt,
          ],
        ),
        returnValue: _i2.Future<void>.value(),
        returnValueForMissingStub: _i2.Future<void>.value(),
      ) as _i2.Future<void>);

  @override
  _i2.Future<String?> getToken() => (super.noSuchMethod(
        Invocation.method(
          #getToken,
          [],
        ),
        returnValue: _i2.Future<String?>.value(),
      ) as _i2.Future<String?>);

  @override
  _i2.Future<String?> getRefreshToken() => (super.noSuchMethod(
        Invocation.method(
          #getRefreshToken,
          [],
        ),
        returnValue: _i2.Future<String?>.value(),
      ) as _i2.Future<String?>);

  @override
  _i2.Future<DateTime?> getExpiresAt() => (super.noSuchMethod(
        Invocation.method(
          #getExpiresAt,
          [],
        ),
        returnValue: _i2.Future<DateTime?>.value(),
      ) as _i2.Future<DateTime?>);

  @override
  _i2.Future<void> clearAuthData() => (super.noSuchMethod(
        Invocation.method(
          #clearAuthData,
          [],
        ),
        returnValue: _i2.Future<void>.value(),
        returnValueForMissingStub: _i2.Future<void>.value(),
      ) as _i2.Future<void>);

  @override
  _i2.Future<bool> hasValidToken() => (super.noSuchMethod(
        Invocation.method(
          #hasValidToken,
          [],
        ),
        returnValue: _i2.Future<bool>.value(false),
      ) as _i2.Future<bool>);
}
