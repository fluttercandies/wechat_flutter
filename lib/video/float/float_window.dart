// 抽象类，接口作用
import 'package:flutter/material.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:wechat_flutter/video/impl/agora_audio_iml.dart';
import 'package:wechat_flutter/video/impl/agora_video_iml.dart';
import 'package:wechat_flutter/video/model/channel_entity.dart';
import 'package:wechat_flutter/video/other/user/entity.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class FloatWindowParam {
  LivePageType type;
  AgoraVideoIml? agoraVideoIml;
  AgoraAudioIml? agoraAudioIml;
  RxList<UserInfoEntity?>? infoList;
  int? noRspTimeValue;
  bool? noRspIsOk;
  RxBool? isSend;
  RxList<int>? singleRemoteUid;
  int? myAgoraId;
  TRTCCloud? trtcCloud;
  int? timeValue;
  Rx<ChannelEntity?>? channelEntity;
  RxString timeValueStr;

  bool get isJoin {
    return agoraVideoIml?.isJoined ?? false;
  }

  LiveBaseInterface get agoraIml {
    return (agoraVideoIml ?? agoraAudioIml)!;
  }

  RxList<int> get remoteUid {
    return agoraVideoIml?.remoteUid ?? agoraAudioIml?.remoteUid ?? <int>[].obs;
  }

  bool get isHaveConnect {
    return listNoEmpty(singleRemoteUid);
  }

  int get channelId {
    return agoraVideoIml?.channelId ?? agoraAudioIml?.channelId ?? AppConfig.mockCallRoomId;
  }

  FloatWindowParam(
    this.type, {
    this.agoraVideoIml,
    this.agoraAudioIml,
    this.infoList,
    this.noRspTimeValue,
    this.noRspIsOk,
    this.myAgoraId,
    this.trtcCloud,
    required this.singleRemoteUid,
    required this.isSend,
    required this.timeValue,
    required this.channelEntity,
    required this.timeValueStr,
  });
}

abstract class FloatWindow {
  bool get isHaveFloat;

  FloatWindowParam? paramValue;

  /// 打开悬浮窗
  void open(BuildContext context, {required FloatWindowParam param});

  /*
  * 设置参数值
  * */
  void setParamValue({required FloatWindowParam param});

  /// 关闭悬浮窗
  Future<bool> close();

  /// 销毁小窗实体与引擎
  void closeFloatUIAndEngine();

  /// 悬浮窗被点击
  void floatClick();
}
