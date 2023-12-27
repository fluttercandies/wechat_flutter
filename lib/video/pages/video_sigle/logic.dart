import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wechat_flutter/video/event/live_stream_event.dart';
import 'package:wechat_flutter/video/event_bus/live_stream_msg_bus.dart';
import 'package:wechat_flutter/video/impl/agora_video_iml.dart';
import 'package:wechat_flutter/video/impl/live_logic_impl.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/video/impl/single_no_rsp.dart';
import 'package:wechat_flutter/video/logic/live_time_logic.dart';
import 'package:wechat_flutter/video/msg/chat_msg_mixin.dart';
import 'package:wechat_flutter/video/msg/chat_msg_param.dart';
import 'package:wechat_flutter/video/other/user/entity.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/impl/live_event_bus_impl.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

enum VideoBtType {
  /// 麦克风
  microphone,

  /// 扬声器
  speakers,

  /// 摄像头
  camera,

  /// 取消
  cancel,

  /// 接受【音频】
  acceptAudio,

  /// 接受【视频】
  acceptVideo,

  /// 转到语音通话
  changeToVoice,

  /// 最小化
  minimize,

  /// 翻转
  flip,

  // 间隔
  spacer,
}

class VideoBtModel {
  final String text;
  final VideoBtType type;
  final RxBool? value;

  RxString get icon {
    if (type == VideoBtType.cancel) {
      return "assets/images/live/live_cancel.png".obs;
    } else if (type == VideoBtType.acceptAudio) {
      return "assets/images/live/live_accept.png".obs;
    } else if (type == VideoBtType.acceptVideo) {
      return "assets/images/live/live_video_accept.png".obs;
    } else if (type == VideoBtType.minimize) {
      return "assets/images/live/live_scale.png".obs;
    } else if (type == VideoBtType.flip) {
      return "assets/images/live/live_switch.png".obs;
    } else if (type == VideoBtType.changeToVoice) {
      return "assets/images/live/live_change_to_voice.png".obs;
    }
    if (type == VideoBtType.camera) {
      return value == null
          ? "assets/images/live/live_camera_open.png".obs
          : ("assets/images/live/live_camera_${value!.value ? "open" : "close"}.png"
              .obs);
    } else if (type == VideoBtType.speakers) {
      return value == null
          ? "assets/images/live/live_speakers_open.png".obs
          : ("assets/images/live/live_speakers_${value!.value ? "open" : "close"}.png"
              .obs);
    } else if (type == VideoBtType.microphone) {
      return value == null
          ? "assets/images/live/live_microphone_open.png".obs
          : ("assets/images/live/live_microphone_${value!.value ? "open" : "close"}.png"
              .obs);
    }
    return "".obs;
  }

  VideoBtModel(this.text, this.type, [this.value]);
}

