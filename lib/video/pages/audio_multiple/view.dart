import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/float/float_window.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/video/float/live_show_widnow.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/video/other/user/entity.dart';
import 'package:wechat_flutter/video/pages/video_sigle/logic.dart';
import 'package:wechat_flutter/video/pages/video_sigle/view.dart';
import 'package:wechat_flutter/video/ui_commom/func/av_permissions_state.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/live/live_msg_list.dart';
import 'package:wechat_flutter/ui_commom/animation/ball.dart';

import 'logic.dart';

class AudioMultiplePage extends StatefulWidget {
  const AudioMultiplePage({Key? key}) : super(key: key);

  @override
  State<AudioMultiplePage> createState() => _AudioMultiplePageState();
}

class _AudioMultiplePageState extends State<AudioMultiplePage>
    with
        RouteAware,
        WidgetsBindingObserver,
        LivePageHandleInterface,
        LiveShowWindow,
        AudioMultiplePageHandle {
  final logic = Get.put(AudioMultipleLogic());

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
    return AvPermissionsBuilder(
      child: Scaffold(
        body: VideoLiveBg.bgImg(
          "https://gd-hbimg.huaban.com/7d9b0e09560597333288b6ea56e8fdd2d3e9df57f52f-Z7AHiN_fw1200",
          callItem: (VideoBtType e) => logic.btActions(e),
          bottomBts: logic.bottomBts,
          topBts: logic.topBts,
          timeShow: logic.timeValueStr,
          content: Column(
            children: [
              Obx(() {
                return Wrap(
                  children: List.generate(6, (index) {
                    bool isHaveItem = listNoEmpty(logic.infoList.value)
                        ? logic.infoList.value.length > index
                        : false;

                    UserInfoEntity? currentItem;
                    if (isHaveItem) {
                      /// 要求1000000008格式
                      currentItem = logic.infoList.value[index]!;
                    }
                    final bool isSelfValue =
                        currentItem?.uid == logic.agoraIml.myAgoraId;

                    return VoiceMember(
                      isLoading: !isHaveItem,
                      isHasVoice: isHaveItem,
                      voiceValue: isSelfValue
                          ? logic.agoraIml.openMicrophone
                          : (currentItem?.isOpenMicrophone ?? true.obs),
                      model: currentItem,
                    );
                  }),
                );
              }),
              Space(height: 30),
              Expanded(
                child: Obx(
                  () => LiveMsgList(
                    logic.agoraIml,
                    MediaType.multiple,
                    targetId: logic.channelEntity.value!.targetId,
                    isAudio: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<bool> popHandle() async {
    if (!logic.isClosePage) {
      floatWindow.open(
        context,
        param: FloatWindowParam(
          LivePageType.multipleAudio,
          agoraAudioIml: logic.agoraIml,
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
    logic.agoraIml.cancelRecognition();
  }
}

class VoiceMember extends StatelessWidget {
  final Widget? liveContainer;
  final bool isLoading;
  final bool isHasVoice;
  final RxBool voiceValue;
  final UserInfoEntity? model;

  const VoiceMember({
    required this.voiceValue,
    this.liveContainer,
    this.isLoading = false,
    this.isHasVoice = false,
    this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double itemFullWidth = Get.width - 30;
    final double itemSize = itemFullWidth / 3;
    Widget content;
    if (liveContainer != null) {
      content = liveContainer!;
    } else {
      content = strNoEmpty(model?.localuser.avatar)
          ? Image.network(model!.localuser.avatar)
          : isLoading
              ? Container(color: Colors.grey)
              : Image.asset(AppConfig.defPic,
                  alignment: Alignment.center, fit: BoxFit.cover);
    }
    if (isLoading) {
      content = Stack(
        children: [
          content,
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: const BallPulseLoading(),
            ),
          )
        ],
      );
    }
    content = Container(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(itemSize / 2)),
        child: content,
      ),
    );
    if (isHasVoice) {
      const double voiceSize = 25;
      content = Stack(
        children: [
          content,
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              width: voiceSize,
              height: voiceSize,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Obx(() {
                return Image.asset(
                  'assets/images/live/live_avatar_${voiceValue.value ? "open" : "close"}_microphone.png',
                  width: voiceSize,
                  height: voiceSize,
                );
              }),
            ),
          )
        ],
      );
    }
    return SizedBox(
      width: itemSize,
      height: itemSize,
      child: content,
    );
  }
}
