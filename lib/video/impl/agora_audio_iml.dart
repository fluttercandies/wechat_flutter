import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_flutter/video/event/live_stream_event.dart';
import 'package:wechat_flutter/video/event_bus/recognition_bus.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/tools/func/log.dart';

import '../interface/live_audio_interface.dart';

const int defaultSampleRate = 16000;
const int defaultChannelCount = 1;

class AgoraAudioIml extends LiveAudioInterFace {
  final MediaType mediaType;

  AgoraAudioIml(this.mediaType);

  @override
  // TRTCCloud? engine;

  // final CustomCaptureAudioApi _api = CustomCaptureAudioApi();

  /// 语音识别文字的timer
  Timer? recognitionTimer;
  int recognitionCount = 0;

  @override
  void addListeners(
    VoidCallback onUserJoined,
    VoidCallback? onSelfJoinChannel,
    LiveStateChange? onLiveStateChange,
    LiveJoinFail? onLiveJoinFail,
    // RxBool enableTl,
  ) {
    LogUtil.d("$logHead 添加监听");
    // engine?.setEventHandler(RtcEngineEventHandler(
    //   warning: (warningCode) {
    //     LogUtil.d('$logHead warning $warningCode');
    //     if (warningCode == WarningCode.OpenChannelTimeout ||
    //         warningCode == WarningCode.OpenChannelRejected) {
    //       if (onLiveJoinFail != null) {
    //         onLiveJoinFail(LiveErrorType.channelError);
    //       }
    //     }
    //   },
    //   error: (ErrorCode errorCode) {
    //     LogUtil.d(
    //         '$logHead error $errorCode。errorCode.name::${errorCode.name}');
    //   },
    //   joinChannelSuccess: (channel, uid, elapsed) async {
    //     LogUtil.d('$logHead joinChannelSuccess $channel $uid $elapsed');
    //
    //     /// 开始音频采集
    //     await _api.startAudioRecord(
    //         defaultSampleRate, defaultChannelCount, enableTl, openMicrophone);
    //
    //     /// 开始识别
    //     startRecognition(enableTl);
    //
    //     // 取消hud
    //     HudView.dismiss();
    //
    //     myAgoraId = uid;
    //     if (onSelfJoinChannel != null) onSelfJoinChannel();
    //     joinOkHandle();
    //   },
    //   networkQuality: handleNet,
    //   leaveChannel: (stats) async {
    //     LogUtil.d('$logHead leaveChannel ${stats.toJson()}');
    //     isJoined = false;
    //     remoteUid.clear();
    //   },
    //   userJoined: (uid, elapsed) async {
    //     LogUtil.d('$logHead:userJoined  $uid $elapsed');
    //     remoteUid.add(uid);
    //     onUserJoined();
    //   },
    //   userOffline: (uid, reason) {
    //     LogUtil.d('$logHead:userOffline  $uid $reason');
    //
    //     remoteUid.removeWhere((element) => element == uid);
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
      /// 此事件音频不需要处理
    } else {
      if (onLiveStateChange != null) onLiveStateChange(steamEvent);
    }
  }

  /*
  * 开始识别语音
  * */
  Future startRecognition(RxBool enableTl) async {
    LogUtil.d("【语音识别】开始倒计时轮训");
    recognitionTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (recognitionCount < 5) {
        recognitionCount++;
      } else {
        if (enableTl.value) {
          // await _api.startGetText(enableTl);
        } else {
          LogUtil.d("已经关闭了语音转文字翻译功能");
        }
        recognitionCount = 0;
      }
    });
  }

  /*
  * 取消识别语音
  * */
  Future cancelRecognition() async {
    LogUtil.d("【语音识别】取消倒计时");
    recognitionTimer?.cancel();
    recognitionTimer = null;
    // await _api.stopAudioRecord();
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

    // engine = await RtcEngine?.createWithContext(
    //     RtcEngineContext(Environment.appIdAgora));
    //
    // // engine.enable();
    //
    // addListeners(onUserJoined, onSelfJoinChannel, onLiveStateChange,
    //     onLiveJoinFail, enableTl);
    //
    // /// 使用自定义采集，不需要开启音频了
    // // await engine?.enableAudio();
    //
    // /// 一定要直播模式，否则服务端收不到加入频道和退出频道通知
    // await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // await engine?.setClientRole(ClientRole.Broadcaster);

    await getUserToken(onSetClosePage);

    await joinChannel(onSetClosePage);
  }

  @override
  Future destroyEngine() async {
    // 取消文字识别
    cancelRecognition();

    channelId = null;
    remoteUid.clear();
    // await engine?.leaveChannel();
    // await engine?.destroy();
  }

  @override
  Future joinChannel(VoidCallback onSetClosePage) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    if (channelId == null) {
      onSetClosePage();
      LiveUtil.closeAndTip("加入频道失败");
    }

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
    // option.autoSubscribeVideo = false;
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

    // 取消文字识别
    cancelRecognition();

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
  void switchMicrophone(String targetId) async {
    // await engine?.enableLocalAudio(!openMicrophone.value).then((value) {
    //   openMicrophone.value = !openMicrophone.value;
    // }).catchError((err) {
    //   LogUtil.d('$logHead enableLocalAudio $err');
    // });
    //
    // final LiveEventName msEvent = openMicrophone.value
    //     ? LiveEventName.openMicrophone
    //     : LiveEventName.closeMicrophone;
    //
    // sendLiveMsg(
    //   msEvent,
    //   mediaType,
    //   true,
    //   targetId: targetId,
    // );
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
}
