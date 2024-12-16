import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/enum/conversation_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:wechat_flutter/im/conversation_handle.dart';
import 'package:wechat_flutter/im/model/chat_list.dart';
import 'package:wechat_flutter/pages/chat/chat_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/chat/my_conversation_view.dart';
import 'package:wechat_flutter/ui/edit/text_span_builder.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';
import 'package:wechat_flutter/ui/view/pop_view.dart';

import '../../tools/event/im_event.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<V2TimConversation?> _chatData = [];

  Offset? tapPos;
  TextSpanBuilder _builder = TextSpanBuilder();
  StreamSubscription<dynamic>? _msgStreamSubs;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getChatData();
  }

  Future<void> getChatData() async {
    final List<V2TimConversation?> listChat =
        await ChatListData().chatListData();
    if (!listNoEmpty(listChat)) {
      return;
    }
    _chatData.clear();
    _chatData.addAll(listChat.reversed.toList());
    if (mounted) {
      setState(() {});
    }
  }

  void _showMenu(BuildContext context, Offset tapPos, int type, String id) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(tapPos.dx, tapPos.dy,
        overlay.size.width - tapPos.dx, overlay.size.height - tapPos.dy);
    showMenu<String>(
        context: context,
        position: position,
        items: <MyPopupMenuItem<String>>[
          const MyPopupMenuItem(value: '标为已读', child: Text('标为已读')),
          const MyPopupMenuItem(value: '置顶聊天', child: Text('置顶聊天')),
          const MyPopupMenuItem(value: '删除该聊天', child: Text('删除该聊天')),
          // ignore: missing_return
        ]).then<void>((String? selected) async {
      switch (selected) {
        case '删除该聊天':
          deleteConversationAndLocalMsgModel(id, type);
          getChatData();
          break;
        case '标为已读':
          final num = await getUnreadMessageNumModel(type, id);
          if (num > 0) {
            setReadMessageModel(type, id);
            setState(() {});
          }
          break;
      }
    });
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

    _msgStreamSubs ??= eventBusNewMsg.listen((EventBusNewMsg onData) {
      getChatData();
    });
  }

  @override
  bool get wantKeepAlive => true;

  Widget timeView(int time) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    final String hourParse = "0${dateTime.hour}";
    final String minuteParse = "0${dateTime.minute}";

    final String hour = dateTime.hour.toString().length == 1
        ? hourParse
        : dateTime.hour.toString();
    final String minute = dateTime.minute.toString().length == 1
        ? minuteParse
        : dateTime.minute.toString();

    final String timeStr = '$hour:$minute';

    return SizedBox(
      width: 35.0,
      child: Text(
        timeStr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: mainTextColor, fontSize: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!listNoEmpty(_chatData)) {
      return HomeNullView();
    }
    return Container(
      color: const Color(AppColors.BackgroundColor),
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final V2TimConversation? model = _chatData[index];
            if (model == null) {
              return Container();
            }

            return InkWell(
              onTap: () {
                Get.to<void>(ChatPage(
                    id: model.userID ?? model.groupID!,
                    title: model.showName ?? model.conversationID,
                    type: model.type!));
              },
              onTapDown: (TapDownDetails details) {
                tapPos = details.globalPosition;
              },
              onLongPress: () {
                _showMenu(
                  context,
                  tapPos!,
                  model.type == ConversationType.V2TIM_GROUP ? 2 : 1,
                  model.conversationID,
                );
              },
              child: MyConversationView(
                imageUrl: model.faceUrl,
                title: model.showName ?? '',
                content: model.lastMessage,
                time: timeView(model.lastMessage?.timestamp ?? 0),
                isBorder: model.showName != _chatData[0]?.showName,
              ),
            );
          },
          itemCount: _chatData.length ?? 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    canCelListener();
  }
}
