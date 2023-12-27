import 'package:flutter/material.dart';
import 'package:wechat_flutter/video/float/float_view/state.dart';
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/video/float/float_window.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/video/impl/live_event_bus_impl.dart';
import 'package:wechat_flutter/video/impl/live_logic_impl.dart';
import 'package:wechat_flutter/video/impl/single_no_rsp.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/video/logic/live_time_logic.dart';
import 'package:wechat_flutter/video/model/channel_entity.dart';
import 'package:wechat_flutter/video/msg/chat_msg_mixin.dart';
import 'package:wechat_flutter/video/msg/chat_msg_param.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';


class FloatViewLogic extends GetxController
    with
        LiveCheckClose,
        SingleNoRspAbs,
        SingleNoRsp,
        LiveEventBus,
        LiveEventBusImpl,
        LiveTimeObs,
        LiveTimeLogic {
  final FloatViewState state = FloatViewState();

/*
* 需要主动在initState调用
* */
  void onInitHandle(FloatWindowParam param) {
    initLiveEventBus(() => setClosePage());
    initParam(param);
    if (!param.isHaveConnect) {
      noRspStartTime(() {
        LiveBaseInterface agoraIml = param.agoraIml;
        Rx<ChannelEntity?> channelEntity = param.channelEntity!;
        // 发送隐藏消息给对方【让其关闭等待接听的页面】
        ChatMsgParam chatMsgParam = ChatMsgParam(
          agoraIml.channelId ?? AppConfig.mockCallRoomId,
          param.type,
          channelEntity.value!.targetId,

          /// 是否群聊应该为真实数据
          param.type.toString().contains('multiple'),
        );
        ChatMsgUtil.sendCancelHideMsg(chatMsgParam);

        // 发送【对方无应答】可视消息
        ChatMsgUtil.sendNoRspShowMsg(chatMsgParam);
      });
    } else {
      startTime();
    }
    if (state.isShowAudioWindow) {
      state.left = state.overlayHomeLeft;
      state.top = state.overlayHomeTop;
    } else {
      state.left = state.overlayLeft;
      state.top = state.overlayTop;
    }
  }

  /*
  * 初始化参数
  * */
  void initParam(FloatWindowParam param) {
    noRspTimeValue = param.noRspTimeValue ?? 0;
    noRspIsOk = param.noRspIsOk ?? false;
    if (param.timeValue != null) {
      timeValue = param.timeValue!;
    }
  }

  /*
  * 拖动更新位置
  * */
  void onPanUpdate(DragUpdateDetails details, State<FloatViewPage> pageState) {
    pageState.setState(() {
      if (state.isShowAudioWindow) {
        state.top = details.globalPosition.dy;
        state.left = details.globalPosition.dx;
      } else {
        state.left = details.globalPosition.dx - state.viewWidth / 2;
        state.top = details.globalPosition.dy - state.viewHeight / 2;
        if (state.left <= 0) {
          state.left = 0;
        } else if (state.left >= Get.width - state.viewWidth) {
          state.left = Get.width - state.viewWidth;
        }

        if (state.top <= ScreenUtil.mediaQuery.padding.top + 64) {
          state.top = ScreenUtil.mediaQuery.padding.top + 64;
        } else if (state.top >=
            Get.height -
                ScreenUtil.mediaQuery.padding.bottom -
                state.viewWidth * 2) {
          state.top = Get.height -
              ScreenUtil.mediaQuery.padding.bottom -
              state.viewWidth * 2;
        }
      }
    });
  }

  /*
  * 拖动结束
  * */
  void onPanEnd(details, State<FloatViewPage> pageState) {
    pageState.setState(() {
      if (state.isShowAudioWindow) {
        if (state.top <= (ScreenUtil.mediaQuery.padding.top + 5.5)) {
          state.top = ScreenUtil.mediaQuery.padding.top + 5.5;
        } else if (state.top >=
            Get.height - (ScreenUtil.mediaQuery.padding.bottom * 2)) {
          state.top = Get.height - (ScreenUtil.mediaQuery.padding.bottom * 2);
        }
      }
      if (state.left + state.viewWidth / 2 < Get.width / 2) {
        state.left = 0;
      } else {
        if (state.isShowAudioWindow) {
          state.left = Get.width - 32;
        } else {
          state.left = Get.width - state.viewWidth;
        }
      }
    });

    /// 设置全局存储位置数据
    if (state.isShowAudioWindow) {
      state.overlayHomeLeft = state.left;
      state.overlayHomeTop = state.top;
    } else {
      state.overlayLeft = state.left;
      state.overlayTop = state.top;
    }
  }

/*
* 需要主动在dispose调用
* */
  void onCloseHandle(FloatWindowParam param) {
    // 关闭事件总线
    closeLiveEventBus();

    param.timeValue = timeValue;
    param.timeValueStr = timeValueStr;
    floatWindow.setParamValue(param: param);

    /// 都取消，防止有中途连接上的
    /// 一定要关闭否则不是同一个实例
    noRspCancelTime();
    cancelTime();
  }
}
