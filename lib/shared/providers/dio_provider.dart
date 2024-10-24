import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

/// Provides the Dio HTTP client
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  return Dio();
}
