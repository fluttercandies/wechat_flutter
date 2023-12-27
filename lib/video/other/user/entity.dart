import 'dart:convert';

import 'package:get/get.dart';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class UserInfoEntity {
  UserInfoEntity({
    required this.channel,
    required this.account,
    required this.uid,
    required this.platform,
    this.clienttype,
    required this.identity,
    required this.clientseq,
    this.deleteat,
    this.reason,
    required this.timestamp,
    required this.localuser,
  });

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) => UserInfoEntity(
        channel: asT<String>(json['channel'])!,
        account: asT<int>(json['account'])!,
        uid: asT<int>(json['uid'])!,
        platform: asT<int>(json['platform'])!,
        clienttype: asT<Object?>(json['clientType']),
        identity: asT<int>(json['identity'])!,
        clientseq: asT<int>(json['clientSeq'])!,
        deleteat: asT<Object?>(json['deleteAt']),
        reason: asT<Object?>(json['reason']),
        timestamp: asT<int>(json['timestamp'])!,
        localuser:
            Localuser.fromJson(asT<Map<String, dynamic>>(json['localUser'])!),
      );

  String channel;
  int account;
  int uid;
  int platform;
  Object? clienttype;
  int identity;
  int clientseq;
  Object? deleteat;
  Object? reason;
  int timestamp;
  Localuser localuser;
  RxBool isOpenCamera = true.obs;
  RxBool isOpenMicrophone = true.obs;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'channel': channel,
        'account': account,
        'uid': uid,
        'platform': platform,
        'clientType': clienttype,
        'identity': identity,
        'clientSeq': clientseq,
        'deleteAt': deleteat,
        'reason': reason,
        'timestamp': timestamp,
        'localUser': localuser,
      };
}

class Localuser {
  Localuser({
    required this.id,
    required this.username,
    required this.nickname,
    required this.avatar,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.status,
    required this.creationtime,
    required this.editiontime,
    required this.logintime,
  });

  factory Localuser.fromJson(Map<String, dynamic> json) => Localuser(
        id: asT<int>(json['id'])!,
        username: asT<String>(json['username'])!,
        nickname: asT<String>(json['nickname'])!,
        avatar: asT<String>(json['avatar'])!,
        email: asT<String>(json['email'])!,
        mobile: asT<String>(json['mobile'])!,
        gender: asT<String>(json['gender'])!,
        status: asT<String>(json['status'])!,
        creationtime: asT<int>(json['creationTime'])!,
        editiontime: asT<int>(json['editionTime'])!,
        logintime: asT<int>(json['loginTime'])!,
      );

  int id;
  String username;
  String nickname;
  String avatar;
  String email;
  String mobile;
  String gender;
  String status;
  int creationtime;
  int editiontime;
  int logintime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'nickname': nickname,
        'avatar': avatar,
        'email': email,
        'mobile': mobile,
        'gender': gender,
        'status': status,
        'creationTime': creationtime,
        'editionTime': editiontime,
        'loginTime': logintime,
      };
}
