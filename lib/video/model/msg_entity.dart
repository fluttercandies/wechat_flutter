import 'dart:convert' as convert;

import 'package:wechat_flutter/tools/wechat_flutter.dart';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class MsgEntity {
  MsgEntity({
    required this.type,
    required this.isMine,
    required this.content,
    // required this.specialMsg,
  });

  factory MsgEntity.fromJson(Map<String, dynamic> json) {
    final bool isHaveContent =
        json['content'] != null && json['content'] is String;
    return MsgEntity(
      type: asT<int>(json['type'])!,
      isMine: asT<int>(json['isMine'])!,
      content:
          // isHaveContent
          //     ? EMMessage.fromJson(Map.from(convert.json.decode(json['content'])))
          //     :
          null,
      // specialMsg: asT<String?>(json['specialMsg']),
    );
  }

  factory MsgEntity.no() => MsgEntity(
        type: 0,
        isMine: 1,
        content: null,
        // specialMsg: null,
      );

  String get textStringValue {
    String? textString;
    // if (type == 0) {
    //   textString = (content!.body as EMTextMessageBody).content;
    // } else if (type == 1 || type == 2) {
    //   EMImageMessageBody img = (content!.body as EMImageMessageBody);
    //   textString = strNoEmpty(img.remotePath) ? img.remotePath : img.localPath;
    // } else {
    //   textString = (content?.body as EMCustomMessageBody?)?.params?['content'];
    // }

    /// [specialMsg] 主要作用于显示：
    /// 1.对方无应答2.对方已拒绝3.对方已取消4.通话时长10:58
    // return specialMsg ?? textString ?? '';
    return textString ?? '';
  }

  /// 具体类型
  /// 0=text 1和2=image 3=语音通话 4=视频通话 5=修改群名
  int type;

  /// 1=是自己，2=不是自己
  int isMine;

  /// 消息具体内容
  final content; // EMMessage?

  /// 特殊消息内容
  // String? specialMsg;

  @override
  String toString() {
    return convert.jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'isMine': isMine,
        'content': convert.json.encode(content),
        // 'specialMsg': specialMsg,
      };
}
