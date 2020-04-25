import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dump_widget_tree/dump_widget_tree.dart';

void main() {
  Directionality icon = Directionality(
    child: Icon(Icons.favorite, size: 12),
    textDirection: TextDirection.ltr,
  );
  ShaderMask shaderMask = ShaderMask(
    shaderCallback: (Rect bounds) {
      return RadialGradient(
        colors: <Color>[Colors.black, Colors.white],
      ).createShader(bounds);
    },
    child: icon,
  );
  testWidgets('dump widget tree: ShaderMask()', (WidgetTester tester) async {
    await tester.pumpWidget(shaderMask);
    dumpWidgetTree();
  });
}
