import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/edit/text_span_builder.dart';
import 'package:wechat_flutter/ui/w_pop/magic_pop.dart';

class TextItemContainer extends StatefulWidget {
  final String text;
  final String action;
  final bool isMyself;

  TextItemContainer({this.text, this.action, this.isMyself = true});

  @override
  _TextItemContainerState createState() => _TextItemContainerState();
}

class _TextItemContainerState extends State<TextItemContainer> {
  TextSpanBuilder _spanBuilder = TextSpanBuilder();

  @override
  Widget build(BuildContext context) {
    return new MagicPop(
      onValueChanged: (int value) {
        switch (value) {
          case 0:
            Clipboard.setData(new ClipboardData(text: widget.text));
            break;
          case 3:
            break;
        }
      },
      pressType: PressType.longPress,
      actions: ['复制', '转发', '收藏', '撤回', '删除'],
      child: new Container(
        width: widget.text.length > 24 ? (winWidth(context) - 66) - 100 : null,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: widget.isMyself ? Color(0xff98E165) : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        margin: EdgeInsets.only(right: 7.0),
        child: ExtendedText(
          widget.text ?? '文字为空',
          maxLines: 99,
          overflow: TextOverflow.ellipsis,
          specialTextSpanBuilder: _spanBuilder,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
