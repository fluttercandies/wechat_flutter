import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class LoginRspEntity {
  LoginRspEntity({
    required this.MAIN,
    required this.EASEMOB,
  });

  factory LoginRspEntity.fromJson(Map<String, dynamic> json) => LoginRspEntity(
        MAIN: Main.fromJson(asT<Map<String, dynamic>>(json['MAIN'])!),
        EASEMOB: Easemob.fromJson(asT<Map<String, dynamic>>(json['EASEMOB'])!),
      );

  Main MAIN;
  Easemob EASEMOB;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'MAIN': MAIN,
        'EASEMOB': EASEMOB,
      };
}

class Main {
  Main({
    required this.id,
    required this.username,
    required this.nickname,
    required this.avatar,
    required this.email,
    required this.mobile,
    required this.inviteBy,
    required this.invitationCode,
    required this.invitationCodeRequirement,
    required this.status,
    required this.creationTime,
    required this.editionTime,
    required this.loginTime,
    required this.authorizationToken,
    required this.genderCode,
    required this.telCountryCode,
    required this.country,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        id: asT<int>(json['id'])!,
        username: asT<String>(json['username'])!,
        nickname: asT<String?>(json['nickname']),
        avatar: asT<String>(json['avatar'])!,
        email: asT<String>(json['email'])!,
        mobile: asT<String>(json['mobile'])!,
        inviteBy: asT<int>(json['inviteBy'])!,
        invitationCode: asT<String>(json['invitationCode'])!,
        invitationCodeRequirement: asT<int>(json['invitationCodeRequirement'])!,
        status: asT<String>(json['status'])!,
        creationTime: asT<int>(json['creationTime'])!,
        editionTime: asT<int>(json['editionTime'])!,
        loginTime: asT<int>(json['loginTime'])!,
        authorizationToken: asT<String>(json['authorizationToken'])!,
        genderCode: asT<String>("${json['genderCode'] ?? 1}")!,
        telCountryCode: asT<String>(json['telCountryCode'] ?? '')!,
        country: asT<String>(json['country'] ?? '')!,
      );

  int id;
  String username;
  String? nickname;
  String avatar;
  String email;
  String mobile;
  int inviteBy;
  String invitationCode;
  int invitationCodeRequirement;
  String status;
  int creationTime;
  int editionTime;
  int loginTime;
  String authorizationToken;
  String telCountryCode;
  String country;

  // 1, 2, 127 为性别(男, 女, 保密)
  String genderCode;

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
        'inviteBy': inviteBy,
        'invitationCode': invitationCode,
        'invitationCodeRequirement': invitationCodeRequirement,
        'status': status,
        'creationTime': creationTime,
        'editionTime': editionTime,
        'loginTime': loginTime,
        'authorizationToken': authorizationToken,
        'genderCode': genderCode,
        'telCountryCode': telCountryCode,
        'country': country,
      };
}

class Easemob {
  Easemob({
    required this.username,
    required this.token,
    required this.expireIn,
  });

  factory Easemob.fromJson(Map<String, dynamic> json) => Easemob(
        username: asT<String>(json['username'])!,
        token: asT<String>(json['token'])!,
        expireIn: asT<int>(json['expireIn'])!,
      );

  String username;
  String token;
  int expireIn;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'token': token,
        'expireIn': expireIn,
      };
}
