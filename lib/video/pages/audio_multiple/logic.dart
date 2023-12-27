import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/video/event/live_stream_event.dart';
import 'package:wechat_flutter/video/event_bus/live_stream_msg_bus.dart';
import 'package:wechat_flutter/video/impl/agora_audio_iml.dart';
import 'package:wechat_flutter/video/impl/live_logic_impl.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/video/impl/single_no_rsp.dart';
import 'package:wechat_flutter/video/logic/live_time_logic.dart';
import 'package:wechat_flutter/video/msg/chat_msg_mixin.dart';
import 'package:wechat_flutter/video/msg/chat_msg_param.dart';
import 'package:wechat_flutter/video/other/user/entity.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/impl/live_event_bus_impl.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/video/pages/video_sigle/logic.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class AudioMultipleLogic extends GetxController
    with
        LiveLogicAbs,
        LiveCheckClose,
        SingleNoRspAbs,
        SingleNoRsp,
        LiveTimeObs,
        LiveTimeLogic,
        LiveLogicImpl,
        LiveEventBus,
        LiveEventBusImpl,
        LiveHudShow {

  @override
  final AgoraAudioIml agoraIml = AgoraAudioIml(MediaType.multiple);

  RxList<UserInfoEntity?> infoList = <UserInfoEntity?>[].obs;

  StreamSubscription? liveStreamMsgBusBus;

  /// 顶部显示按钮
  final List<VideoBtModel> topBts = [
    VideoBtModel("", VideoBtType.minimize),
  ];

  /// 底部显示按钮
  RxList<VideoBtModel> bottomBts = [
    VideoBtModel("麦克风", VideoBtType.microphone),
    VideoBtModel("挂断", VideoBtType.cancel),
    VideoBtModel("扬声器", VideoBtType.speakers),
  ].obs;

  @override
  void onReady() {
    super.onReady();
    initLiveEventBus(() => setClosePage());
    Map result = Get.arguments as Map;
    enterLive(
      result,
      isClosed,
      true,
      () {
        /// 非悬浮窗悬浮进入
        noRspStartTime(() {
          ChatMsgParam chatMsgParam = ChatMsgParam(
            agoraIml.channelId ?? channelEntity.value!.channelId,
            LivePageType.multipleAudio,
            channelEntity.value!.targetId,
            true,
          );
          // 发送隐藏消息给对方【让其关闭等待接听的页面】
          ChatMsgUtil.sendCancelHideMsg(chatMsgParam);

          // 发送【对方无应答】可视消息
          ChatMsgUtil.sendNoRspShowMsg(chatMsgParam);
        });
        fetchChannelId();
        agoraIml
            .initEngine(
          onUserJoined: onUserJoined,
          onSelfJoinChannel: onSelfJoinChannel,
          onLiveStateChange: onLiveStateChange,
          onLiveJoinFail: onLiveJoinFail,
          onSetClosePage: () {
            setClosePage();
          },
        )
            .then((value) {
          listenClose = agoraIml.remoteUid.stream
              .listen((v) => handleIdsChange(v, isClosed, true));

          getUserListInfo();
        });
        initBaseInfo().then((value) {
        });
      },
      onUserJoined: onUserJoined,
      onSelfJoinChannel: onSelfJoinChannel,
      onLiveStateChange: onLiveStateChange,
      onLiveJoinFail: onLiveJoinFail,
      livePageType: LivePageType.multipleAudio,
    );

    bottomBts.value = [
      VideoBtModel("麦克风", VideoBtType.microphone, agoraIml.openMicrophone),
      VideoBtModel("挂断", VideoBtType.cancel),
      VideoBtModel("扬声器", VideoBtType.speakers, agoraIml.enableSpeakerphone),
    ];

    /// 监听直播数据流消息
    liveStreamMsgBusBus = liveStreamMsgBus.on<LiveStreamMsgModel>().listen(
        (v) => LiveUtil.handleLiveMsg(
            v, channelEntity, agoraIml, onLiveStateChange));
  }

  /*
  * 自己加入频道
  * */
  void onSelfJoinChannel() {
    getUserListInfo();

    Map result = Get.arguments as Map;
    if (result.containsKey("call")) {
      result["call"](agoraIml.channelId);
      LogUtil.d("回调发送消息agoraIml.channelId：：${agoraIml.channelId}");
    }
  }

  /*
  * 异常处理
  * */
  void onLiveJoinFail(LiveErrorType errorType) {
    if (errorType == LiveErrorType.channelError) {
      setClosePage();
      LiveUtil.closeAndTip('加入频道失败');
    }
  }

  void onLiveStateChange(LiveSteamEvent eventName) {
    LiveEventName eventNameResultValue = LiveEventName.openMicrophone;
    for (LiveEventName newItem in LiveEventName.values) {
      if (newItem.name == eventName.eventName) {
        eventNameResultValue = newItem;
      }
    }
    setUserLiveState(eventNameResultValue, eventName.uid);
  }

  /*
  * 用户加入
  * */

  void onUserJoined() {
    LogUtil.d("用户加入房间了");
    startTime();
    getUserListInfo();
    noRspReceive();
  }

  /*
  * 设置用户直播状态
  * */
  Future setUserLiveState(LiveEventName eventName, int uid) async {
    if (!listNoEmpty(infoList)) {
      return;
    }
    for (UserInfoEntity? p0 in infoList) {
      if (p0?.uid == uid) {
        switch (eventName) {
          case LiveEventName.openCamera:
            p0?.isOpenCamera.value = true;
            break;
          case LiveEventName.closeCamera:
            p0?.isOpenCamera.value = false;
            break;
          case LiveEventName.openMicrophone:
            p0?.isOpenMicrophone.value = true;
            break;
          case LiveEventName.closeMicrophone:
            p0?.isOpenMicrophone.value = false;
            break;
          default:
            break;
        }
      }
    }
  }

  /*
  * 获取用户信息
  * */
  Future getUserListInfo() async {
    infoList.value = (await agoraIml.channelAllUserInfo(() => setClosePage()));
  }

  /*
  * 按钮点击
  * */
  void btActions(VideoBtType e) {
    debugPrint("Click button is ${e.name}");
    switch (e) {
      case VideoBtType.cancel:
        ChatMsgParam chatMsgParam = ChatMsgParam(
          agoraIml.channelId ?? channelEntity.value!.channelId,
          LivePageType.multipleAudio,
          channelEntity.value!.targetId,
          true,
        );

        ChatMsgUtil.sendCancelHideMsg(chatMsgParam);
        setClosePage();
        Get.back();
        break;
      case VideoBtType.microphone:
        agoraIml.switchMicrophone(channelEntity.value!.targetId);
        break;
      case VideoBtType.speakers:
        agoraIml.switchSpeakerphone();
        break;
      case VideoBtType.minimize:
        Get.back();
        break;
      case VideoBtType.camera:
        break;
      // case VideoBtType.translate:
      //   setTlOfCov(!enableTl.value);
      //   break;
      default:
        break;
    }
  }

  /*
  * 内部销毁事件监听
  * */
  void innerCancelBus() {
    liveStreamMsgBusBus?.cancel();
    liveStreamMsgBusBus = null;
  }

  @override
  void onClose() {
    super.onClose();

    // 关闭事件总线
    closeLiveEventBus();

    innerCancelBus();

    cancelTime();

    /// 必须调用因为此实例已销毁
    noRspCancelTime();

    LogUtil.d('是否真实关闭页面::$isClosePage');
    if (isClosePage) {
      agoraIml.destroyEngine();
    }
  }

  @override
  String get covId => channelEntity.value?.toChatId ?? "0";
}
