import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dump_widget_tree/dump_widget_tree.dart';

void main() {
  testWidgets('test widget tree of Container()', (WidgetTester tester) async {
    await tester.pumpWidget(Container());
    var rootElement = WidgetsBinding.instance.renderViewElement;
    var rootEntity = Entry(element: rootElement);
    dumpWidgetTree();
    testEntity(rootEntity, rootElement);
  });
  testWidgets('test widget tree of FlutterLogo()', (WidgetTester tester) async {
    await tester.pumpWidget(FlutterLogo());
    var rootElement = WidgetsBinding.instance.renderViewElement;
    var rootEntity = Entry(element: rootElement);
    dumpWidgetTree();
    testEntity(rootEntity, rootElement);
  });
  testWidgets('test widget tree of ClipRRect()', (WidgetTester tester) async {
    Icon icon = Icon(Icons.favorite, size: 12);
    ClipRRect clipRect = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: icon,
    );
    await tester.pumpWidget(Directionality(
      child: clipRect,
      textDirection: TextDirection.ltr,
    ));
    var rootElement = WidgetsBinding.instance.renderViewElement;
    var rootEntity = Entry(element: rootElement);
    dumpWidgetTree();
    testEntity(rootEntity, rootElement);
  });
  testWidgets('test widget tree of Stack()', (WidgetTester tester) async {
    Icon icon = Icon(Icons.favorite, size: 12);
    Stack stack = Stack(
      children: <Widget>[icon, Opacity(opacity: 0.5, child: icon)],
      alignment: Alignment.center,
    );
    await tester.pumpWidget(Directionality(
      child: stack,
      textDirection: TextDirection.ltr,
    ));
    var rootElement = WidgetsBinding.instance.renderViewElement;
    var rootEntity = Entry(element: rootElement);
    dumpWidgetTree();
    testEntity(rootEntity, rootElement);
  });
}

testEntity(Entry entity, Element element) {
  expect(entity.element, element, reason: 'match element');
  expect(entity.widget, element.widget, reason: 'match widget');
  var renderObject =
      (element is RenderObjectElement) ? element.renderObject : null;
  expect(entity.renderObject, renderObject, reason: 'match renderObject');
  var elementLayer = element.renderObject?.layer;
  expect(entity.layer, elementLayer,
      reason: 'match layer', skip: elementLayer == null);
  testChildren(entity, element);
}

testChildren(Entry entity, Element element) {
  var entities = entity.children.toList();
  var elements = [];
  element.visitChildElements((element) => elements.add(element));
  expect(entities.length, elements.length, reason: 'match children length');
  Iterable.generate(max(entities.length, elements.length)).forEach((i) {
    testEntity(entities[i], elements[i]);
  });
}
