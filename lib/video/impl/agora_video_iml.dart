import 'dart:convert';
import 'dart:typed_data';

import 'package:oktoast/oktoast.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/tx_audio_effect_manager.dart';
import 'package:tencent_trtc_cloud/tx_beauty_manager.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';
import 'package:wechat_flutter/video/event/live_stream_event.dart';
import 'package:wechat_flutter/video/event_bus/recognition_bus.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/video/pages/audio_single/view.dart';
import 'package:wechat_flutter/video/pages/video_sigle/logic.dart';
import 'package:wechat_flutter/im/login_handle.dart';
import 'package:wechat_flutter/tools/config/call_config.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/video/interface/live_video_interface.dart';

abstract class CallVideoToAudioPage {
  Future toVoicePage(VideoSingleLogic logic);
}

class AgoraVideoIml extends LiveVideoInterFace with CallVideoToAudioPage {
  final MediaType mediaType;

  AgoraVideoIml(this.mediaType);

  @override
  TRTCCloud? trtcCloud;
  @override
  TXDeviceManager? txDeviceManager;
  @override
  TXBeautyManager? txBeautyManager;
  @override
  TXAudioEffectManager? txAudioManager;

  @override
  bool isJoined = false;
  @override
  RxBool switchCamera = true.obs;
  @override
  RxBool isEnableVideo = true.obs;

  final RxBool isChangeToVoice = false.obs;

  // final  _api = CustomCaptureAudioApi();

  int localViewId = 0;

  @override
  void addListeners(
    VoidCallback onUserJoined,
    VoidCallback? onSelfJoinChannel,
    LiveStateChange? onLiveStateChange,
    LiveJoinFail? onLiveJoinFail,
  ) {
    LogUtil.d("$logHead 添加监听");
    // engine?.setEventHandler(RtcEngineEventHandler(
    //   warning: (warningCode) {
    //     LogUtil.d('$logHead:warning $warningCode');
    //
    //     if (warningCode == WarningCode.OpenChannelTimeout ||
    //         warningCode == WarningCode.OpenChannelRejected) {
    //       if (onLiveJoinFail != null) {
    //         onLiveJoinFail(LiveErrorType.channelError);
    //       }
    //     }
    //   },
    //   error: (errorCode) {
    //     LogUtil.d(
    //         '$logHead error $errorCode。errorCode.name::${errorCode.name}');
    //   },
    //   joinChannelSuccess: (channel, uid, elapsed) async {
    //     LogUtil.d('$logHead:joinChannelSuccess $channel $uid $elapsed');
    //     myAgoraId = uid;
    //     if (onSelfJoinChannel != null) onSelfJoinChannel();
    //     joinOkHandle();
    //
    //     /// 开始音频采集
    //     await _api.startAudioRecord(
    //         defaultSampleRate, defaultChannelCount, enableTl, openMicrophone);
    //
    //     /// 开始识别
    //     startRecognition(enableTl);
    //
    //     HudView.dismiss();
    //   },
    //   userJoined: (uid, elapsed) {
    //     LogUtil.d('$logHead:userJoined  $uid $elapsed');
    //     remoteUid.add(uid);
    //     onUserJoined();
    //   },
    //   networkQuality: handleNet,
    //   userOffline: (uid, reason) {
    //     LogUtil.d('$logHead:userOffline  $uid $reason');
    //
    //     remoteUid.removeWhere((element) => element == uid);
    //   },
    //   leaveChannel: (stats) {
    //     LogUtil.d('$logHead:leaveChannel ${stats.toJson()}');
    //
    //     isJoined = false;
    //     remoteUid.clear();
    //   },
    //   contentInspectResult: (ContentInspectResult result) {
    //     ///
    //     if (result == ContentInspectResult.ContentInspectSexy) {
    //       Get.defaultDialog(content: const Text('内容过于性感'));
    //     } else if (result == ContentInspectResult.ContentInspectPorn) {
    //       Get.defaultDialog(content: const Text('检测到违规内容，请注意规范'));
    //     }
    //   },
    //   streamMessage: (uid, streamId, data) =>
    //       streamMessage(uid, streamId, data, onLiveStateChange),
    // ));
  }

