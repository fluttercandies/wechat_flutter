import 'package:wechat_flutter/im/model/chat_data.dart';
import 'package:wechat_flutter/pages/chat/chat_more_page.dart';
import 'package:wechat_flutter/pages/group/group_details_page.dart';
import 'package:wechat_flutter/ui/chat/chat_details_body.dart';
import 'package:wechat_flutter/ui/chat/chat_details_row.dart';
import 'package:wechat_flutter/ui/item/chat_more_icon.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/send_handle.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/edit/text_span_builder.dart';
import 'package:wechat_flutter/ui/edit/emoji_text.dart';
import 'chat_info_page.dart';

enum ButtonType { voice, more }

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
  StreamSubscription<dynamic> _msgStreamSubs;
  bool _isVoice = false;
  bool _isMore = false;
  double keyboardHeight = 270.0;
  bool _emojiState = false;
  String newGroupName;

  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = new FocusNode();
  ScrollController _sC = ScrollController();
  PageController pageC = new PageController();

  @override
  void initState() {
    super.initState();
    getChatMsgData();

    _sC.addListener(() => FocusScope.of(context).requestFocus(new FocusNode()));
    initPlatformState();
    Notice.addListener(WeChatActions.msg(), (v) => getChatMsgData());
    if (widget.type == 2) {
      Notice.addListener(WeChatActions.groupName(), (v) {
        setState(() => newGroupName = v);
      });
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _emojiState = false;
    });
  }

  Future getChatMsgData() async {
    final str =
        await ChatDataRep().repData(widget?.id ?? widget.title, widget.type);
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
    if (_msgStreamSubs != null) _msgStreamSubs.cancel();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    if (_msgStreamSubs == null) {
      _msgStreamSubs =
          im.onMessage.listen((dynamic onData) => getChatMsgData());
    }
  }

  _handleSubmittedData(String text) async {
    _textController.clear();
    chatData.insert(0, new ChatData(msg: {"text": text}));
    await sendTextMsg('${widget?.id ?? widget.title}', widget.type, text);
  }

  onTapHandle(ButtonType type) {
    setState(() {
      if (type == ButtonType.voice) {
        _focusNode.unfocus();
        _isMore = false;
        _isVoice = !_isVoice;
      } else {
        _isVoice = false;
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          _isMore = true;
        } else {
          _isMore = !_isMore;
        }
      }
      _emojiState = false;
    });
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
      specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
      onTap: () => setState(() {
        if (_focusNode.hasFocus) _emojiState = false;
      }),
      onChanged: (v) => setState(() {}),
      decoration: InputDecoration(
          border: InputBorder.none, contentPadding: const EdgeInsets.all(5.0)),
      controller: _textController,
      focusNode: _focusNode,
      maxLines: 99,
      cursorColor: const Color(AppColors.ChatBoxCursorColor),
      style: AppStyles.ChatBoxTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (keyboardHeight == 270.0 &&
        MediaQuery.of(context).viewInsets.bottom != 0) {
      keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    }
    var body = [
      chatData != null
          ? new ChatDetailsBody(sC: _sC, chatData: chatData)
          : new Spacer(),
      new ChatDetailsRow(
        voiceOnTap: () => onTapHandle(ButtonType.voice),
        onEmojio: () {
          if (_isMore) {
            _emojiState = true;
          } else {
            _emojiState = !_emojiState;
          }
          if (_emojiState) {
            FocusScope.of(context).requestFocus(new FocusNode());
            _isMore = false;
          }
          setState(() {});
        },
        isVoice: _isVoice,
        edit: edit,
        more: new ChatMoreIcon(
          value: _textController.text,
          onTap: () => _handleSubmittedData(_textController.text),
          moreTap: () => onTapHandle(ButtonType.more),
        ),
        id: widget.id,
        type: widget.type,
      ),
      new Visibility(
        visible: _emojiState,
        child: emojiWidget(),
      ),
      new Container(
        height: _isMore && !_focusNode.hasFocus ? keyboardHeight : 0.0,
        width: winWidth(context),
        color: Color(AppColors.ChatBoxBg),
        child: new IndicatorPageView(
          pageC: pageC,
          pages: List.generate(2, (index) {
            return new ChatMorePage(
              index: index,
              id: widget.id,
              type: widget.type,
              keyboardHeight: keyboardHeight,
            );
          }),
        ),
      ),
    ];

    var rWidget = [
      new InkWell(
        child: new Image.asset('assets/images/right_more.png'),
        onTap: () => routePush(widget.type == 2
            ? new GroupDetailsPage(
                widget?.id ?? widget.title,
                callBack: (v) {},
              )
            : new ChatInfoPage(widget.id)),
      )
    ];

    return Scaffold(
      appBar: new ComMomBar(
          title: newGroupName ?? widget.title, rightDMActions: rWidget),
      body: new MainInputBody(
        onTap: () => setState(
          () {
            _isMore = false;
            _emojiState = false;
          },
        ),
        decoration: BoxDecoration(color: chatBg),
        child: new Column(children: body),
      ),
    );
  }

  Widget emojiWidget() {
    return new GestureDetector(
      child: new SizedBox(
        height: _emojiState ? keyboardHeight : 0,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Image.asset(EmojiUitl.instance.emojiMap["[${index + 1}]"]),
              behavior: HitTestBehavior.translucent,
              onTap: () {
                insertText("[${index + 1}]");
              },
            );
          },
          itemCount: EmojiUitl.instance.emojiMap.length,
          padding: EdgeInsets.all(5.0),
        ),
      ),
      onTap: () {},
    );
  }

  @override
  void dispose() {
    super.dispose();
    canCelListener();
    Notice.removeListenerByEvent(WeChatActions.msg());
    Notice.removeListenerByEvent(WeChatActions.groupName());
    _sC.dispose();
  }
}
