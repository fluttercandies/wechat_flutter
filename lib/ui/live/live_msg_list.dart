import 'package:flutter/material.dart';
import 'package:wechat_flutter/video/event/live_stream_event.dart';
import 'package:wechat_flutter/video/event_bus/recognition_bus.dart';
import 'package:wechat_flutter/video/impl/live_base_impl.dart';
import 'package:wechat_flutter/video/interface/base_interface.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class LiveMsgList extends StatefulWidget {
  final LiveBaseImpl liveBaseImpl;
  final MediaType mediaType;
  final String targetId;
  final bool isAudio;

  LiveMsgList(
    this.liveBaseImpl,
    this.mediaType, {
    required this.targetId,
    required this.isAudio,
    Key? key,
  }) : super(key: key);

  @override
  State<LiveMsgList> createState() => _LiveMsgListState();
}

class _LiveMsgListState extends State<LiveMsgList> {
  double _alignmentY = 0.0;
  ScrollController scrollController = ScrollController();

  StreamSubscription? recognitionBusValue;

  List<RecognitionBusBusModel> data = [];

  @override
  void initState() {
    super.initState();

    /// 光标到最下
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   scrollController.jumpTo(1);
    // });

    recognitionBusValue =
        recognitionBus.on<RecognitionBusBusModel>().listen((event) {
      /// Message from self and the translation function is not enable
      /// direct return.
      // if (!widget.tlBase.enableTl.value && event.isSelf) {
      //   return;
      // }
      if (!mounted) {
        return;
      }

      data.insert(0, event);
      LogUtil.d("组件收到数据:::${event.text}");
      setState(() {});

      if (event.isSelf) {
        try {
          widget.liveBaseImpl.sendLiveMsg(
            LiveEventName.ttsContent,
            widget.mediaType,
            widget.isAudio,
            targetId: widget.targetId,
            content: event.text,
            msgId: event.msgId,
          );
        } catch (e) {
          LogUtil.d("发送语音识别后的消息给其他人时出现错误::${e.toString()}");
        }
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    _alignmentY = -1 + (metrics.pixels / metrics.maxScrollExtent) * 2;
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.2))),
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            ListView.builder(
              reverse: true,
              itemCount: data.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                RecognitionBusBusModel model = data[index];
                return Text('ChatItem');
                // return ChatItem(
                //   isGroup: false,
                //   textString: model.text,
                //   msgId: model.msgId,
                //   isMine: model.isSelf ||
                //       "${widget.liveBaseImpl.myAgoraId}" == model.userId,
                //
                //   /// 直播弹幕实际不需要知道是哪个用户，只需要知道是不是自己
                //   userId: "0",
                // );
              },
            ),
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: const Color(0xffD8D8D8).withOpacity(0.34),
              ),
            ),
            //滚动条
            Container(
              alignment: Alignment(1, -_alignmentY),
              child: Container(
                height: 18,
                width: 6,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    recognitionBusValue?.cancel();
    recognitionBusValue = null;
  }
}
