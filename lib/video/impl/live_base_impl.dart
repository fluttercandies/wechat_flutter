import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wechat_flutter/video/event/live_stream_event.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/video/msg/chat_msg_mixin.dart';
import 'package:wechat_flutter/video/other/user/entity.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/video/msg/live_msg_event.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

mixin LiveBaseImpl on LiveBaseInterface {
  /*
  * 开始检测加入频道
  * */
  @override
  Future startCheckJoin(VoidCallback onSetClosePage) async {
    await Future.delayed(const Duration(seconds: 5));

    /// 等待了5秒还没出现加入频道成功，向服务器请求看是否加入成功
    if (isJoined) return;

    /// 频道id为空，说明已经退出了或异常了
    if (!numNoEmpty(channelId)) return;

    final List<UserInfoEntity> allUser =
        await channelAllUserInfo(onSetClosePage);

    UserInfoEntity? whenData;
    for (UserInfoEntity element in allUser) {
      final int intUid = int.parse("${element.uid}");
      if (intUid == userAccount) {
        whenData = element;
      }
    }
    if (whenData == null) return;

    joinOkHandle();

    LogUtil.d("allUser::${allUser.toString()}");
    LogUtil.d("whenData::${whenData.toString()}");
  }

  @override
  Future joinOkHandle() async {
    // q1Toast( "连接成功");
    isJoined = true;
    // await channelAllUserInfo();
    // await channelActiveUserInfo();
    // await activeChannel();
    // await activeAll();
    // await getChannelBaseInfo();
  }

  /*
  *  设置测试用户id
  * */
  Future setTestUserId() async {
    // String userAccountSp = await SpUtil().get(KeyConstant.agoraAccount);
    String userAccountSp = Q1Data.user();
    if (!strNoEmpty(userAccountSp)) {
      userAccount = 0;
      return;
    }
    try {
      userAccount = int.parse(userAccountSp);
    } catch (e) {
      debugPrint("解析存储的账号异常");
    }
  }

  @override
  Future getUserToken(VoidCallback onSetClosePage) async {
    // try {
    //   final rsp = await liveViewModel
    //       .getUserTokenRequestModel(strNoEmpty(channelId) ? channelId : null);
    //   if (rsp.data == null) {
    //     onSetClosePage();
    //     LiveUtil.closeAndTip("获取用户token失败");
    //     return;
    //   }
    //
    //   channelId = rsp.data['channel'];
    //   userAccount = rsp.data['account'];
    //   userToken = rsp.data["token"];
    //   if (!strNoEmpty(userToken)) {
    //     onSetClosePage();
    //     LiveUtil.closeAndTip("获取用户失败");
    //   }
    //   debugPrint("fetch userToken::$userToken");
    // } catch (e) {
    //   debugPrint("fetch userToken error ::${e.toString()}");
    //   onSetClosePage();
    //   LiveUtil.closeAndTip("获取用户失败");
    // }

    // if (!strNoEmpty(userToken)) {
    //   onSetClosePage();
    //   LiveUtil.closeAndTip("获取用户失败");
    // }
  }

  @override
  Future<List<UserInfoEntity>> channelAllUserInfo(
      VoidCallback onSetClosePage) async {
    
    // try {
    //   final rsp = await liveViewModel.channelAllUserInfo(channelId: channelId!);
    //
    //   if (rsp.data == null || (rsp.data is List && rsp.data.length == 0)) {
    //     return [];
    //   }
    //
    //   List<UserInfoEntity> dataList = List.from(rsp.data ?? []).map((e) {
    //     return UserInfoEntity.fromJson(e);
    //   }).toList();
    //   return dataList;
    // } catch (e) {
    //   LogUtil.d("获取在线人数出错:${e.toString()}");
    //   onSetClosePage();
    //   LiveUtil.closeAndTip("获取在线人数失败");
      return [];
    // }
  }

  @override
  Future channelActiveUserInfo() async {
    // final rsp =
    //     await liveViewModel.channelActiveUserInfo(channelId: channelId!);
    // if (rsp.data == null) {
    //   return;
    // }
  }

  @override
  Future activeChannel() async {
    // final rsp = await liveViewModel.activeChannel();
    // if (rsp.data == null) {
    //   return;
    // }
  }

  @override
  Future activeAll() async {
    // final rsp = await liveViewModel.activeAll();
    // if (rsp.data == null) {
    //   return;
    // }
  }

  @override
  Future getChannelBaseInfo() async {
    // final rsp = await liveViewModel.getChannelBaseInfo(channelId!);
    // if (rsp.data == null) {
    //   return;
    // }
  }

  /*
  * 处理网络
  * */
  @override
  void handleNet(int uid, txQuality, rxQuality) {
    // final bool isBad = txQuality.index >= NetworkQuality.VBad.index ||
    //     rxQuality.index >= NetworkQuality.VBad.index;
    // if (isBad) {
    //   // q1Toast( '你的网络有点差哦 ', gravity: ToastGravity.CENTER);
    // }
  }

  /*
  * 发送直播消息
  * 发送数据流消息
  * */
  Future sendLiveMsg(LiveEventName msEvent, MediaType mediaType, bool isAudio,
      {String? content, String? msgId, required String targetId}) async {
    LogUtil.d("LiveBaseImpl::sendLiveMsg::发送直播消息");
    if (myAgoraId == null) {
      LogUtil.d("用户id为空，无法发送附加消息");
      return;
    }
    if (!strNoEmpty(targetId)) {
      LogUtil.d("targetId为空，无法发送附加消息");
      q1Toast( "targetId为空，无法发送附加消息");
      return;
    }

    final msgValue = LiveSteamEvent(
      uid: myAgoraId!,
      eventName: msEvent.name,
      content: content,
      msgId: msgId ?? "0",
    );

    final Uint8List sendData = utf8.encode(msgValue.toString()) as Uint8List;

    bool isGroup = mediaType == MediaType.multiple;

    LivePageType audioPageType = mediaType == MediaType.multiple
        ? LivePageType.multipleAudio
        : LivePageType.singleAudio;

    LivePageType videoPageType = mediaType == MediaType.multiple
        ? LivePageType.multipleVideo
        : LivePageType.singleVideo;

    /// 发送隐藏消息【流附加消息】
    ChatMsgUtil.sendHideMsg(channelId!, LiveMsgEventSingleHide.liveMsg,
        isAudio ? audioPageType : videoPageType, targetId, isGroup,
        msgContent: sendData.toString());

    LogUtil.d("send sendLiveMsg success : msEvent::${msEvent.name},"
        "content :$content,isGroup :$isGroup, targetId :$targetId, uid: $myAgoraId");
  }
}
