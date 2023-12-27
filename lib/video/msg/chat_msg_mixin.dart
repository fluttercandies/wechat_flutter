import 'dart:convert';

import 'package:wechat_flutter/video/msg/chat_msg_param.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/msg/live_msg_event.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';


class ChatMsgUtil {
  /*
  * 发送隐藏消息
  * */
  static Future sendHideMsg(
    int channelIdValue,
    LiveMsgEventSingleHide msgType,
    LivePageType livePageType,
    String targetId,
    bool isGroup, {
    String? msgContent,
  }) async {
    if (!strNoEmpty(targetId)) {
      q1Toast( '发送消息出错');
      return;
    }
    if (!numNoEmpty(channelIdValue)) {
      q1Toast( '发送出错');
      return;
    }
    // EMUserInfo? selfInfo =
    //     await EMClient.getInstance.userInfoManager.fetchOwnInfo();
    //
    // String userAccountSp = await SpUtil().get(KeyConstant.agoraAccount);
    // LogUtil.d("msgType.toString()::${msgType.toString()}");
    // LiveSingleHideMsgModel msgModel = LiveSingleHideMsgModel(
    //   msgType: msgType.toString(),
    //   livePageType: livePageType.toString(),
    //   sendChatId: selfInfo?.userId ?? "",
    //   sendChatName: selfInfo?.nickName ?? '',
    //   sendAvatarUrl: selfInfo?.avatarUrl ?? '',
    //   sendAgoraUid: userAccountSp,
    //   channelId: channelNameValue,
    //   msgContent: msgContent,
    //   groupId: isGroup ? targetId : "",
    // );
    //
    // EMMessage msg = EMMessage.createCustomSendMessage(
    //   targetId: targetId,
    //   event: msgModel.msgType,
    //   params: {"content": json.encode(msgModel)},
    // );
    //
    // msg.setMessageStatusCallBack(MessageStatusCallBack(
    //   onSuccess: () {
    //     LogUtil.d("发送隐藏消息 成功targetId:$targetId，是否发群:$isGroup，内容为:${msg.body}");
    //   },
    //   onError: (e) {
    //     debugPrint('发送隐藏消息 失败targetId:$targetId $e');
    //     LogUtil.d("发送隐藏消息 失败targetId:$targetId，内容为:${msg.body}");
    //   },
    // ));
    //
    // if (isGroup) {
    //   msg.chatType = ChatType.GroupChat; //设置消息类型为群聊，不设置默认为单聊
    // }
    //
    // /// 隐藏消息不需要插入数据库
    // // MsgDao.insert(msgEntity);
    //
    // EMClient.getInstance.chatManager.sendMessage(msg);
  }

  /*
  * 发送可视消息
  * */
  static Future sendShowMsg(
    int channelIdValue,
    LiveMsgEventSingleShow msgType,
    LivePageType livePageType,
    String targetId,
    bool isGroup, {
    String? longTime,
  }) async {
    if (!strNoEmpty(targetId)) {
      q1Toast( '发送消息出错');
      return;
    }
    // EMUserInfo? selfInfo =
    //     await EMClient.getInstance.userInfoManager.fetchOwnInfo();
    //
    // String userAccountSp = await SpUtil().get(KeyConstant.agoraAccount);
    // LogUtil.d("msgType.toString()::${msgType.toString()}");
    // LiveSingleShowMsgModel msgModel = LiveSingleShowMsgModel(
    //   msgType: msgType.toString(),
    //   livePageType: livePageType.toString(),
    //   sendChatId: selfInfo?.userId ?? "",
    //   sendChatName: selfInfo?.nickName ?? '',
    //   sendAvatarUrl: selfInfo?.avatarUrl ?? '',
    //   sendAgoraUid: userAccountSp,
    //   channelId: channelNameValue,
    //   longTime: longTime,
    // );
    //
    // LogUtil.d("发送的正常消息内容：${json.encode(msgModel)}");
    // EMMessage msg = EMMessage.createCustomSendMessage(
    //   targetId: targetId,
    //   event: msgModel.msgType,
    //   params: {"content": json.encode(msgModel)},
    // );
    //
    // msg.setMessageStatusCallBack(MessageStatusCallBack(
    //   onSuccess: () {
    //     LogUtil.d("发送可视消息 成功targetId:$targetId，内容为:${msg.body}");
    //   },
    //   onError: (e) {
    //     debugPrint('发送可视消息 失败targetId:$targetId $e');
    //     LogUtil.d("发送可视消息 失败targetId:$targetId，内容为:${msg.body}");
    //   },
    // ));
    //
    // if (isGroup) {
    //   msg.chatType = ChatType.GroupChat; //设置消息类型为群聊，不设置默认为单聊
    // }
    //
    // MsgEntity msgMap = MsgEntity.no();
    // msgMap.isMine = 1;
    // msgMap.content = msg;
    //
    // if (livePageType == LivePageType.singleAudio) {
    //   msgMap.type = 3;
    // } else {
    //   msgMap.type = 4;
    // }
    // // msgMap.specialMsg = json.encode({"msgType": msgType.toString()});
    //
    // /// 对方无应答 消息存储数据库
    // MsgDao.insert(msgMap);
    //
    // EMClient.getInstance.chatManager.sendMessage(msg);
    //
    // /// 发送给聊天界面
    // liveStateToChatBus.fire(LiveMsgBusModel(
    //   targetId: targetId,
    //   msgMap: msgMap,
    // ));
  }

  /*
  * 发送取消通话【隐藏消息】
  * */
  static Future sendCancelHideMsg(ChatMsgParam param) async {
    sendHideMsg(param.channelIdValue, LiveMsgEventSingleHide.senderCancel,
        param.livePageType, param.targetId, param.isGroup);
  }

  /*
  * 发送【对方无应答】可视消息
  * */
  static Future sendNoRspShowMsg(ChatMsgParam param) async {
    LogUtil.d("发送【对方无应答】可视消息");
    sendShowMsg(param.channelIdValue, LiveMsgEventSingleShow.noRsp,
        param.livePageType, param.targetId, param.isGroup);
  }

  /*
  * 发送【已取消】可视消息
  * */
  static Future sendCancelShowMsg(ChatMsgParam param) async {
    LogUtil.d("发送【已取消】可视消息【仅发送方发送】");
    sendShowMsg(param.channelIdValue, LiveMsgEventSingleShow.canceled,
        param.livePageType, param.targetId, param.isGroup);
  }

  /*
  * 发送【被拒绝】可视消息
  * */
  static Future sendRejectShowMsg(ChatMsgParam param) async {
    LogUtil.d("发送【被拒绝】可视消息【仅发送方发送】");
    sendShowMsg(param.channelIdValue, LiveMsgEventSingleShow.rejected,
        param.livePageType, param.targetId, param.isGroup);
  }

  /*
  * 发送【正忙】可视消息
  * */
  static Future sendBusyShowMsg(ChatMsgParam param) async {
    LogUtil.d("发送【正忙】可视消息【仅发送方发送】");
    sendShowMsg(param.channelIdValue, LiveMsgEventSingleShow.busy,
        param.livePageType, param.targetId, param.isGroup);
  }

  /*
  * 发送【正常】可视消息
  * */
  static Future sendNormalShowMsg(ChatMsgParam param,
      {required String longTime}) async {
    LogUtil.d("发送【被拒绝】可视消息【仅发送方发送】");
    sendShowMsg(
      param.channelIdValue,
      LiveMsgEventSingleShow.normal,
      param.livePageType,
      param.targetId,
      param.isGroup,
      longTime: longTime,
    );
  }
}
