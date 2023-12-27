import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/video/logic/live_time_logic.dart';
import 'package:wechat_flutter/video/model/channel_entity.dart';
import 'package:wechat_flutter/video/msg/chat_msg_mixin.dart';
import 'package:wechat_flutter/video/msg/chat_msg_param.dart';
import 'package:wechat_flutter/video/other/user/entity.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui_commom/view/hud_view.dart';

import 'live_util.dart';
import 'single_no_rsp.dart';

abstract class LiveCheckClose {
  /// 是否关闭了页面;
  bool isClosePage = false;

  /*
  * 设置关闭了页面，点击挂断调用
  * */
  void setClosePage() {
    isClosePage = true;
  }
}

abstract class LiveLogicAbs {
  @protected
  late LiveBaseInterface agoraIml;

  /// 监听关闭
  StreamSubscription? listenClose;

  RxList<UserInfoEntity?> infoList = <UserInfoEntity?>[].obs;

  Rx<ChannelEntity?> channelEntity = ChannelEntity.no().obs;

  Future enterLive(
    Map result,
    bool isClosed,
    bool isMultiple,
    VoidCallback onNoFloatEnter, {
    required VoidCallback onUserJoined,
    VoidCallback? onSelfJoinChannel,
    LiveStateChange? onLiveStateChange,
    required LivePageType livePageType,
  });
}

