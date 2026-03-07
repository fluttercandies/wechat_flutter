import 'package:example/special_text/email_span_builder.dart';
import 'package:example/special_text/my_special_text_span_builder.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';

///
///  create by zmtzawqlp on 2019/8/4
///
@FFRoute(
  name: 'fluttercandies://WidgetSpanDemo',
  routeName: 'widget span',
  description: 'mailbox demo with widgetSpan',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 1,
  },
)
class WidgetSpanDemo extends StatefulWidget {
  @override
  _WidgetSpanDemoState createState() => _WidgetSpanDemoState();
}

class _WidgetSpanDemoState extends State<WidgetSpanDemo> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController()
    ..text =
        '[33]Extended text field help you to build rich text quickly. any special text you will have with extended text field. this is demo to show how to create special text with widget span.'
            '\n\nIt\'s my pleasure to invite you to join \$FlutterCandies\$ if you want to improve flutter .[36]'
            '\n\nif you meet any problem, please let me konw @zmtzawqlp .[44]';
  EmailSpanBuilder? _emailSpanBuilder;
  @override
  void initState() {
    _emailSpanBuilder = EmailSpanBuilder(controller, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-mail'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: const Text('To : '),
                width: 60.0,
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
              ),
              Expanded(
                child: ExtendedTextField(
                  controller: controller,
                  specialTextSpanBuilder: _emailSpanBuilder,
                  maxLines: null,
                  // StrutStyle get strutStyle {
                  //   if (_strutStyle == null) {
                  //     return StrutStyle.fromTextStyle(style, forceStrutHeight: true);
                  //   }
                  //   return _strutStyle!.inheritFromTextStyle(style);
                  // }
                  // default strutStyle is not good for WidgetSpan
                  strutStyle: const StrutStyle(),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final TextSelection selection =
                              controller.selection.copyWith();
                          showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext c) {
                                return Column(
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(),
                                    ),
                                    Expanded(
                                      child: Material(
                                          child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  insertEmail(
                                                      'zmtzawqlp@live.com ',
                                                      selection);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                    'zmtzawqlp@live.com')),
                                            TextButton(
                                                onPressed: () {
                                                  insertEmail(
                                                      '410496936@qq.com ',
                                                      selection);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                    '410496936@qq.com')),
                                          ],
                                        ),
                                      )),
                                    ),
                                    Flexible(
                                      child: Container(),
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                      border: InputBorder.none,
                      hintText: 'input receiver here'),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: <Widget>[
              Container(
                child: const Text('Topic : '),
                width: 60.0,
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: ExtendedTextField(
                  controller: controller1,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'input topic here'),
                ),
              )
            ],
          ),
          const Divider(),
          Expanded(
            child: ExtendedTextField(
              controller: controller2,
              maxLines: null,
              specialTextSpanBuilder: MySpecialTextSpanBuilder(),
              decoration: const InputDecoration(
                  border: InputBorder.none, contentPadding: EdgeInsets.all(10)),
            ),
          )
        ],
      ),
    );
  }

  void insertEmail(String text, TextSelection selection) {
    final TextEditingValue value = controller.value;
    final int start = selection.baseOffset;
    int end = selection.extentOffset;
    if (selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }
      controller.value = value.copyWith(
          text: newText,
          selection: selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      controller.value = TextEditingValue(
          text: text,
          selection:
              TextSelection.fromPosition(TextPosition(offset: text.length)));
    }
  }
}
