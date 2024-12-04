class IContactInfoEntity {
  String? identifier;
  int? addTime;
  String? addSource;
  String? addWording;
  IContactInfoProfile? profile;
  List<Null>? groups;
  String? remark;
  IContactInfoCustominfo? customInfo;

  IContactInfoEntity({
    this.identifier,
    this.addTime,
    this.addSource,
    this.addWording,
    this.profile,
    this.groups,
    this.remark,
    this.customInfo,
  });

  IContactInfoEntity.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    addTime = json['addTime'];
    addSource = json['addSource'];
    addWording = json['addWording'];
    profile = json['profile'] != null
        ? IContactInfoProfile.fromJson(json['profile'])
        : null;
    if (json['groups'] != null) {
      groups = <Null>[];
    }
    remark = json['remark'];
    customInfo = json['customInfo'] != null
        ? IContactInfoCustominfo.fromJson(json['customInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    data['addTime'] = addTime;
    data['addSource'] = addSource;
    data['addWording'] = addWording;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (groups != null) {
      data['groups'] = [];
    }
    data['remark'] = remark;
    if (customInfo != null) {
      data['customInfo'] = customInfo!.toJson();
    }
    return data;
  }
}

class IContactInfoProfile {
  int? birthday;
  String? faceURL;
  String? identifier;
  int? role;
  int? gender;
  int? level;
  String? nickname;
  int? language;
  IContactInfoProfileCustominfo? customInfo;
  int? allowType;

  IContactInfoProfile({
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

  IContactInfoProfile.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    faceURL = json['faceURL'];
    identifier = json['identifier'];
    role = json['role'];
    gender = json['gender'];
    level = json['level'];
    nickname = json['nickname'];
    language = json['language'];
    customInfo = json['customInfo'] != null
        ? IContactInfoProfileCustominfo.fromJson(json['customInfo'])
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

class IContactInfoProfileCustominfo {
  IContactInfoProfileCustominfo.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class IContactInfoCustominfo {
  IContactInfoCustominfo.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}