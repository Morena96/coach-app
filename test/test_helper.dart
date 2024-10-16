import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class TestHelper {
  static void expectRichTextWithText(WidgetTester tester, String text) {
    final richTextFinder = find.byType(RichText);
    expect(richTextFinder, findsOneWidget);
    final RichText richText = tester.widget(richTextFinder);
    expect(richText.text.toPlainText(), equals(text));
  }
}

Future<void> waitForAsyncData<T>(
    ProviderContainer container, ProviderListenable<AsyncValue<T>> provider) {
  final completer = Completer<void>();
  late final ProviderSubscription<AsyncValue<T>> subscription;

  subscription = container.listen<AsyncValue<T>>(
    provider,
    (_, next) {
      if (next is AsyncData && !completer.isCompleted) {
        completer.complete();
        subscription.close();
      }
    },
    fireImmediately: true,
  );

  return completer.future;
}