class VideoSingleLogic extends GetxController
    with
        LiveCheckClose,
        MiniWindowAbs,
        MiniWindow,
        SingleNoRspAbs,
        SingleNoRsp,
        LiveLogicAbs,
        LiveTimeObs,
        LiveTimeLogic,
        LiveLogicImpl,
        LiveEventBus,
        LiveEventBusImpl,
        LiveHudShow {
  @override
  final AgoraVideoIml agoraIml = AgoraVideoIml(MediaType.single);

  /// 对方是否打开了摄像头
  RxBool otherSizeIsOpenCamera = true.obs;

  StreamSubscription? isChangeToVoiceSubs;
  StreamSubscription? liveStreamMsgBusBus;

  /*
  * 获取对方的头像
  * */
  String get getOtherAvatar {
    String avatarValue = "";
    try {
      for (UserInfoEntity? entity in infoList) {
        if (entity?.uid != agoraIml.myAgoraId) {
          avatarValue = entity?.localuser.avatar ?? '';
        }
      }
    } catch (e) {
      LogUtil.d("获取对方头像出错");
      return "";
    }
    return avatarValue;
  }

  /*
  * 获取自己的头像
  * */
  String get getSelfAvatar {
    String avatarValue = "";
    try {
      for (UserInfoEntity? entity in infoList) {
        if (entity?.uid == agoraIml.myAgoraId) {
          avatarValue = entity?.localuser.avatar ?? '';
        }
      }
    } catch (e) {
      LogUtil.d("获取自己头像出错");
      return "";
    }
    return avatarValue;
  }

  /// 顶部显示按钮
  final List<VideoBtModel> topBts = [
    VideoBtModel("", VideoBtType.minimize),
    VideoBtModel("", VideoBtType.spacer),
    VideoBtModel("", VideoBtType.flip),
  ];

  /// 底部显示按钮
  RxList<VideoBtModel> bottomBts = [
    VideoBtModel("摄像头", VideoBtType.camera),
    VideoBtModel("取消", VideoBtType.cancel),
    VideoBtModel("切换到语音通话", VideoBtType.changeToVoice),
  ].obs;

  ChatMsgParam get chatMsgParam {
    return ChatMsgParam(
      agoraIml.channelId ?? channelEntity.value!.channelId,
      LivePageType.singleVideo,
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
        noRspStartTime(() {
          // 发送隐藏消息给对方【让其关闭等待接听的页面】
          ChatMsgUtil.sendCancelHideMsg(chatMsgParam);

          // 发送【对方无应答】可视消息
          ChatMsgUtil.sendNoRspShowMsg(chatMsgParam);
        });
        fetchChannelId();
        /// 初始化引擎
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
              .listen((v) => handleIdsChange(v, isClosed, false));
        });

        initBaseInfo();
      },
      onUserJoined: onUserJoined,
      onSelfJoinChannel: onSelfJoinChannel,
      onLiveStateChange: onLiveStateChange,
      onLiveJoinFail: onLiveJoinFail,
      livePageType: LivePageType.singleVideo,
    );
    bottomBts.value = [
      VideoBtModel("摄像头", VideoBtType.camera, agoraIml.isEnableVideo),
      VideoBtModel("取消", VideoBtType.cancel),
      VideoBtModel("切换到语音通话", VideoBtType.changeToVoice),
    ];

    /// 监听直播数据流消息
    liveStreamMsgBusBus = liveStreamMsgBus.on<LiveStreamMsgModel>().listen(
        (v) => LiveUtil.handleLiveMsg(
            v, channelEntity, agoraIml, onLiveStateChange));

    /// 监听视频转音频
    isChangeToVoiceSubs = agoraIml.isChangeToVoice.listen((p0) {
      if (p0) {
        agoraIml.toVoicePage(this);
      }
    });
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
    getUserListInfo();

    Map result = Get.arguments as Map;
    if (result.containsKey("call")) {
      result["call"](agoraIml.channelId);
      LogUtil.d("回调发送消息agoraIml.channelId：：${agoraIml.channelId}");
    }
  }

  /*
  * 状态变更
  * */
  void onLiveStateChange(LiveSteamEvent eventName) {
    LogUtil.d(
        "收到音视频状态变更：：${eventName.toString()}，是否关闭摄像头：${eventName.eventName == LiveEventName.closeCamera.name}");
    if (eventName.eventName == LiveEventName.closeCamera.name) {
      otherSizeIsOpenCamera.value = false;
    } else if (eventName.eventName == LiveEventName.openCamera.name) {
      otherSizeIsOpenCamera.value = true;
    }
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
  * 获取用户信息
  * */
  Future getUserListInfo() async {
    infoList.value = (await agoraIml.channelAllUserInfo(() => setClosePage()));
  }

  /*
  * 视频转音频通话
  * */
  Future changeToVoiceHandle() async {
    noRspCancelTime();
    await agoraIml.changeToVoice(targetId: channelEntity.value!.targetId);
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
      case VideoBtType.minimize:
        Get.back();
        break;
      case VideoBtType.camera:
        agoraIml.enableAndDisableCamera(
            targetId: channelEntity.value!.targetId);
        break;
      case VideoBtType.flip:
        agoraIml.switchCameraHandle();
        break;
      case VideoBtType.changeToVoice:
        changeToVoiceHandle();
        break;
      default:
        break;
    }
  }

  /*
  * 内部销毁事件监听
  * */
  void innerCancelBus() {
    /// 视频转音频监听器销毁
    isChangeToVoiceSubs?.cancel();
    isChangeToVoiceSubs = null;
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

    listenClose?.cancel();
    listenClose = null;

    /// 必须调用因为此实例已销毁
    noRspCancelTime();

    LogUtil.d('是否真实关闭页面::$isClosePage');
    if (isClosePage) {
      agoraIml.destroyEngine();
    }
  }

  @override
  String get covId => channelEntity.value?.toChatId ?? '0';
}

abstract class MiniWindowAbs {
  // 小窗宽度
  final double miniWindowWidth = 107.w;

  // 小窗高度
  final double miniWindowHeight = 115.h;

  // 小窗顶部距离
  RxDouble top = 0.0.obs;

  // 小窗左边距离
  RxDouble left = 0.0.obs;

  /*
  * 设置悬浮窗参数
  * */
  void setMiniWindow(BuildContext context);

  /*
  * 移动中
  * */
  void onPanUpdate(DragUpdateDetails details);

  /*
  * 移动结束
  * */
  void onPanEnd(DragEndDetails details);
}

mixin MiniWindow on MiniWindowAbs {
  @override
  void setMiniWindow(BuildContext context) {
    if (top.value > 0) {
      return;
    }
    double defRightPadding = 14;
    top.value = MediaQuery.of(context).padding.top + 60 + 10;
    left.value = ScreenUtil.screenWidthDp - miniWindowWidth - defRightPadding;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    left.value = details.globalPosition.dx - miniWindowWidth / 2;
    top.value = details.globalPosition.dy - miniWindowHeight / 2;

    if (left <= 0) {
      left.value = 0;
    } else if (left >= ScreenUtil.screenWidthDp) {
      left.value = ScreenUtil.screenWidthDp;
    }

    final double topPadding = ScreenUtil.mediaQuery.padding.top;

    if (top.value <= topPadding) {
      top.value = topPadding;
    } else if (top.value >=
        ScreenUtil.screenHeightDp - topPadding - miniWindowWidth * 1) {
      top.value = ScreenUtil.screenHeightDp - topPadding - miniWindowWidth * 1;
    }
  }

  @override
  void onPanEnd(DragEndDetails details) {
    if (left + miniWindowWidth / 2 < ScreenUtil.screenWidthDp / 2) {
      left.value = 0;
    } else {
      left.value = ScreenUtil.screenWidthDp - miniWindowWidth;
    }
  }
}
