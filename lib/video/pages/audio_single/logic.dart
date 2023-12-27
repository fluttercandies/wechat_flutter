import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/video/event_bus/live_stream_msg_bus.dart';
import 'package:wechat_flutter/video/impl/agora_audio_iml.dart';
import 'package:wechat_flutter/video/impl/agora_video_iml.dart';
import 'package:wechat_flutter/video/impl/live_logic_impl.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/video/impl/single_no_rsp.dart';
import 'package:wechat_flutter/video/logic/live_time_logic.dart';
import 'package:wechat_flutter/video/msg/chat_msg_mixin.dart';
import 'package:wechat_flutter/video/msg/chat_msg_param.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/impl/live_event_bus_impl.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/video/pages/video_sigle/logic.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class AudioSingleLogic extends GetxController
    with
        LiveCheckClose,
        LiveLogicAbs,
        SingleNoRspAbs,
        SingleNoRsp,
        LiveTimeObs,
        LiveTimeLogic,
        LiveLogicImpl,
        LiveEventBus,
        LiveEventBusImpl,
        LiveHudShow {
  final bool isChangeToVoice;
  final SingleNoRsp? singleNoRspValue;
  final int newTimeValue;
  final AgoraVideoIml? agoraImlVideo;
  final int? audToVideoChannelId;
  final int? audToVideoMyAgoraId;

  AudioSingleLogic(
    this.singleNoRspValue,
    this.isChangeToVoice,
    this.newTimeValue,
    this.agoraImlVideo,
    this.audToVideoChannelId,
    this.audToVideoMyAgoraId,
  );

  @override
  final AgoraAudioIml agoraIml = AgoraAudioIml(MediaType.single);

  StreamSubscription? liveStreamMsgBusBus;

  /// 顶部显示按钮
  final List<VideoBtModel> topBts = [
    VideoBtModel("", VideoBtType.minimize),
  ];

  /// 底部显示按钮
  RxList<VideoBtModel> bottomBts = [
    VideoBtModel("麦克风", VideoBtType.microphone),
    VideoBtModel("取消", VideoBtType.cancel),
    VideoBtModel("扬声器", VideoBtType.speakers),
  ].obs;

  ChatMsgParam get chatMsgParam {
    return ChatMsgParam(
      agoraIml.channelId ?? channelEntity.value!.channelId,
      LivePageType.singleAudio,
      channelEntity.value!.targetId,
      false,
    );
  }

  @override
  void onReady() {
    super.onReady();
    initLiveEventBus(() => setClosePage(), onReject: () {
      // 发送【被拒绝】可视消息【仅发送方发送】
      ChatMsgUtil.sendRejectShowMsg(chatMsgParam);
    }, onBusy: () {
      // 发送【正忙】可视消息【仅发送方发送】
      ChatMsgUtil.sendBusyShowMsg(chatMsgParam);
    }, onSenderCancel: () {
      /// onSenderCancel需要判断当前是否通话中，如果是通话中则通话结束，且发送正常的可显示消息，
      /// 否则处理对方已取消
      if (listNoEmpty(agoraIml.remoteUid)) {
        senNormalMsgHandle(chatMsgParam);
      } else {
        LiveUtil.closeAndTip("对方已取消");
      }
    });

    Map result = Get.arguments as Map;

    enterLive(
      result,
      isClosed,
      false,
      () {
        /// 非悬浮窗进入
        noRspStartTime(() {
          // 发送隐藏消息给对方【让其关闭等待接听的页面】
          ChatMsgUtil.sendCancelHideMsg(chatMsgParam);

          // 发送【对方无应答】可视消息
          ChatMsgUtil.sendNoRspShowMsg(chatMsgParam);
        });
        fetchChannelId();

        if (!isChangeToVoice) {
          agoraIml
              .initEngine(
            onUserJoined: onUserJoined,
            onLiveJoinFail: onLiveJoinFail,
            onSelfJoinChannel: onSelfJoinChannel,
            onSetClosePage: () {
              setClosePage();
            },
          )
              .then((value) {
            listenClose = agoraIml.remoteUid.stream
                .listen((v) => handleIdsChange(v, isClosed, false));
          });
        } else {
          noRspChangeToVoice(singleNoRspValue);
          agoraIml.trtcCloud = agoraImlVideo!.trtcCloud;
          agoraIml.remoteUid.value = agoraImlVideo!.remoteUid.value;
          timeValue = newTimeValue;
          agoraIml.isJoined = agoraImlVideo!.isJoined;
          agoraIml.channelId = audToVideoChannelId;
          agoraIml.myAgoraId = audToVideoMyAgoraId;
          if (listNoEmpty(agoraIml.remoteUid.value)) {
            startTime();
          }
        }
        initBaseInfo();
      },
      onUserJoined: onUserJoined,
      onLiveJoinFail: onLiveJoinFail,
      livePageType: LivePageType.singleAudio,
    );
    bottomBts.value = [
      VideoBtModel("麦克风", VideoBtType.microphone, agoraIml.openMicrophone),
      VideoBtModel("取消", VideoBtType.cancel),
      VideoBtModel("扬声器", VideoBtType.speakers, agoraIml.enableSpeakerphone),
    ];

    LogUtil.d("单人音视频触发 [监听直播数据流消息]");

    /// 监听直播数据流消息
    liveStreamMsgBusBus = liveStreamMsgBus.on<LiveStreamMsgModel>().listen(
        (v) => LiveUtil.handleLiveMsg(v, channelEntity, agoraIml, null));
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

  /*
  * 自己加入频道
  * */
  void onSelfJoinChannel() {
    Map result = Get.arguments as Map;
    if (result.containsKey("call")) {
      result["call"](agoraIml.channelId);
      LogUtil.d("回调发送消息agoraIml.channelId：：${agoraIml.channelId}");
    }
  }

  /*
  * 用户加入
  * */

  void onUserJoined() {
    LogUtil.d("用户加入房间了");
    startTime();

    /// 音频不需要获取用户信息列表
    // getUserListInfo();
    noRspReceive();
  }

  /// 发送正常通话结束的消息
  void senNormalMsgHandle(ChatMsgParam chatMsgParam) {
    // 远程的用户id不为空，表示已连接通话，这个时候结束就是通话结束

    // 发送【正常】可视消息【仅发送方发送】
    ChatMsgUtil.sendNormalShowMsg(
      chatMsgParam,
      longTime: timeValueStr.value,
    );
  }

  /*
  * 按钮点击
  * */
  void btActions(VideoBtType e) {
    debugPrint("Click button is ${e.name}");
    switch (e) {
      case VideoBtType.cancel:
        ChatMsgUtil.sendCancelHideMsg(chatMsgParam);

        if (agoraIml.isSend.value) {
          if (listNoEmpty(agoraIml.remoteUid)) {
            senNormalMsgHandle(chatMsgParam);
          } else {
            // 发送【已取消】可视消息【仅发送方发送】
            ChatMsgUtil.sendCancelShowMsg(chatMsgParam);
          }
        }
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
      case VideoBtType.flip:
        debugPrint("转换");
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
