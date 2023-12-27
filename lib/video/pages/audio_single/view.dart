import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/ui_commom/app/my_scaffold.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/float/float_window.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/video/float/live_show_widnow.dart';
import 'package:wechat_flutter/video/impl/agora_video_iml.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/video/impl/single_no_rsp.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/video/msg/chat_msg_mixin.dart';
import 'package:wechat_flutter/video/pages/video_sigle/logic.dart';
import 'package:wechat_flutter/video/pages/video_sigle/view.dart';
import 'package:wechat_flutter/video/ui_commom/func/av_permissions_state.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/live/live_msg_list.dart';
import 'package:wechat_flutter/ui_commom/view/hud_view.dart';

import 'logic.dart';

class AudioSinglePage extends StatefulWidget {
  final bool isChangeToVoice;
  final int timeValue;
  final AgoraVideoIml? agoraImlVideo;
  final SingleNoRsp? singleNoRspValue;
  final int? channelId;
  final int? audToVideoMyAgoraId;

  AudioSinglePage(
      {this.isChangeToVoice = false,
      this.timeValue = 0,
      this.agoraImlVideo,
      this.singleNoRspValue,
      this.channelId,
      this.audToVideoMyAgoraId,
      Key? key})
      : super(key: key);

  @override
  State<AudioSinglePage> createState() => _AudioSinglePageState();
}


class _AudioSinglePageState extends State<AudioSinglePage> with RouteAware,
    WidgetsBindingObserver,
    LivePageHandleInterface,
    LiveShowWindow,
    AudioSinglePageHandle {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: ComMomBar(
        title: "语音通话【敬请期待】",
      ),
    );
  }

  @override
  Future<bool> popHandle() {
    // TODO: implement popHandle
    throw UnimplementedError();
  }

}
// class _AudioSinglePageState extends State<AudioSinglePage> with RouteAware,
//         WidgetsBindingObserver,
//         LivePageHandleInterface,
//         LiveShowWindow,
//         AudioSinglePageHandle {
//   late AudioSingleLogic logic;
//
//   @override
//   void initState() {
//     super.initState();
//     logic = Get.put(
//       AudioSingleLogic(
//         widget.singleNoRspValue,
//         widget.isChangeToVoice,
//         widget.timeValue,
//         widget.agoraImlVideo,
//         widget.channelId,
//         widget.audToVideoMyAgoraId,
//       ),
//     );
//
//     Map result = Get.arguments as Map;
//
//     final bool isFloatEnter = result.containsKey("isWindowPush") &&
//         result["isWindowPush"] is bool &&
//         result["isWindowPush"];
//
//     /// 非悬浮窗进入暂时不做加载中
//     if (!isFloatEnter) {
//       logic.initLiveHudShow(context, logic.channelEntity, logic.agoraIml);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AvPermissionsBuilder(
//       child: Scaffold(
//         body: Obx(
//           () => VideoLiveBg.bgImg(
//             "https://gd-hbimg.huaban.com/7d9b0e09560597333288b6ea56e8fdd2d3e9df57f52f-Z7AHiN_fw1200",
//             remoteUid: logic.agoraIml.remoteUid,
//             callItem: (VideoBtType e) => logic.btActions(e),
//             bottomBts: logic.bottomBts.value,
//             topBts: logic.topBts,
//             timeShow: logic.timeValueStr,
//             content: Column(
//               children: [
//                 SizedBox(height: 90.h),
//                 Obx(
//                   () {
//                     final String avatar = ((logic.agoraIml.isSend.value)
//                             ? logic.channelEntity.value?.toAvatar
//                             : logic.channelEntity.value?.sendAvatarUrl) ??
//                         "";
//                     return CircleAvatar(
//                       radius: 86 / 2,
//                       backgroundImage: strNoEmpty(avatar)
//                           ? NetworkImage(avatar)
//                           : (AssetImage(AppConfig.defPic) as ImageProvider),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 16.h),
//                 () {
//                   final String toChatName =
//                       logic.channelEntity.value?.toChatName ?? "";
//                   final String sendChatName =
//                       logic.channelEntity.value?.sendChatName ?? "";
//                   return Obx(() {
//                     final String name = (logic.agoraIml.isSend.value)
//                         ? toChatName
//                         : sendChatName;
//                     return Text(
//                       name,
//                       style: TextStyle(color: Colors.white, fontSize: 20.f),
//                     );
//                   });
//                 }(),
//                 Space(height: 30),
//                 Expanded(
//                   child: Obx(
//                     () => LiveMsgList(
//                       logic.agoraIml,
//                       MediaType.single,
//                       targetId: logic.channelEntity.value!.targetId,
//                       isAudio: true,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Future<bool> popHandle() async {
//     if (!logic.isClosePage) {
//       floatWindow.open(
//         context,
//         param: FloatWindowParam(
//           LivePageType.singleAudio,
//           agoraAudioIml: logic.agoraIml,
//           infoList: logic.infoList,
//           isSend: logic.agoraIml.isSend,
//           singleRemoteUid: logic.agoraIml.remoteUid,
//           noRspIsOk: logic.noRspIsOk,
//           noRspTimeValue: logic.noRspTimeValue,
//           myAgoraId: logic.agoraIml.myAgoraId,
//           trtcCloud: logic.agoraIml.trtcCloud,
//           timeValue: logic.timeValue,
//           channelEntity: logic.channelEntity,
//           timeValueStr: logic.timeValueStr,
//         ),
//       );
//     }
//     return true;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     HudView.dismiss();
//     logic.agoraIml.cancelRecognition();
//   }
// }
