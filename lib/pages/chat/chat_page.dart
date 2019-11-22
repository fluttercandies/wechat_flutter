import 'package:dim_example/im/model/chat_data.dart';
import 'package:dim_example/ui/item/chat_more_icon.dart';
import 'package:dim_example/ui/item/chat_voice.dart';
import 'package:dim_example/ui/view/indicator_page_view.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dim_example/im/send_handle.dart';
import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:dim_example/ui/edit/selection_controls.dart';
import 'package:dim_example/ui/edit/text_span_builder.dart';
import 'package:dim_example/ui/massage/wait1.dart';

import 'chat_info_page.dart';

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
  StreamSubscription<dynamic> _messageStreamSubscription;

  bool _isVoice = false;
  bool _isMore = false;

  TextEditingController _textController = TextEditingController();
  ScrollController _sC = ScrollController();
  SelectionControls _selectionControls = SelectionControls();
  PageController pageC = new PageController();

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
      _messageStreamSubscription =
          im.onMessage.listen((dynamic onData) => getChatMsgData());
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
//      textInputAction: TextInputAction.none,
      specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
      textSelectionControls: _selectionControls,
      onTap: () {
        setState(() {});
      },
      onChanged: (v) {
        setState(() {});
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
    var body = [
      chatData != null
          ? new Flexible(
              child: new ScrollConfiguration(
                behavior: MyBehavior(),
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
              ),
            )
          : new Spacer(),
      new Container(
        height: 50.0,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Color(AppColors.ChatBoxBg),
          border: Border(
            top: BorderSide(color: lineColor, width: Constants.DividerWidth),
          ),
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new InkWell(
              child: new Image.asset('assets/images/chat/ic_voice.webp',
                  width: 25, color: mainTextColor),
              onTap: () {
                setState(() => _isVoice = !_isVoice);
              },
            ),
            new Expanded(
              child: new Container(
                margin: const EdgeInsets.only(
                  top: 7.0,
                  bottom: 7.0,
                  left: 8.0,
                  right: 8.0,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: _isVoice
                    ? new ChatVoice()
                    : new LayoutBuilder(builder: edit),
              ),
            ),
            new InkWell(
              child: new Image.asset('assets/images/chat/ic_Emotion.webp',
                  width: 30, fit: BoxFit.cover),
              onTap: () {},
            ),
            new ChatMoreIcon(
              value: _textController.text,
              onTap: () => _handleSubmittedData(_textController.text),
              moreTap: () {
                setState(() => _isMore = !_isMore);
              },
            ),
          ],
        ),
      ),
      new Container(
        height: _isMore ? 260 : 0.0,
        width: winWidth(context),
        color: lineColor.withOpacity(0.5),
        child: new IndicatorPageView(
          pageC: pageC,
          pages: <Widget>[
            new Text('0'),
            new Text('1'),
            new Text('1'),
            new Text('1'),
          ],
        ),
      ),
    ];

    var rWidget = [
      new InkWell(
        child: new Image.asset('assets/images/right_more.png'),
        onTap: () => routePush(new ChatInfoPage(widget.id)),
      )
    ];

    return Scaffold(
      appBar: new ComMomBar(title: widget.title, rightDMActions: rWidget),
      body: new MainInputBody(
        decoration: BoxDecoration(color: chatBg),
        child: new Column(children: body),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    canCelListener();
    _sC.dispose();
  }
}