  @override
  void streamMessage(int uid, int streamId, Uint8List data,
      LiveStateChange? onLiveStateChange) {
    final realMsg = utf8.decode(data);
    LogUtil.d("收到附加消息::$realMsg");
    final LiveSteamEvent steamEvent =
        LiveSteamEvent.fromJson(json.decode(realMsg));
    if (steamEvent.eventName == LiveEventName.ttsContent.name) {
      recognitionBus.fire(RecognitionBusBusModel('${steamEvent.uid}',
          steamEvent.content ?? "未知", steamEvent.msgId ?? '0'));
    } else if (steamEvent.eventName == LiveEventName.changeToVoice.name) {
      isChangeToVoice.value = true;
    } else {
      if (onLiveStateChange != null) onLiveStateChange(steamEvent);
    }
  }

  @override
  Future changeToVoice({required String targetId}) async {
    if (trtcCloud == null) {
      LogUtil.d("引擎为空了");
    }
    // engine?.disableVideo();
    // engine?.enableAudio();

    sendLiveMsg(LiveEventName.changeToVoice, mediaType, false,
        targetId: targetId);

    isChangeToVoice.value = true;
  }

  @override
  Future initEngine({
    required VoidCallback onUserJoined,
    required VoidCallback onSetClosePage,
    VoidCallback? onSelfJoinChannel,
    LiveStateChange? onLiveStateChange,
    LiveJoinFail? onLiveJoinFail,
  }) async {
    setTestUserId();

    trtcCloud = (await TRTCCloud.sharedInstance())!;
    txDeviceManager = trtcCloud?.getDeviceManager();
    txBeautyManager = trtcCloud?.getBeautyManager();
    txAudioManager = trtcCloud?.getAudioEffectManager();

    addListeners(
      onUserJoined,
      onSelfJoinChannel,
      onLiveStateChange,
      onLiveJoinFail,
    );

    // engine?.registerListener(onRtcListener);

    if (!strNoEmpty(Q1Data.userSig)) {
      dismissAllToast();
      loginOut(null, tip: "检测用户异常");
      return;
    }

    await trtcCloud?.enterRoom(
        TRTCParams(
            sdkAppId: AppConfig.sdkAppId,
            userId: Q1Data.user(),
            userSig: Q1Data.userSig!,
            role: TRTCCloudDef.TRTCRoleAnchor,
            roomId: channelId ?? AppConfig.mockCallRoomId),
        TRTCCloudDef.TRTC_APP_SCENE_LIVE);

    trtcCloud?.startLocalAudio(CallConfig.audioQuality);
    // await engine?.enableVideo();

    /// 音频专属【使用自定义采集，不需要使用这个方法了】
    // await engine?.enableAudio();

    // await engine?.startPreview();

    /// 一定要直播模式，否则服务端收不到加入频道和退出频道通知
    // await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // await engine?.setClientRole(ClientRole.Broadcaster);

    await getUserToken(onSetClosePage);

    await joinChannel(onSetClosePage);
  }

  @override
  Future joinChannel(VoidCallback onSetClosePage) async {
    // if (channelId == null) {
    //   onSetClosePage();
    //   LiveUtil.closeAndTip("加入频道失败");
    // }
    //
    // LogUtil.d(
    //     '声网加入频道::userToken:$userToken，channelId:$channelId，userAccount:$userAccount');
    //
    // await engine?.setDefaultAudioRouteToSpeakerphone(true);
    //
    // // Sets the external audio source.
    // // PS: Ensure that you call this method before the joinChannel method
    // await _api.setExternalAudioSource(
    //     true, defaultSampleRate, defaultChannelCount);
    //
    // // Set audio route to speaker
    // await engine?.setDefaultAudioRouteToSpeakerphone(true);
    //
    // final option = ChannelMediaOptions();
    // option.autoSubscribeAudio = true;
    //
    // /// 在视频情况下[autoSubscribeVideo]需要为true
    // option.autoSubscribeVideo = true;
    //
    // await engine
    //     ?.joinChannelWithUserAccount(
    //         userToken, channelId!, userAccount.toString(), option)
    //     .catchError((onError) {
    //   LogUtil.d('$logHead error ${onError.toString()}');
    // });
    startCheckJoin(onSetClosePage);
  }

