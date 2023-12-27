import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_flutter/video/event/live_stream_event.dart';
import 'package:wechat_flutter/video/event_bus/live_stream_msg_bus.dart';
import 'package:wechat_flutter/video/model/channel_entity.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class LiveUtilData {
  /// 视频转语音通话列表
  static List<String> videoToVoiceList = [];
}

class LiveUtil {
  static handleLiveMsg(LiveStreamMsgModel p0, Rx<ChannelEntity?> channelEntity,
      LiveBaseInterface agoraIml, LiveStateChange? onLiveStateChange) {
    if (p0.channelId == channelEntity.value?.channelId ||
        p0.channelId == agoraIml.channelId) {
      LogUtil.d(
          "解析直播数据流消息：类型：：${p0.msgContent!.runtimeType}，p0.msgContent!：：${p0.msgContent!}");
      final realMsg = utf8.decode(List.from(json.decode(p0.msgContent!)));
      LogUtil.d(
          "解析直播数据流消息【解析后】：类型：：${json.decode(realMsg)!.runtimeType}，数据：：${json.decode(realMsg)}");

      LiveSteamEvent liveSteamEvent =
          LiveSteamEvent.fromJson(json.decode(realMsg));
      final Uint8List sendData =
          utf8.encode(json.encode(json.decode(realMsg))) as Uint8List;
      agoraIml.streamMessage(
          liveSteamEvent.uid, 0, sendData, onLiveStateChange);
    }
  }

  /*
  * 是否包含直播【音视频通话】
  * */
  static bool get isHasLive {
    return floatWindow.isHaveFloat || isLiveRoute;
  }

  /*
  * 是否直播【音视频通话】或相关路由
  * */
  static bool get isLiveRoute {
    return Get.currentRoute.contains("audio") ||
        Get.currentRoute.contains("video") ||
        Get.currentRoute.contains("acceptPage");
    ;
  }

  /*
  * 检测音视频权限再执行下一步
  * */
  static Future<void> checkPermissionThen(VoidCallback then) async {
    List<Permission> permissions = [
      Permission.camera,
      Permission.microphone,
    ];
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    LogUtil.d("statuses[Permission.camera]::${statuses[Permission.camera]}");
    LogUtil.d(
        "statuses[Permission.microphone]::${statuses[Permission.microphone]}");
    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.microphone] != PermissionStatus.granted) {
      /// 这里不能back，否则页面逻辑出错
      Get.defaultDialog(
        title: '提示',
        content: const Text('请到系统内设置允许本应用使用麦克风和摄像头权限!'),
        textConfirm: "确定",
        onConfirm: () {
          Get.back();
          openAppSettings();
        },
      );
    } else {
      then();
    }
    LogUtil.d("LiveUtil::checkPermissionThen::如果有悬浮窗的话这时会取消掉悬浮窗"); // 取消掉悬浮窗
    floatWindow.close();
  }

  /*
  * 检测音视频和扫码权限再执行下一步
  *
  /// ### Android (AndroidManifest.xml)
  ///  * READ_EXTERNAL_STORAGE (REQUIRED)
  ///  * WRITE_EXTERNAL_STORAGE
  ///  * ACCESS_MEDIA_LOCATION
  ///
  /// ### iOS (Info.plist)
  ///  * NSPhotoLibraryUsageDescription
  ///  * NSPhotoLibraryAddUsageDescription
  ///
  * */
  static Future<void> checkScanPermissionThen(VoidCallback then) async {
    List<Permission> permissions = Platform.isAndroid
        ? [Permission.storage]
        : [
            Permission.camera,
            Permission.microphone,
            Permission.location,
            Permission.photos,
          ];
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    final bool hasPermission = Platform.isAndroid
        ? statuses[Permission.storage] != PermissionStatus.granted
        : (statuses[Permission.camera] != PermissionStatus.granted ||
            statuses[Permission.microphone] != PermissionStatus.granted ||
            statuses[Permission.storage] != PermissionStatus.granted ||
            statuses[Permission.location] != PermissionStatus.granted ||
            statuses[Permission.photos] != PermissionStatus.granted);
    if (hasPermission) {
      /// 这里不能back，否则页面逻辑出错
      Get.defaultDialog(
        title: '提示',
        content: const Text('请到系统内设置允许本应用使用相册访问等权限'),
        textConfirm: "确定",
        onConfirm: () {
          Get.back();
          openAppSettings();
        },
      );
    } else {
      then();
    }
    LogUtil.d(
        "LiveUtil::checkScanPermissionThen::hasPermission[$hasPermission]>>执行完毕");
  }

  static void closeAndTip(String tip) {
    /// 倒计时完无响应如果有小窗就取消小窗；
    if (floatWindow.isHaveFloat) {
      floatWindow.close();
      q1Toast(tip);
    } else {
      if (isLiveRoute) {
        Get.back();
        q1Toast(tip);
      }
    }
  }
}
