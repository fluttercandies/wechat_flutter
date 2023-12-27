import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/float/float_window.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/video/float/live_show_widnow.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/video/ui_commom/func/av_permissions_state.dart';
import 'package:wechat_flutter/tools/func/func.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/live/live_msg_list.dart';
import 'package:wechat_flutter/ui_commom/image/sw_avatar.dart';

import 'logic.dart';

class VideoSinglePage extends StatefulWidget {
  const VideoSinglePage({Key? key}) : super(key: key);

  @override
  State<VideoSinglePage> createState() => _VideoSinglePageState();
}

class _VideoSinglePageState extends State<VideoSinglePage>
    with
        RouteAware,
        WidgetsBindingObserver,
        LivePageHandleInterface,
        LiveShowWindow,
        VideoSinglePageHandle {
  final logic = Get.put(VideoSingleLogic());

  @override
  void initState() {
    super.initState();

    Map result = Get.arguments as Map;

    final bool isFloatEnter = result.containsKey("isWindowPush") &&
        result["isWindowPush"] is bool &&
        result["isWindowPush"];

    /// 非悬浮窗进入暂时不做加载中
    if (!isFloatEnter) {
      logic.initLiveHudShow(context, logic.channelEntity, logic.agoraIml);
    }
  }

  @override
  Widget build(BuildContext context) {
    logic.setMiniWindow(context);

    return AvPermissionsBuilder(
      child: Scaffold(
        body: Obx(() {
          if (logic.agoraIml.isChangeToVoice.value) {
            return Container();
          } else {
            return Stack(
              children: [
                VideoLiveBg.bgObs(
                  Obx(() {
                    if (listNoEmpty(logic.agoraIml.remoteUid)) {
                      /// 对方关闭了摄像头
                      if (!logic.otherSizeIsOpenCamera.value) {
                        return AvatarView(logic.getOtherAvatar);
                      }
                      return Container();
                      // return rtc_remote_view.SurfaceView(
                      //   uid: logic.agoraIml.remoteUid[0],
                      //   channelId: logic.agoraIml.channelId!,
                      //   renderMode: VideoRenderMode.Hidden,
                      // );
                    } else {
                      if (!logic.agoraIml.isEnableVideo.value) {
                        return AvatarView(logic.getSelfAvatar);
                      }
                      return TRTCCloudVideoView(
                          // key: valueKey,
                          viewType: TRTCCloudDef.TRTC_VideoView_TextureView,
                          // This parameter is required for rendering desktop.(Android/iOS/web no need)
                          textureParam: CustomRender(
                            userId: Q1Data.user(),
                            isLocal: true,
                            streamType: TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
                            width: 72,
                            height: 120,
                          ),
                          onViewCreated: (viewId) async {
                            await logic.agoraIml.trtcCloud
                                ?.startLocalPreview(true, viewId);
                            setState(() {
                              logic.agoraIml.localViewId = viewId;
                            });
                          });
                    }
                  }).obs,
                  remoteUid: logic.agoraIml.remoteUid,
                  miniWindow: Obx(
                    () {
                      if (!listNoEmpty(logic.agoraIml.remoteUid.value)) {
                        return Container();
                      }
                      return Positioned(
                        top: logic.top.value,
                        left: logic.left.value,
                        child: GestureDetector(
                          // 移动中
                          onPanUpdate: (details) {
                            logic.onPanUpdate(details);
                          },
                          // 移动结束
                          onPanEnd: (details) {
                            logic.onPanEnd(details);
                          },

                          child: Container(
                            width: logic.miniWindowWidth,
                            height: logic.miniWindowHeight,
                            color: Colors.black,
                            child: !logic.agoraIml.isEnableVideo.value
                                ? SwAvatar(logic.getSelfAvatar)
                                : TRTCCloudVideoView(
                                    viewType:
                                        TRTCCloudDef.TRTC_VideoView_TextureView,
                                    // This parameter is required for rendering desktop.(Android/iOS/web no need)
                                    textureParam: CustomRender(
                                      userId: Q1Data.user(),
                                      isLocal: true,
                                      streamType: TRTCCloudDef
                                          .TRTC_VIDEO_STREAM_TYPE_BIG,
                                      width: 72,
                                      height: 120,
                                    ),
                                    onViewCreated: (viewId) async {
                                      await logic.agoraIml.trtcCloud
                                          ?.startLocalPreview(true, viewId);
                                      setState(() {
                                        logic.agoraIml.localViewId = viewId;
                                      });
                                    }),
                          ),
                        ),
                      );
                    },
                  ),
                  callItem: (VideoBtType e) => logic.btActions(e),
                  bottomBts: logic.bottomBts,
                  topBts: logic.topBts,
                  timeShow: logic.timeValueStr,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 270,
                      child: Obx(
                        () => LiveMsgList(
                          logic.agoraIml,
                          MediaType.single,
                          targetId: logic.channelEntity.value!.targetId,
                          isAudio: false,
                        ),
                      ),
                    ),
                    Space(height: 56 + 50),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 60)
                  ],
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  @override
  Future<bool> popHandle() async {
    if (!logic.isClosePage) {
      floatWindow.open(
        context,
        param: FloatWindowParam(
          LivePageType.singleVideo,
          agoraVideoIml: logic.agoraIml,
          infoList: logic.infoList,
          isSend: logic.agoraIml.isSend,
          singleRemoteUid: logic.agoraIml.remoteUid,
          noRspIsOk: logic.noRspIsOk,
          noRspTimeValue: logic.noRspTimeValue,
          myAgoraId: logic.agoraIml.myAgoraId,
          trtcCloud: logic.agoraIml.trtcCloud,
          timeValue: logic.timeValue,
          channelEntity: logic.channelEntity,
          timeValueStr: logic.timeValueStr,
        ),
      );
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

typedef CallItem = Function(VideoBtType e);

class VideoLiveBg extends StatelessWidget {
  final ObxWidget? miniWindow;
  final Rx<Widget>? contentObs;
  final Rx<Widget>? bgObs;
  final Widget? content;
  final RxString? timeShow;
  final List<VideoBtModel> bottomBts;
  final List<VideoBtModel> topBts;
  final CallItem callItem;
  final String? bgImg;
  final RxList<int>? remoteUid;

  const VideoLiveBg({
    this.miniWindow,
    this.contentObs,
    this.content,
    this.remoteUid,
    required this.timeShow,
    required this.bottomBts,
    required this.topBts,
    required this.callItem,
  })  : bgImg = null,
        bgObs = null,
        super();

  const VideoLiveBg.bgImg(
    this.bgImg, {
    this.contentObs,
    this.content,
    this.remoteUid,
    required this.timeShow,
    required this.bottomBts,
    required this.topBts,
    required this.callItem,
  })  : miniWindow = null,
        bgObs = null;

  const VideoLiveBg.bgObs(
    this.bgObs, {
    this.miniWindow,
    this.contentObs,
    this.content,
    this.remoteUid,
    required this.timeShow,
    required this.bottomBts,
    required this.topBts,
    required this.callItem,
  }) : bgImg = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.2),
            width: Get.width,
            height: Get.height,
            child: bgObs != null
                ? Obx(() => bgObs!.value)
                : Stack(
                    children: [
                      !strNoEmpty(bgImg)
                          ? Image.asset(
                              AppConfig.defPic,
                              fit: BoxFit.cover,
                              width: Get.width,
                              height: Get.height,
                            )
                          : bgImg!.startsWith("asset")
                              ? Image.asset(
                                  bgImg!,
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  height: Get.height,
                                )
                              : Image.network(
                                  bgImg!,
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  height: Get.height,
                                ),
                      BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
              children: [
                Container(height: MediaQuery.of(context).padding.top),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: topBts.map<Widget>((e) {
                        if (e.type == VideoBtType.spacer) {
                          return const Spacer();
                        }
                        IconData icons = e.type == VideoBtType.minimize
                            ? Icons.fullscreen_exit_rounded
                            : Icons.change_circle_outlined;

                        double size = 24;
                        return ClickEvent(
                          child: Container(
                            height: 60,
                            padding: EdgeInsets.symmetric(
                                horizontal: e.type == VideoBtType.minimize
                                    ? 20.w
                                    : 12.w),
                            child: () {
                              Widget img = strNoEmpty(e.icon.value)
                                  ? Image.asset(e.icon.value,
                                      width: size, height: size)
                                  : Icon(
                                      icons,
                                      size: 35,
                                      color: Colors.white,
                                    );
                              return img;
                            }(),
                          ),
                          onTap: () {
                            callItem(e.type);
                          },
                        );
                      }).toList(),
                    ),
                    if (remoteUid != null)
                      Obx(
                        () => Text(
                          remoteUid!.length == 0 ? "等待对方接听" : "对方已接听",
                          style: TextStyle(color: Colors.white, fontSize: 15.f),
                        ),
                      )
                  ],
                ),
                if (content != null)
                  Expanded(child: content!)
                else if (contentObs != null)
                  Expanded(child: Obx(() => contentObs!.value))
                else
                  const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: timeShow == null
                      ? Container()
                      : Obx(() {
                          return Text(
                            timeShow!.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.f,
                            ),
                          );
                        }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: bottomBts.map(bottomBtBuilder).toList(),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 60)
              ],
            ),
          ),
          if (miniWindow != null) miniWindow!,
        ],
      ),
    );
  }

  Widget showText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.f,
      ),
    );
  }

  Widget bottomBtBuilder(VideoBtModel e) {
    final bool isCancel = e.type == VideoBtType.cancel;
    Widget text = showText(
        "${e.text}${e.value?.value == null ? "" : e.value!.value ? "已开" : "已关"}");
    if (e.value?.value != null) {
      text = Obx(() => showText(
          "${e.text}${e.value?.value == null ? "" : e.value!.value ? "已开" : "已关"}"));
    }
    Widget iconWidget;
    if (strNoEmpty(e.icon.value)) {
      iconWidget = Obx(() => Image.asset(e.icon.value, width: 56.w));
    } else {
      iconWidget = Icon(
        Icons.set_meal,
        color: isCancel ? Colors.white : Colors.black,
      );
    }
    return ClickEvent(
      child: Container(
        width: Get.width / bottomBts.length,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCancel ? const Color(0xffF35341) : Colors.white,
              ),
              child: iconWidget,
            ),
            SizedBox(height: 8.h),
            text,
          ],
        ),
      ),
      onTap: () {
        callItem(e.type);
      },
    );
  }
}
