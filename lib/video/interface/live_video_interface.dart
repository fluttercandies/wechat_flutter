import 'package:get/get.dart';
import 'package:wechat_flutter/video/impl/live_base_impl.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';

abstract class LiveVideoInterFace extends LiveBaseInterface with LiveBaseImpl {
  late RxBool switchCamera;
  late bool switchRender;
  late RxBool isEnableVideo;

  void switchCameraHandle();

  void enableAndDisableCamera({required String targetId});

  Future changeToVoice({required String targetId});

  /// 音频专属
  RxBool openMicrophone = true.obs,
      enableSpeakerphone = true.obs,
      playEffect = false.obs;

  bool enableInEarMonitoring = false;

  double recordingVolume = 100,
      playbackVolume = 100,
      inEarMonitoringVolume = 100;

  void switchMicrophone({required String targetId});

  void switchSpeakerphone();

  void switchEffect();

  void onChangeInEarMonitoringVolume(double value);

  void toggleInEarMonitoring(value);
}
