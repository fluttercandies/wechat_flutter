class IChatPersonEntity {
  int? birthday;
  String? faceURL;
  String? identifier;
  int? role;
  int? gender;
  int? level;
  String? nickname;
  int? language;
  IChatPersonCustominfo? customInfo;
  dynamic allowType;

  IChatPersonEntity({
    this.birthday,
    this.faceURL,
    this.identifier,
    this.role,
    this.gender,
    this.level,
    this.nickname,
    this.language,
    this.customInfo,
    this.allowType,
  });

  IChatPersonEntity.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    faceURL = json['faceURL'];
    identifier = json['identifier'];
    role = json['role'];
    gender = json['gender'];
    level = json['level'];
    nickname = json['nickname'];
    language = json['language'];
    customInfo = json['customInfo'] != null
        ? IChatPersonCustominfo.fromJson(json['customInfo'])
        : null;
    allowType = json['allowType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['birthday'] = birthday;
    data['faceURL'] = faceURL;
    data['identifier'] = identifier;
    data['role'] = role;
    data['gender'] = gender;
    data['level'] = level;
    data['nickname'] = nickname;
    data['language'] = language;
    if (customInfo != null) {
      data['customInfo'] = customInfo!.toJson();
    }
    data['allowType'] = allowType;
    return data;
  }
}

class IChatPersonCustominfo {
  IChatPersonCustominfo.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}