import 'package:dim_example/im/model/chat_data.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dim_example/im/send_handle.dart';
import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:dim_example/ui/edit/selection_controls.dart';
import 'package:dim_example/ui/edit/text_span_builder.dart';
import 'package:dim_example/ui/massage/wait1.dart';

class ChatPage extends StatefulWidget {
  final String title;
  final int type;
  final String id;

  ChatPage({this.id, this.title, this.type = 1});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatData> chatData = [];

  ///------------------

  TextEditingController _textController = TextEditingController();
  ScrollController _sC = ScrollController();
  SelectionControls _selectionControls = SelectionControls();

  StreamSubscription<dynamic> _messageStreamSubscription;

  @override
  void initState() {
    super.initState();
    getChatMsgData();

    _sC.addListener(() => FocusScope.of(context).requestFocus(new FocusNode()));

    initPlatformState();
  }

  Future getChatMsgData() async {
    final str = await ChatDataRep().repData(widget.id, widget.type);
    List<ChatData> listChat = str;
    chatData.clear();
    chatData..addAll(listChat.reversed);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    canCelListener();
    _sC.dispose();
  }

  void insertText(String text) {
    var value = _textController.value;
    var start = value.selection.baseOffset;
    var end = value.selection.extentOffset;
    if (value.selection.isValid) {
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

      _textController.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      _textController.value = TextEditingValue(
          text: text,
          selection:
              TextSelection.fromPosition(TextPosition(offset: text.length)));
    }
  }

  void canCelListener() {
    if (_messageStreamSubscription != null) {
      _messageStreamSubscription.cancel();
    }
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    if (_messageStreamSubscription == null) {
      _messageStreamSubscription = im.onMessage.listen((dynamic onData) {
        getChatMsgData();
        debugPrint(
            "我监听到数据了$onData,需要在这里判断是你是消息列表还是需要刷新会话的请求。会话的请求是一个空的列表[],消息列表是有内容的");
      });
    }
  }

  _handleSubmittedData(String text) async {
    _textController.clear();
    chatData.insert(0, new ChatData(msg: {"text": text}));
    await sendTextMsg('${widget.id}', widget.type, text);
  }

  Widget edit(context, size) {
    // 计算当前的文本需要占用的行数
    TextSpan _text =
        TextSpan(text: _textController.text, style: AppStyles.ChatBoxTextStyle);

    TextPainter _tp = TextPainter(
        text: _text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left);
    _tp.layout(maxWidth: size.maxWidth);

    return ExtendedTextField(
      textInputAction: TextInputAction.send,
      specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
      textSelectionControls: _selectionControls,
      onTap: () {
        setState(() {});
      },
      onSubmitted: (data) {
        if (data.isNotEmpty) {
          FocusScope.of(context).requestFocus(new FocusNode());
          _handleSubmittedData(data);
        }
      },
      decoration: InputDecoration(
          border: InputBorder.none, contentPadding: const EdgeInsets.all(5.0)),
      controller: _textController,
      cursorColor: const Color(AppColors.ChatBoxCursorColor),
      style: AppStyles.ChatBoxTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
//    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    var _voiceBtnColor = Colors.white;
    var body = [
      chatData != null
          ? new Flexible(
              child: new ListView.builder(
                controller: _sC,
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (context, int index) {
                  ChatData model = chatData[index];
                  return new SendMessageView(model);
                },
                itemCount: chatData.length,
                dragStartBehavior: DragStartBehavior.down,
              ),
            )
          : new Spacer(),
      new Container(
        height: 50.0,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Color(AppColors.ChatBoxBg),
          border: Border(
            top: BorderSide(
                color: const Color(AppColors.DividerColor),
                width: Constants.DividerWidth),
          ),
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: _voiceBtnColor,
                    borderRadius: BorderRadius.circular(5.0)),
                child: new LayoutBuilder(builder: edit),
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: new ComMomBar(title: widget.title),
      body: new MainInputBody(
        decoration: BoxDecoration(color: chatBg),
        child: new Column(children: body),
      ),
    );
  }
}
