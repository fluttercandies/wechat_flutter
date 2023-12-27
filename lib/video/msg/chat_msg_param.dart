
import 'package:wechat_flutter/video/float/float_view/view.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

/// 发送隐藏消息和显示消息通用的参数
class ChatMsgParam {
  /// 频道Id
  final int channelIdValue;

  /// 直播页面类型
  final LivePageType livePageType;

  /// 目标id，如果是个人则为个人id，群则为群id
  final String targetId;

  /// 是否群来哦
  final bool isGroup;

  ChatMsgParam(
      this.channelIdValue, this.livePageType, this.targetId, this.isGroup);
}
