import 'package:flutter/material.dart';
import 'package:wechat_flutter/video/float/float_view/state.dart';
import 'package:wechat_flutter/video/float/float_window.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/tools/func/func.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

import 'logic.dart';

enum LivePageType {
  singleAudio,
  multipleAudio,
  singleVideo,
  multipleVideo,
}

class FloatViewPage extends StatefulWidget {
  final FloatWindowParam param;

  const FloatViewPage(this.param, {Key? key}) : super(key: key);

  @override
  FloatViewPageState createState() => FloatViewPageState();
}

class FloatViewPageState extends State<FloatViewPage> {
  late FloatViewLogic logic;
  late FloatViewState state;

  @override
  void initState() {
    super.initState();
    logic = Get.put(FloatViewLogic());
    state = Get.find<FloatViewLogic>().state;

    logic.onInitHandle(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      /// 【2021 11.25】优化小窗口位置（安卓苹果统一）
      /// 直播UI验收11.16 - 飞书云文档   【商品分享】安卓、IOS分享商品，都会出现挡住
      top: state.top,
      left: state.left,
      child: GetBuilder<FloatViewLogic>(
        builder: (v) {
          return GestureDetector(
            // 移动中
            onPanUpdate: (v) => logic.onPanUpdate(v, this),
            // 移动结束
            onPanEnd: (v) => logic.onPanEnd(v, this),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                type: MaterialType.transparency,
                child: _floatViewItemWidget(context, state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _floatViewItemWidget(BuildContext context, FloatViewState state) {
    if (widget.param.type == LivePageType.singleAudio ||
        widget.param.type == LivePageType.multipleAudio) {
      return ClickEvent(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/live/live_audio_windwo_bg.png',
              width: 89,
              height: 88,
            ),
            Obx(() {
              return Text(
                !listNoEmpty(widget.param.agoraIml.remoteUid.value)
                    ? "等待接听"
                    : '通话中\n${logic.timeValueStr.value}',
                style: TextStyle(
                  color: const Color(0xff07C160),
                  fontSize: 12.f,
                ),
              );
            })
          ],
        ),
        onTap: () {
          floatWindow.floatClick();
        },
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ClickEvent(
        onTap: () async {
          floatWindow.floatClick();
        },
        child: SizedBox(
          width: state.viewWidth,
          height: state.viewHeight,
          child: () {
            if (!listNoEmpty(widget.param.remoteUid) ||
                widget.param.type == LivePageType.multipleVideo) {
              return Container();
              // return const SurfaceView(
              //   zOrderMediaOverlay: true,
              //   zOrderOnTop: true,
              // );
            } else {
              return Container();

              // return SurfaceView(
              //   uid: widget.param.remoteUid[0],
              //   channelId: widget.param.channelId,
              //   renderMode: VideoRenderMode.Hidden,
              // );
            }
          }(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    logic.onCloseHandle(widget.param);
  }
}
