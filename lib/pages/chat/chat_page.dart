import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:wechat_flutter/im/model/chat_data.dart';
import 'package:wechat_flutter/im/send_handle.dart';
import 'package:wechat_flutter/pages/chat/chat_more_page.dart';
import 'package:wechat_flutter/pages/group/group_details_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/chat/chat_details_body.dart';
import 'package:wechat_flutter/ui/chat/chat_details_row.dart';
import 'package:wechat_flutter/ui/edit/emoji_text.dart';
import 'package:wechat_flutter/ui/edit/text_span_builder.dart';
import 'package:wechat_flutter/ui/item/chat_more_icon.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';

import '../../tools/event/im_event.dart';
import 'chat_info_page.dart';

enum ButtonType { voice, more }

class ChatPage extends StatefulWidget {
  final String title;
  final int type;
  final String id;

  ChatPage({required this.id, required this.title, required this.type});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<V2TimMessage> chatData = [];
  StreamSubscription<dynamic>? _msgStreamSubs;
  bool _isVoice = false;
  bool _isMore = false;
  double keyboardHeight = 270.0;
  bool _emojiState = false;
  String newGroupName = '';

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _sC = ScrollController();
  PageController pageC = PageController();

  @override
  void initState() {
    super.initState();
    getChatMsgData();

    _sC.addListener(() => FocusScope.of(context).requestFocus(FocusNode()));
    initPlatformState();
    Notice.addListener(WeChatActions.msg(), (v) => getChatMsgData());
    if (widget.type == 2) {
      Notice.addListener(WeChatActions.groupName(), (v) {
        setState(() => newGroupName = v as String);
      });
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _emojiState = false;
      }
    });
  }

  Future<void> getChatMsgData() async {
    final List<V2TimMessage> listChat =
        await ChatDataRep().repData(widget.id, widget.type);
    chatData.clear();
    chatData.addAll(listChat.reversed);
    if (mounted) {
      setState(() {});
    }
  }

  void insertText(String text) {
    final value = _textController.value;
    final start = value.selection.baseOffset;
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
    if (_msgStreamSubs != null) {
      _msgStreamSubs!.cancel();
    }
  }

  Future<void> initPlatformState() async {
    if (!mounted) {
      return;
    }

    _msgStreamSubs ??= eventBusNewMsg.listen((onData) {
      if (onData.covId == widget.id) {
        getChatMsgData();
      }
    });
  }

  Future<void> _handleSubmittedData(String text) async {
    _textController.clear();
    await sendTextMsg(widget.id, widget.type, text, call: (msg) {
      chatData.insert(0, msg);
    });
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

  Widget edit(context, BoxConstraints size) {
    // 计算当前的文本需要占用的行数
    final TextSpan text =
        TextSpan(text: _textController.text, style: AppStyles.ChatBoxTextStyle);

    final TextPainter tp = TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left);
    tp.layout(maxWidth: size.maxWidth);

    return ExtendedTextField(
      specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
      onTap: () => setState(() {
        if (_focusNode.hasFocus) {
          _emojiState = false;
        }
      }),
      onChanged: (v) => setState(() {}),
      decoration: const InputDecoration(
          border: InputBorder.none, contentPadding: EdgeInsets.all(5.0)),
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
    final body = [
      if (chatData != null)
        ChatDetailsBody(sC: _sC, chatData: chatData)
      else
        const Spacer(),
      ChatDetailsRow(
        voiceOnTap: () => onTapHandle(ButtonType.voice),
        onEmojio: () {
          if (_isMore) {
            _emojiState = true;
          } else {
            _emojiState = !_emojiState;
          }
          if (_emojiState) {
            FocusScope.of(context).requestFocus(FocusNode());
            _isMore = false;
          }
          setState(() {});
        },
        isVoice: _isVoice,
        edit: edit,
        more: ChatMoreIcon(
          value: _textController.text,
          onTap: () => _handleSubmittedData(_textController.text),
          moreTap: () => onTapHandle(ButtonType.more),
        ),
        id: widget.id,
        type: widget.type,
      ),
      Visibility(
        visible: _emojiState,
        child: emojiWidget(),
      ),
      Container(
        height: _isMore && !_focusNode.hasFocus ? keyboardHeight : 0.0,
        width: Get.width,
        color: const Color(AppColors.ChatBoxBg),
        child: IndicatorPageView(
          pageC: pageC,
          pages: List.generate(2, (index) {
            return ChatMorePage(
              index: index,
              id: widget.id,
              type: widget.type,
              keyboardHeight: keyboardHeight,
            );
          }),
        ),
      ),
    ];

    final rWidget = [
      InkWell(
        child: Image.asset('assets/images/right_more.png'),
        onTap: () => Get.to(widget.type == 2
            ? GroupDetailsPage(
                widget?.id ?? widget.title,
                callBack: (v) {},
              )
            : ChatInfoPage(widget.id)),
      )
    ];

    return Scaffold(
      appBar: ComMomBar(
          title: newGroupName ?? widget.title, rightDMActions: rWidget),
      body: MainInputBody(
        onTap: () => setState(
          () {
            _isMore = false;
            _emojiState = false;
          },
        ),
        decoration: const BoxDecoration(color: chatBg),
        child: Column(children: body),
      ),
    );
  }

  Widget emojiWidget() {
    return GestureDetector(
      child: SizedBox(
        height: _emojiState ? keyboardHeight : 0,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              child:
                  Image.asset(EmojiUitl.instance.emojiMap['[${index + 1}]']!),
              behavior: HitTestBehavior.translucent,
              onTap: () {
                insertText('[${index + 1}]');
              },
            );
          },
          itemCount: EmojiUitl.instance.emojiMap.length,
          padding: const EdgeInsets.all(5.0),
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
