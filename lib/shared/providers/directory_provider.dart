import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'directory_provider.g.dart';

/// Provides the local storage directory
@Riverpod(keepAlive: true)
Directory directory(DirectoryRef ref) {
  throw UnimplementedError('Directory not initialized');
}