  @override
  Future leaveChannel() async {
    // await engine?.leaveChannel();

    /// 音频专属
    isJoined = false;
    openMicrophone.value = true;
    enableSpeakerphone.value = true;
    playEffect.value = false;
    enableInEarMonitoring = false;
    recordingVolume = 100;
    playbackVolume = 100;
    inEarMonitoringVolume = 100;
  }

  @override
  void switchCameraHandle() {
    LogUtil.d(
        "引擎是否正常::engine::${trtcCloud == null},是否切换为前置::${!switchCamera.value}");
    txDeviceManager?.switchCamera(!switchCamera.value).then((value) {
      switchCamera.value = !switchCamera.value;
    }).catchError((err) {
      LogUtil.d('$logHead:switchCamera $err');
    });
  }

  @override
  Future enableAndDisableCamera({required String targetId}) async {
    /// 对方未接听不允许开关摄像头，否则出现错误
    // if (!listNoEmpty(remoteUid)) {
    //   q1Toast( "等待对方接听");
    //   return;
    // }
    // if (isEnableVideo.value) {
    //   await engine?.stopPreview();
    //   await engine?.enableLocalVideo(false);
    //   isEnableVideo.value = false;
    // } else {
    //   await engine?.startPreview();
    //   await engine?.enableLocalVideo(true);
    //   isEnableVideo.value = true;
    // }

    final LiveEventName msEvent = isEnableVideo.value
        ? LiveEventName.openCamera
        : LiveEventName.closeCamera;

    sendLiveMsg(msEvent, mediaType, false, targetId: targetId);
  }

  /// 下面全是音频专属
  @override
  void onChangeInEarMonitoringVolume(double value) async {
    inEarMonitoringVolume = value;
    // await engine?.setInEarMonitoringVolume(inEarMonitoringVolume.toInt());
  }

  @override
  void switchEffect() async {
    // if (playEffect.value) {
    //   engine?.stopEffect(1).then((value) {
    //     playEffect.value = false;
    //   }).catchError((err) {
    //     LogUtil.d('$logHead stopEffect $err');
    //   });
    // } else {
    //   final path =
    //       (await engine?.getAssetAbsolutePath("assets/Sound_Horizon.mp3"))!;
    //   engine
    //       ?.playEffect(1, path, 0, 1, 1, 100, openMicrophone.value)
    //       .then((value) {
    //     playEffect.value = true;
    //   }).catchError((err) {
    //     LogUtil.d('$logHead playEffect $err');
    //   });
    // }
  }

  @override
  void switchMicrophone({required String targetId}) async {
    // await engine?.muteLocalAudioStream(!openMicrophone);
    // await engine?.enableLocalAudio(!openMicrophone.value).then((value) {
    //   openMicrophone.value = !openMicrophone.value;
    // }).catchError((err) {
    //   LogUtil.d('$logHead enableLocalAudio $err');
    // });

    final LiveEventName msEvent = openMicrophone.value
        ? LiveEventName.openMicrophone
        : LiveEventName.closeMicrophone;

    sendLiveMsg(msEvent, mediaType, true, targetId: targetId);
  }

  @override
  void switchSpeakerphone() {
    // engine?.setEnableSpeakerphone(!enableSpeakerphone.value).then((value) {
    //   enableSpeakerphone.value = !enableSpeakerphone.value;
    // }).catchError((err) {
    //   LogUtil.d('$logHead setEnableSpeakerphone $err');
    // });
  }

  @override
  void toggleInEarMonitoring(value) async {
    enableInEarMonitoring = value;
    // await engine?.enableInEarMonitoring(enableInEarMonitoring);
  }

  @override
  Future toVoicePage(VideoSingleLogic logic) async {
    Get.off(
      AudioSinglePage(
        isChangeToVoice: true,
        timeValue: logic.timeValue,
        agoraImlVideo: logic.agoraIml,
        singleNoRspValue: logic,
        channelId: logic.agoraIml.channelId!,
        audToVideoMyAgoraId: logic.agoraIml.myAgoraId!,
      ),
      routeName: RouteConfig.audioSinglePage,
      arguments: Get.arguments,
    );
  }

  @override
  Future destroyEngine() async {
    channelId = null;
    remoteUid.clear();

    await trtcCloud?.exitRoom();
    await TRTCCloud.destroySharedInstance();

    // await engine?.leaveChannel();
    // await engine?.destroy();
  }
}
