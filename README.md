# dump_widget_tree

Flutter helper function that print Widget/Element/RenderObject/Layer trees, side-by-side.

## Usage

Simply import it and call `dumpWidgetTree` function.

## Example

```dart
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
```

Will dump tree like this:

```
[Widget Tree]-----------------------------------------│[Element Tree]------------------------------------------│[RenderObject Tree]--------------------------│[Layer Tree]-------------------
└─RenderObjectToWidgetAdapter<RenderBox> (#001a6)     │└─RenderObjectToWidgetElement<RenderBox> (#00002)       │└─RenderView (#f72a5)                        │└─TransformLayer (#c3111)     
  │  → GlobalObjectKey<State<StatefulWidget>> (#f72a5)│  │                                                     │  │                                          │  │
  └─ShaderMask (#9e20f)                               │  └─SingleChildRenderObjectElement (#00007)             │  └─RenderShaderMask (#d0f08)                │  └─ShaderMaskLayer (#27978)  
    └─Directionality (#3e32b)                         │    └─InheritedElement (#00008)                         │    └─()                                     │    └─()                      
      └─Icon (#aa0c3)                                 │      └─StatelessElement (#00009)                       │      └─()                                   │      └─()                    
        └─Semantics (#d5bc0)                          │        └─SingleChildRenderObjectElement (#0000a)       │        └─RenderSemanticsAnnotations (#30b9e)│        └─PictureLayer (#feea8)
          └─ExcludeSemantics (#d5b15)                 │          └─SingleChildRenderObjectElement (#0000b)     │          └─RenderExcludeSemantics (#5fceb)  │          └─()                
            └─SizedBox (#99737)                       │            └─SingleChildRenderObjectElement (#0000c)   │            └─RenderConstrainedBox (#58537)  │            └─()              
              └─Center (#52e3b)                       │              └─SingleChildRenderObjectElement (#0000d) │              └─RenderPositionedBox (#568e9) │              └─()            
                └─RichText (#3793a)                   │                └─MultiChildRenderObjectElement (#0000e)│                └─RenderParagraph (#a7286)   │                └─()          
```

