import 'package:wechat_flutter/video/event_bus/live_state_bus.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class LiveEventBus {
  StreamSubscription? liveStateBusValue;
}

mixin LiveEventBusImpl on LiveEventBus {
  void initLiveEventBus(VoidCallback onSetClosePage,

      /// onSenderCancel需要判断当前是否通话中，如果是通话中则通话结束，且发送正常的可显示消息，
      /// 否则处理对方已取消
      {VoidCallback? onReject,
      VoidCallback? onBusy,
      VoidCallback? onSenderCancel}) {
    liveStateBusValue = liveStateBus.on<LiveStateBusModel>().listen((event) {
      LogUtil.d(
          "liveStateBus::LiveStateBusModel::${event.liveEventState.toString()}");
      if (event.liveEventState == LiveEventState.denied) {
        onSetClosePage();
        if (onReject != null) onReject();
        LiveUtil.closeAndTip("对方拒绝接听");
      } else if (event.liveEventState == LiveEventState.senderCancel) {
        onSetClosePage();

        if (onSenderCancel != null) onSenderCancel();
      } else if (event.liveEventState == LiveEventState.receiverBusy) {
        onSetClosePage();
        if (onBusy != null) onBusy();
        LiveUtil.closeAndTip("对方正忙");
      }
    });
  }

  void closeLiveEventBus() {
    liveStateBusValue?.cancel();
    liveStateBusValue = null;
  }
}
