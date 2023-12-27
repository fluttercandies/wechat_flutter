/// 【单聊】不显示版消息事件
/// 用于隐形通知
enum LiveMsgEventSingleHide {
  // 发送通话
  senderSend,
  // 发起人取消通话
  senderCancel,
  // 拒绝通话
  receiverReject,
  // 接听通话
  receiverReceive,
  // 正忙
  receiverBusy,
  // 挂断通话【已接通之后挂断】
  bothHangUp,
  // 音视频通话消息
  liveMsg,
}

/// 【单聊】显示版消息事件
/// 用于消息内容展示
enum LiveMsgEventSingleShow {
  // 无应答
  noRsp,
  // 已拒绝
  rejected,
  // 已取消
  canceled,
  // 对方正忙
  busy,
  // 正常=显示 "通话时长10:58"
  normal,
}

/// 【群聊】不显示版消息事件
/// 用于隐形通知
enum LiveMsgEventMultipleHide {
  // 发送通话
  send,
  // 取消通话
  cancel,
}

/// 【群聊】显示版消息事件
/// 用于消息内容展示
enum LiveMsgEventMultipleShow {
  // 发起了通话
  launched,
  // 已结束
  closed,
}
