import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:wechat_flutter/im/im_handle/im_conversation_api.dart';
import 'package:wechat_flutter/im/im_handle/im_friend_api.dart';
import 'package:wechat_flutter/im/im_handle/im_msg_api.dart';
import 'package:wechat_flutter/pages/chat/chat_page.dart';
import 'package:wechat_flutter/tools/app_config.dart';
import 'package:wechat_flutter/tools/eventbus/msg_bus.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/chat/my_conversation_view.dart';
import 'package:wechat_flutter/ui/edit/text_span_builder.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';
import 'package:wechat_flutter/ui/view/pop_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<V2TimConversation> _chatData = [];

  var tapPos;
  TextSpanBuilder _builder = TextSpanBuilder();
  StreamSubscription<dynamic> _messageStreamSubscription;

  /// 下一页请求标识码
  String nextSeq = "0";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getChatData(notDataCall: () {
      /// 如果当前没有消息，且没有添加自己和微信团队
      /// 自动添加自己和微信团队且发送一条消息
      addMsg();
    });
  }

/*
* 获取会话列表数据
* */
  Future getChatData({VoidCallback notDataCall}) async {
    final V2TimConversationResult cvsResult =
        await IMConversationApi.getConversationList(nextSeq);
    nextSeq = cvsResult.nextSeq;
    if (!listNoEmpty(cvsResult.conversationList)) {
      if (notDataCall != null) notDataCall();
      return;
    }

    _chatData = cvsResult.conversationList;
    setState(() {});
  }

  /// 如果当前没有消息则添加"微信团队"然后发送一条消息
  Future addMsg() async {
    List<V2TimFriendInfo> friends = await ImFriendApi.getFriendList();
    bool isHaveMySelf = false;
    bool isHaveWxTeam = false;
    // 获取失败了
    if (!listNoEmpty(friends)) {
      return;
    }
    for (V2TimFriendInfo element in friends) {
      if (element.userID == Data.user()) {
        isHaveMySelf = true;
      } else if (element.userID == AppConfig.wxTeamUserId) {
        isHaveWxTeam = true;
      }
    }
    if (!isHaveMySelf) {
      ImFriendApi.addFriend(Data.user());
      ImMsgApi.sendTextMessage("我们已经是好友了，现在开始聊天吧", receiver: Data.user());
    }
    if (!isHaveWxTeam) {
      ImFriendApi.addFriend(AppConfig.wxTeamUserId);
      ImMsgApi.sendTextMessage("我们已经是好友了，现在开始聊天吧",
          receiver: AppConfig.wxTeamUserId);
    }
    getChatData();
  }

  _showMenu(BuildContext context, Offset tapPos, int type, String id) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromLTRB(tapPos.dx, tapPos.dy,
        overlay.size.width - tapPos.dx, overlay.size.height - tapPos.dy);
    showMenu<String>(
        context: context,
        position: position,
        items: <MyPopupMenuItem<String>>[
          new MyPopupMenuItem(child: Text('标为已读'), value: '标为已读'),
          new MyPopupMenuItem(child: Text('置顶聊天'), value: '置顶聊天'),
          new MyPopupMenuItem(child: Text('删除该聊天'), value: '删除该聊天'),
          // ignore: missing_return
        ]).then<String>((String selected) {
      switch (selected) {
        case '删除该聊天':
          getChatData();
          break;
        case '标为已读':
          break;
      }
    });
  }

  void canCelListener() {
    if (_messageStreamSubscription != null) {
      _messageStreamSubscription.cancel();
    }
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    if (_messageStreamSubscription == null) {
      _messageStreamSubscription = msgBus.on<MsgBusModel>().listen((event) {
        print("收到新消息，发送给${event.toUserId}");

        /// 表示从第一个消息开始读取
        nextSeq = '0';

        getChatData();
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  Widget timeView(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    String hourParse = "0${dateTime.hour}";
    String minuteParse = "0${dateTime.minute}";

    String hour = dateTime.hour.toString().length == 1
        ? hourParse
        : dateTime.hour.toString();
    String minute = dateTime.minute.toString().length == 1
        ? minuteParse
        : dateTime.minute.toString();

    String timeStr = '$hour:$minute';

    return new SizedBox(
      width: 35.0,
      child: new Text(
        timeStr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: mainTextColor, fontSize: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!listNoEmpty(_chatData)) return new HomeNullView();
    return new Container(
      color: Color(AppColors.BackgroundColor),
      child: new ScrollConfiguration(
        behavior: MyBehavior(),
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            V2TimConversation model = _chatData[index];

            return InkWell(
              onTap: () {
                Get.to(new ChatPage(
                    id: model.userID, title: model.showName, type: model.type));
              },
              onTapDown: (TapDownDetails details) {
                tapPos = details.globalPosition;
              },
              onLongPress: () {
                if (Platform.isAndroid) {
                  _showMenu(context, tapPos, model.type, model.userID);
                } else {
                  debugPrint("IOS聊天长按选项功能开发中");
                }
              },
              child: new MyConversationView(
                imageUrl: model.faceUrl,
                title: model?.showName ?? '',
                content: model?.lastMessage,
                time: timeView(model?.lastMessage?.timestamp ?? 0),
                isBorder: model?.showName != _chatData[0].userID,
              ),
            );
          },
          itemCount: _chatData?.length ?? 1,
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
