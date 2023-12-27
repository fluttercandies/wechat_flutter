import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_flutter/im/im_handle/im_msg_api.dart';
import 'package:wechat_flutter/tools/eventbus/msg_bus.dart';
import 'package:wechat_flutter/tools/utils/file_util.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/call/select_call_type_dialog.dart';
import 'package:wechat_flutter/ui/card/more_item_card.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/video/model/channel_entity.dart';
import 'package:wechat_flutter/video/msg/chat_msg_mixin.dart';
import 'package:wechat_flutter/video/msg/live_msg_event.dart';

class ChatMorePage extends StatefulWidget {
  final int index;
  final String? id;
  final int? type;
  final double? keyboardHeight;

  ChatMorePage({this.index = 0, this.id, this.type, this.keyboardHeight});

  @override
  _ChatMorePageState createState() => _ChatMorePageState();
}

class _ChatMorePageState extends State<ChatMorePage> {
  int channelId = 0;

  List data = [
    {"name": "相册", "icon": "assets/images/chat/ic_details_photo.webp"},
    {"name": "拍摄", "icon": "assets/images/chat/ic_details_camera.webp"},
    {"name": "视频通话", "icon": "assets/images/chat/ic_details_media.webp"},
    {"name": "位置", "icon": "assets/images/chat/ic_details_localtion.webp"},
    {"name": "红包", "icon": "assets/images/chat/ic_details_red.webp"},
    {"name": "转账", "icon": "assets/images/chat/ic_details_transfer.webp"},
    {"name": "语音输入", "icon": "assets/images/chat/ic_chat_voice.webp"},
    {"name": "我的收藏", "icon": "assets/images/chat/ic_details_favorite.webp"},
  ];

  List dataS = [
    {"name": "名片", "icon": "assets/images/chat/ic_details_card.webp"},
    {"name": "文件", "icon": "assets/images/chat/ic_details_file.webp"},
  ];

  List<AssetEntity> assets = <AssetEntity>[];

  itemBuild(data) {
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(bottom: 20.0),
      child: new Wrap(
        runSpacing: 10.0,
        spacing: 10,
        children: List.generate(data.length, (index) {
          String? name = data[index]['name'];
          String? icon = data[index]['icon'];
          return new MoreItemCard(
            name: name,
            icon: icon,
            keyboardHeight: widget.keyboardHeight,
            onPressed: () => action(name),
          );
        }),
      ),
    );
  }

  action(String? name) async {
    if (name == '相册') {
      AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 9,
          pageSize: 320,
          gridCount: 4,
          selectedAssets: assets,
          themeColor: MyTheme.themeColor(),
          textDelegate: AssetPickerTextDelegate(),
        ),
      ).then((List<AssetEntity>? result) {
        /// 没有选择文件
        if (result == null) {
          return;
        }
        result.forEach((AssetEntity element) async {
          /// 媒体文件类型，1=图片；2=视频；
          final int mediaType = FileUtil.getInstance()!
              .mediaTypeOfPath((await element.file)!.path);

          V2TimMessage? v;

          /// 判断是图片还是视频
          if (mediaType == 1) {
            v = await ImMsgApi.sendImageMessage(
              (await element.file)!.path,
              receiver: widget.type == 1 ? widget.id! : "",
              groupID: widget.type != 1 ? widget.id! : "",
            );
          } else {
            v = await ImMsgApi.sendVideoMessage(
              (await element.file)!.path,
              receiver: widget.type == 1 ? widget.id : null,
              groupID: widget.type != 1 ? widget.id : null,
            );
          }
          if (v == null) return;
          Notice.send(WeChatActions.msg(), '');

          /// 事件总线发送，让其他地方同步消息
          msgBus.fire(MsgBusModel(widget.id));
        });
      });
    } else if (name == '拍摄') {
      final AssetEntity? assetEntity = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: const CameraPickerConfig(enableRecording: true),
      );

      if (assetEntity == null || !strNoEmpty((await assetEntity.file)!.path)) {
        return;
      }

      V2TimMessage? v;

      /// 判断是图片还是视频
      if (assetEntity.type == AssetType.image) {
        v = await ImMsgApi.sendImageMessage(
          (await assetEntity.file)!.path,
          receiver: widget.type == 1 ? widget.id! : "",
          groupID: widget.type != 1 ? widget.id! : "",
        );
      } else {
        v = await ImMsgApi.sendVideoMessage(
          (await assetEntity.file)!.path,
          receiver: widget.type == 1 ? widget.id : null,
          groupID: widget.type != 1 ? widget.id : null,
        );
      }

      if (v == null) return;
      Notice.send(WeChatActions.msg(), '');

      /// 事件总线发送，让其他地方同步消息
      msgBus.fire(MsgBusModel(widget.id));
    } else if (name == '视频通话') {
      final value = await selectCallTypeDialog(context);
      if (value == null) {
        return;
      }

      /// value为0跳转视频通话，否则音频通话
      String routeName = value == 0
          ? RouteConfig.videoSinglePage
          : RouteConfig.audioSinglePage;
      LiveUtil.checkPermissionThen(
        () async {
          Get.toNamed(
            routeName,
            arguments: {
              "call": (callChannelId) {
                sendVideoChat(callChannelId);
              },
              "content": await getLiveMsgUserInfo(),
              "channelId": "", //一定要传, 否则Get获取参数导致停止
            },
          );
        },
      );
    } else if (name == '红包') {
      q1Toast('测试发送红包消息');
      // await sendTextMsg('${widget?.id}', widget.type, "测试发送红包消息");
    } else {
      q1Toast('敬请期待$name');
    }
  }

  /*
  * 获取直播用户信息
  * */
  Future<String> getLiveMsgUserInfo() async {
    final V2TimUserFullInfo? selfInfo =
        (await ImApi.getUsersInfo([Q1Data.user()]))?.first;
    final V2TimUserFullInfo? targetInfo =
        (await ImApi.getUsersInfo([widget.id!]))?.first;

    // String userAccountSp = await SpUtil().get(KeyConstant.agoraAccount);
    ChannelEntity channelEntity = ChannelEntity(
      channelId: channelId,
      mediaType: "Single",
      toChatId: widget.id!,
      toChatName: targetInfo?.nickName ?? '',
      toAvatar: targetInfo?.faceUrl ?? "",
      sendChatId: selfInfo?.userID ?? "",
      sendChatName: selfInfo?.nickName ?? '',
      sendAvatarUrl: selfInfo?.faceUrl ?? '',
      sendAgoraUid: Q1Data.user(),
      groupId: "",
    );
    return json.encode(channelEntity);
  }

  void sendVoiceChat(int channelIdValue) async {
    channelId = channelIdValue;
    if (channelId == 0) return;

    /// 发送隐藏消息【单人音频】
    ChatMsgUtil.sendHideMsg(channelIdValue, LiveMsgEventSingleHide.senderSend,
        LivePageType.singleAudio, widget.id!, false);
  }

  void sendVideoChat(int channelIdValue) async {
    channelId = channelIdValue;
    if (channelId == 0) return;

    /// 发送隐藏消息【单人视频】
    ChatMsgUtil.sendHideMsg(channelIdValue, LiveMsgEventSingleHide.senderSend,
        LivePageType.singleVideo, widget.id!, false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == 0) {
      return itemBuild(data);
    } else {
      return itemBuild(dataS);
    }
  }
}
