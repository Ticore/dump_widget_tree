import 'dart:collection';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

///
/// A helper function that print [Widget]/[Element]/[RenderObject]/[Layer] trees, side-by-side.
/// It helps to understand the relationships between [Widget], [Element], [RenderObject] and [Layer].
///
void dumpWidgetTree() {
  Entry rootEntity = Entry(element: WidgetsBinding.instance.renderViewElement);

  List<List<String>> outputs = rootEntity.toStringList();
  int len0 = outputs.map((e) => e[0]).fold<int>(0, _maxLenFn) + 0;
  int len1 = outputs.map((e) => e[1]).fold<int>(0, _maxLenFn) + 0;
  int len2 = outputs.map((e) => e[2]).fold<int>(0, _maxLenFn) + 0;
  int len3 = outputs.map((e) => e[3]).fold<int>(0, _maxLenFn) + 0;

  // print tree header
  debugPrint('${'[Widget Tree]'.padRight(len0, '-')}'
      '│${'[Element Tree]'.padRight(len1, '-')}'
      '│${'[RenderObject Tree]'.padRight(len2, '-')}'
      '│${'[Layer Tree]'.padRight(len3, '-')}');

  // print tree body
  outputs.forEach((e) => debugPrint(
      '${e[0].padRight(len0)}│${e[1].padRight(len1)}│${e[2].padRight(len2)}│${e[3]}'));
}

Function _maxLenFn =
    (int previousValue, String value) => max(previousValue, value.length);

extension _ObjectExt on Object {
  T cast<T>() => this is T ? this : null;
  String identity({String prefix = '', int width = 30}) => (this == null
          ? '$prefix()'
          : '$prefix$runtimeType (#${shortHash(this)})')
      .padRight(width);
}

extension _ElementExt on Element {
  Key get key => widget?.key;
  State get state => cast<StatefulElement>()?.state;
  RenderObject get renderObjectSelf =>
      cast<RenderObjectElement>()?.renderObject;
  Layer get layer => renderObjectSelf?.layer;
  List<Element> get children {
    List<Element> _children = <Element>[];
    visitChildElements((Element element) => _children.add(element));
    return _children;
  }
}

/// 
/// An [Element] wrapper, that is automatically find related [Widget], [RenderObject], [Layer] and child entries.
/// 
class Entry extends LinkedListEntry<Entry> {
  Entry parent;

  Element element;
  Widget widget;
  Key key;
  State state;
  RenderObject renderObject;
  Layer layer;
  LinkedList<Entry> children;

  Entry({this.element, this.parent})
      : widget = element.widget,
        key = element.key,
        state = element.state,
        renderObject = element.renderObjectSelf,
        layer = element.layer {
    var entries = element.children.map<Entry>(
      (e) => Entry(element: e, parent: this),
    );
    children = LinkedList<Entry>()..addAll(entries);

    // find unlinked layers
    if (renderObject != null && layer == null) {
      Entry tmp = parent;
      while (!(tmp.element is RenderObjectElement)) {
        tmp = tmp.parent;
      }
      Layer possibleLayer = tmp.layer.cast<ContainerLayer>()?.firstChild;
      bool ispossibleLayerUnlinked =
          possibleLayer != null && possibleLayer.engineLayer == null;
      if (ispossibleLayerUnlinked) {
        layer = possibleLayer;
      }
    }

    children.skip(1).forEach((entity) {
      if (entity.layer == null) {
        Layer nextLayer = entity.previous?.layer?.nextSibling;
        bool isUnlinkedLayer = [
          PictureLayer,
          PerformanceOverlayLayer,
          TextureLayer
        ].contains(nextLayer.runtimeType);
        if (nextLayer != null &&
            isUnlinkedLayer &&
            nextLayer.engineLayer == null) {
          entity.layer = nextLayer;
        }
      }
    });
  }

  /// Dump current entry and children as string list.
  List<List<String>> toStringList(
      {String prefix = '', List<List<String>> list}) {
    String selfPrefix = (next == null) ? '$prefix└─' : '$prefix├─';
    String childPrefix = (next == null) ? '$prefix  ' : '$prefix│ ';
    String wrapPrefix = (next == null)
        ? (children.length > 0 ? '$prefix  │' : '$prefix   ')
        : '$prefix│ │';
    list ??= [];
    list.add([
      '${widget.identity(prefix: selfPrefix)}',
      '${element.identity(prefix: selfPrefix)}',
      '${renderObject.identity(prefix: selfPrefix)}',
      '${layer.identity(prefix: selfPrefix)}',
    ]);

    if (key != null || state != null) {
      list.add([
        '${key == null ? wrapPrefix : key.identity(prefix: '$wrapPrefix  → ')}',
        '${state == null ? wrapPrefix : state.identity(prefix: '$wrapPrefix  → ')}',
        '$wrapPrefix',
        '$wrapPrefix',
      ]);
    }
    children.forEach((e) => e.toStringList(prefix: childPrefix, list: list));
    return list;
  }
}
