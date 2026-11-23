import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:widgets_box/widgets_box.dart';

void main() {
  testWidgets(
    'installed version remains visible with current platform metadata',
    (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'Support host',
        packageName: 'example.support.host',
        version: '2.4.0',
        buildNumber: '42',
        buildSignature: '',
      );
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WBAppVersion())),
      );
      await tester.pumpAndSettle();
      expect(find.text('v2.4.0+42'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
