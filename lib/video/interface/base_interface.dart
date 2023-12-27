import 'dart:typed_data';
import 'dart:ui';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/tx_audio_effect_manager.dart';
import 'package:tencent_trtc_cloud/tx_beauty_manager.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';
import 'package:wechat_flutter/video/event/live_stream_event.dart';

enum MediaType {
  single,
  multiple,
}

enum LiveErrorType {
  /// 频道异常
  channelError,
}

typedef LiveStateChange = Function(LiveSteamEvent eventName);
typedef LiveJoinFail = Function(LiveErrorType errorType);

abstract class LiveBaseInterface extends LiveSdkBaseInterface {
  String? userToken;

  late bool isJoined = false;

  int? channelId;

  // 是否发起方 默认false
  RxBool isSend = false.obs;

  int? myAgoraId;

  String logHead = "【live】";

  RxList<int> remoteUid = <int>[].obs;

  late int userAccount;

  Future startCheckJoin(VoidCallback onSetClosePage);

  Future joinOkHandle();

  Future getUserToken(VoidCallback onSetClosePage);

  Future channelAllUserInfo(VoidCallback onSetClosePage);

  Future channelActiveUserInfo();

  Future activeChannel();

  Future activeAll();

  Future getChannelBaseInfo();

  void handleNet(int uid, txQuality, rxQuality);

  void streamMessage(
    int uid,
    int streamId,
    Uint8List data,
    LiveStateChange? onLiveStateChange,
  );
}

abstract class LiveSdkBaseInterface {
  TRTCCloud? trtcCloud;
  TXDeviceManager? txDeviceManager;
  TXBeautyManager? txBeautyManager;
  TXAudioEffectManager? txAudioManager;

  Future initEngine({
    required VoidCallback onUserJoined,
    required VoidCallback onSetClosePage,
    VoidCallback? onSelfJoinChannel,
    LiveStateChange? onLiveStateChange,
  });

  Future destroyEngine();

  void addListeners(
    VoidCallback onUserJoined,
    VoidCallback? onSelfJoinChannel,
    LiveStateChange? onLiveStateChange,
    LiveJoinFail? onLiveJoinFail,
    // RxBool enableTl,
  );

  Future joinChannel(VoidCallback onSetClosePage);

  Future leaveChannel();
}
