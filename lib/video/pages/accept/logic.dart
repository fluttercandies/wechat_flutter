import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/video/impl/live_event_bus_impl.dart';
import 'package:wechat_flutter/video/msg/live_msg.dart';
import 'package:wechat_flutter/video/msg/live_msg_event.dart';
import 'package:wechat_flutter/video/pages/video_sigle/logic.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class AcceptLogic extends GetxController with LiveEventBus, LiveEventBusImpl {
  String acceptEvent = "";

  /// 顶部显示按钮
  final List<VideoBtModel> topBts = [
    VideoBtModel("", VideoBtType.minimize),
    VideoBtModel("", VideoBtType.flip),
  ];

  /// 底部显示按钮
  RxList<VideoBtModel> bottomBts = [
    VideoBtModel("取消", VideoBtType.cancel),
    VideoBtModel("接受", VideoBtType.acceptAudio),
  ].obs;

  Rx<LiveSingleHideMsgModel?> myMsgModel = LiveSingleHideMsgModel.no().obs;

  @override
  void onReady() {
    super.onReady();
    initParam();
    initLiveEventBus(() {});
  }

  void initParam() {
    Map result = Get.arguments as Map;

    if (result.containsKey("accept_event")) {
      acceptEvent = result["accept_event"];
    }
    if (!result.containsKey("accept_content")) {
      return;
    }

    final String acceptContent = result['accept_content'];

    if (acceptEvent == LiveMsgEventSingleHide.senderSend.toString()) {
      LogUtil.d("接电话时拿到的内容数据模型::$acceptContent");
      myMsgModel.value =
          LiveSingleHideMsgModel.fromJson(json.decode(acceptContent));
    }

    // 刷新底部两个图标
    bottomBts.value = [
      VideoBtModel("取消", VideoBtType.cancel),
      VideoBtModel(
          "接受",
          myMsgModel.value!.livePageType.toString().contains("Video")
              ? VideoBtType.acceptVideo
              : VideoBtType.acceptAudio),
    ];
  }

  /*
  * 按钮事件
  * */
  void btActions(VideoBtType e) {
    debugPrint("Click button is ${e.name}");
    switch (e) {
      case VideoBtType.minimize:
        rejectHandle();
        break;
      case VideoBtType.cancel:
        rejectHandle();
        break;
      case VideoBtType.acceptAudio:
        acceptHandle();
        break;
      case VideoBtType.acceptVideo:
        acceptHandle();
        break;
      default:
        break;
    }
  }

  /*
  * 拒绝处理
  * */
  Future rejectHandle() async {
    try {
      // EMUserInfo? selfInfo = await EMClient.getInstance.userInfoManager
      //     .fetchOwnInfo(expireTime: 3);
      //
      // String userAccountSp = await SpUtil().get(KeyConstant.agoraAccount);
      // LiveSingleHideMsgModel msgModel = LiveSingleHideMsgModel(
      //   msgType: LiveMsgEventSingleHide.receiverReject.toString(),
      //   sendChatId: selfInfo?.userId ?? "",
      //   sendChatName: selfInfo?.nickName ?? '',
      //   sendAvatarUrl: selfInfo?.avatarUrl ?? '',
      //   sendAgoraUid: userAccountSp,
      //   channelId: myMsgModel.value!.channelId,
      //   livePageType: myMsgModel.value!.livePageType,
      //   groupId: myMsgModel.value?.groupId ?? "",
      // );
      //
      // EMMessage msg = EMMessage.createCustomSendMessage(
      //   targetId: myMsgModel.value!.sendChatId,
      //   event: msgModel.msgType,
      //   params: {"content": json.encode(msgModel)},
      // );
      //
      // /// 隐藏消息暂不做监听是否成功
      // EMClient.getInstance.chatManager.sendMessage(msg);
      // LogUtil.d("【单人】【语音】发送隐藏消息 成功，内容为:${json.encode(msgModel)}");
      Get.back();
    } catch (e) {
      LogUtil.d("拒绝出现错误:${e.toString()}");
      Get.back();
    }
  }

  /*
  * 接受通话
  * */
  Future acceptHandle() async {
    // EMUserInfo? selfInfo =
    //     await EMClient.getInstance.userInfoManager.fetchOwnInfo(expireTime: 3);
    //
    // // 接电话时拿到的内容数据模型::
    // // {"msgType":"LiveMsgEventSingleHide.senderSend","livePageType":"LivePageType.singleAudio",
    // // "channelId":"FAFB4EFB97D57105DB690CD6B76FE04E","sendChatId":"chimera-13244766725",
    // // "sendChatName":"q1two","sendAvatarUrl":"","sendAgoraUid":"3","msgContent":null}
    // ChannelEntity channelEntity = ChannelEntity(
    //   sendChatId: myMsgModel.value?.sendChatId ?? "",
    //   sendChatName: myMsgModel.value?.sendChatName ?? '',
    //   mediaType: myMsgModel.value!.livePageType,
    //   sendAvatarUrl: myMsgModel.value?.sendAvatarUrl ?? '',
    //   sendAgoraUid: myMsgModel.value?.sendAgoraUid ?? '',
    //   channelName: myMsgModel.value?.channelId ?? "",
    //   toAvatar: selfInfo?.avatarUrl ?? "",
    //   toChatId: selfInfo?.userId ?? "",
    //   toChatName: selfInfo?.nickName ?? "",
    //   groupId: myMsgModel.value?.groupId,
    // );
    //
    // String resultChannelId = myMsgModel.value?.channelId ?? "";
    // Map arguments = {
    //   "channelId": resultChannelId,
    //   "isSend": false,
    //   "content": json.encode(channelEntity),
    // };
    // if (myMsgModel.value?.livePageType == LivePageType.singleAudio.toString()) {
    //   Get.offNamed(RouteConfig.audioSinglePage, arguments: arguments);
    // } else if (myMsgModel.value?.livePageType ==
    //     LivePageType.multipleAudio.toString()) {
    //   Get.offNamed(RouteConfig.audioMultiplePage, arguments: arguments);
    // } else if (myMsgModel.value?.livePageType ==
    //     LivePageType.singleVideo.toString()) {
    //   if (LiveUtilData.videoToVoiceList.contains(resultChannelId)) {
    //     /// 说明已经视频转音频了，直接进入音频
    //     Get.offNamed(RouteConfig.audioSinglePage, arguments: arguments);
    //   } else {
    //     Get.offNamed(RouteConfig.videoSinglePage, arguments: arguments);
    //   }
    // } else if (myMsgModel.value?.livePageType ==
    //     LivePageType.multipleVideo.toString()) {
    //   Get.offNamed(RouteConfig.videoMultiplePage, arguments: arguments);
    // }
    //
    // final bool isGroup = myMsgModel.value?.livePageType ==
    //         LivePageType.multipleVideo.toString() ||
    //     myMsgModel.value?.livePageType == LivePageType.multipleAudio.toString();
    //
    // String myLivePageType = myMsgModel.value!.livePageType;
    // LivePageType? livePageType;
    // for (LivePageType item in LivePageType.values) {
    //   if (myLivePageType == item.toString()) {
    //     livePageType = item;
    //   }
    // }
    //
    // ChatMsgUtil.sendHideMsg(
    //   myMsgModel.value!.channelId,
    //   LiveMsgEventSingleHide.receiverReceive,
    //   livePageType!,
    //   myMsgModel.value!.sendChatId,
    //   isGroup,
    // );
  }

  @override
  void onClose() {
    super.onClose();
    closeLiveEventBus();
  }
}