mixin LiveLogicImpl
    on
        SingleNoRspAbs,
        SingleNoRsp,
        LiveLogicAbs,
        LiveCheckClose,
        LiveTimeObs,
        LiveTimeLogic {
  /*
  * 获取基础信息
  * */
  Future initBaseInfo() async {
    LogUtil.d("channelEntity :: initBaseInfo");
    Map result = Get.arguments as Map;
    if (!result.containsKey("content")) {
      LogUtil.d("channelEntity :: initBaseInfo :: content为空");
      return;
    }
    channelEntity.value =
        ChannelEntity.fromJson(json.decode(result['content']));
    // String userAccountSp = await SpUtil().get(KeyConstant.agoraAccount);
    String userAccountSp = Q1Data.user();
    agoraIml.isSend.value = channelEntity.value?.sendAgoraUid == userAccountSp;

    LogUtil.d("channelEntity::${channelEntity.toJson()}");
    LogUtil.d("channelEntity::目标id::${channelEntity.value?.targetId}");
  }

  /*
  * 进入音视频直播页面处理
  * */
  @override
  Future enterLive(
    Map result,
    bool isClosed,
    bool isMultiple,
    VoidCallback onNoFloatEnter, {
    required VoidCallback onUserJoined,
    VoidCallback? onSelfJoinChannel,
    LiveStateChange? onLiveStateChange,
    LiveJoinFail? onLiveJoinFail,
    required LivePageType livePageType,
  }) async {
    final bool isFloatEnter = result.containsKey("isWindowPush") &&
        result["isWindowPush"] is bool &&
        result["isWindowPush"];

    LogUtil.d("是否小窗进入:$isFloatEnter");
    if (isFloatEnter) {
      agoraIml = floatWindow.paramValue!.agoraIml;
      if (floatWindow.paramValue?.trtcCloud != null) {
        agoraIml.trtcCloud = floatWindow.paramValue!.trtcCloud!;
      }
      if (floatWindow.paramValue?.infoList != null) {
        infoList = floatWindow.paramValue!.infoList!;
      }
      if (floatWindow.paramValue?.noRspTimeValue != null) {
        noRspTimeValue = floatWindow.paramValue!.noRspTimeValue!;
      }
      if (floatWindow.paramValue?.noRspIsOk != null) {
        noRspIsOk = floatWindow.paramValue!.noRspIsOk!;
      }
      if (floatWindow.paramValue?.singleRemoteUid?.value != null) {
        agoraIml.remoteUid.value =
            floatWindow.paramValue!.singleRemoteUid!.value;
      }
      if (floatWindow.paramValue?.myAgoraId != null) {
        agoraIml.myAgoraId = floatWindow.paramValue!.myAgoraId;
      }
      if (floatWindow.paramValue?.timeValue != null) {
        timeValue = floatWindow.paramValue!.timeValue!;
      }
      if (floatWindow.paramValue?.channelEntity != null) {
        channelEntity.value = floatWindow.paramValue!.channelEntity!.value;
        // String userAccountSp = await SpUtil().get(KeyConstant.agoraAccount);
        String userAccountSp = Q1Data.user();
        agoraIml.isSend.value =
            channelEntity.value?.sendAgoraUid == userAccountSp;

        print(
            "channelEntity.value?.sendAgoraUid::${channelEntity.value?.sendAgoraUid},userAccountSp::$userAccountSp.是否为发送方::${agoraIml.isSend}");
      }

      /// 监听
      agoraIml.addListeners(
          onUserJoined, onSelfJoinChannel, onLiveStateChange, onLiveJoinFail);

      /// 监听用户改变从而判断是否结束
      listenClose = agoraIml.remoteUid.stream
          .listen((v) => handleIdsChange(v, isClosed, isMultiple));

      /// 开始计时
      if (listNoEmpty(agoraIml.remoteUid.value)) {
        startTime();
      }

      /// 必须调用，否则不会开始倒计时
      noRspStartTime(() {
        ChatMsgParam chatMsgParam = ChatMsgParam(
          agoraIml.channelId ?? channelEntity.value!.channelId,
          livePageType,
          channelEntity.value!.targetId,
          isMultiple,
        );
        // 发送隐藏消息给对方【让其关闭等待接听的页面】
        ChatMsgUtil.sendCancelHideMsg(chatMsgParam);

        // 发送【对方无应答】可视消息
        ChatMsgUtil.sendNoRspShowMsg(chatMsgParam);
      });

      fetchChannelId();
    } else {
      onNoFloatEnter();
    }
  }

  /*
  * 从页面拿到频道ID
  * */

  Future fetchChannelId() async {
    Map result = Get.arguments as Map;
    if (result.containsKey("channelId") && strNoEmpty(result['channelId'])) {
      agoraIml.channelId = result['channelId'];
    }

    if (result.containsKey("isSend") && result['isSend'] != null) {
      agoraIml.isSend.value = result['isSend'] is RxBool
          ? (result['isSend'] as RxBool).value
          : result['isSend'];
    }
    debugPrint("从页面拿到频道ID:${agoraIml.channelId}");
  }

  /*
  * 监听remote_ids值改变
  *
  * isMultiple为true表示多人通话，自己的也算上，所以要减一之后再做处理
  * */
  void handleIdsChange(List<int> v, bool isClosed, bool isMultiple) {
    if (isClosed) {
      return;
    }
    debugPrint('listen ids of remote value change as ${v.toString()}');

    if (!listNoEmpty(v)) {
      closeChannel();
    }
  }

  /*
  * 关闭频道
  * */
  void closeChannel() {
    /// 不显示小窗
    setClosePage();

    /// 关闭音视频且提示消息【对方挂断】【通话结束】
    LiveUtil.closeAndTip("通话结束");
  }
}

mixin LiveHudShow on LiveCheckClose {
  void initLiveHudShow(BuildContext context, Rx<ChannelEntity?> channelEntity,
      LiveBaseInterface agoraIml) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        if (agoraIml.isJoined) {
          HudView.dismiss();
        }
      });

      HudView.show(context, msg: "加载中", onTimeOut: () {
        if (!agoraIml.isJoined) {
          isClosePage = true;
          ChatMsgParam chatMsgParam = ChatMsgParam(
            agoraIml.channelId ?? channelEntity.value!.channelId,
            LivePageType.singleVideo,
            channelEntity.value!.targetId,

            /// 如果群组id不为空则为群组
            strNoEmpty(channelEntity.value?.groupId),
          );

          ChatMsgUtil.sendCancelHideMsg(chatMsgParam);
          LiveUtil.closeAndTip("加载超时");
        }
      });
    });
  }
}
