import 'package:example/special_text/my_special_text_span_builder.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';

@FFRoute(
  name: 'fluttercandies://SelectableTextDemo',
  routeName: 'SelectableText',
  description: 'support SelectableText',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 3,
  },
)
class SelectableTextDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SelectableText'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ExtendedSelectableText(
          '[17]Extended text help you to build rich text quickly. any special text you will have with extended text. '
          '\n\nIt\'s my pleasure to invite you to join \$FlutterCandies\$ if you want to improve flutter .[17]'
          '\n\nif you meet any problem, please let me know @zmtzawqlp .[36]',
          specialTextSpanBuilder: MySpecialTextSpanBuilder(),
        ),
      ),
    );
  }
}
