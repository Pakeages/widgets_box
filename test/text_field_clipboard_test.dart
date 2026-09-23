import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_box/widgets_box.dart';

void main() {
  Widget host(Widget child) => MaterialApp(
    home: Scaffold(
      body: Center(child: SizedBox(width: 320, child: child)),
    ),
  );

  testWidgets('WBTextField.email exposes the default paste menu', (
    tester,
  ) async {
    await tester.pumpWidget(host(WBTextField.email()));

    final editableText = tester.widget<EditableText>(find.byType(EditableText));

    expect(editableText.contextMenuBuilder, isNotNull);
  });

  testWidgets('WBTextField.password accepts clipboard paste', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.getData') {
          return {'text': 'UCyuBjeb96CiP4E'};
        }
        if (call.method == 'Clipboard.hasStrings') {
          return {'value': true};
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await tester.pumpWidget(host(WBTextField.password()));

    final passwordField = find.byType(EditableText);
    expect(
      tester.widget<EditableText>(passwordField).contextMenuBuilder,
      isNotNull,
    );

    await tester.tap(passwordField);
    await tester
        .state<EditableTextState>(passwordField)
        .pasteText(SelectionChangedCause.toolbar);
    await tester.pump();

    expect(
      tester.widget<EditableText>(passwordField).controller.text,
      'UCyuBjeb96CiP4E',
    );
  });
}
