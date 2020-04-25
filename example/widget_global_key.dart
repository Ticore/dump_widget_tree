import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dump_widget_tree/dump_widget_tree.dart';

///
/// use `dumpWidgetTree` to oberve how the widget to restore state from global key
///
void main() {
  final key = GlobalKey(debugLabel: 'MyKey');
  // final key = UniqueKey();
  final widget = StatefulBlock(key: key, text: 'MyWidget');
  testWidgets('dump widget tree w/ global key state',
      (WidgetTester tester) async {
    await tester.pumpWidget(widget);
    dumpWidgetTree();
    await tester.pumpWidget(Opacity(opacity: 0.6, child: widget));
    dumpWidgetTree();
  });
}

class StatelessBlock extends StatelessWidget {
  final String text;
  const StatelessBlock({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) => Text(text);
}

class StatefulBlock extends StatefulWidget {
  final String text;
  const StatefulBlock({Key key, this.text}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BlockState(text);
}

class _BlockState extends State {
  String text;
  _BlockState(this.text);
  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: Text(text),
      );
}
