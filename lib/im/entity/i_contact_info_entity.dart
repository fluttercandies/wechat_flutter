class IContactInfoEntity {
  String identifier;
  int addTime;
  String addSource;
  String addWording;
  IContactInfoProfile profile;
  List<Null> groups;
  String remark;
  IContactInfoCustominfo customInfo;

  IContactInfoEntity(
      {this.identifier,
      this.addTime,
      this.addSource,
      this.addWording,
      this.profile,
      this.groups,
      this.remark,
      this.customInfo});

  IContactInfoEntity.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    addTime = json['addTime'];
    addSource = json['addSource'];
    addWording = json['addWording'];
    profile = json['profile'] != null
        ? new IContactInfoProfile.fromJson(json['profile'])
        : null;
    if (json['groups'] != null) {
      groups = new List<Null>();
    }
    remark = json['remark'];
    customInfo = json['customInfo'] != null
        ? new IContactInfoCustominfo.fromJson(json['customInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['addTime'] = this.addTime;
    data['addSource'] = this.addSource;
    data['addWording'] = this.addWording;
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    if (this.groups != null) {
      data['groups'] = [];
    }
    data['remark'] = this.remark;
    if (this.customInfo != null) {
      data['customInfo'] = this.customInfo.toJson();
    }
    return data;
  }
}

class IContactInfoProfile {
  int birthday;
  String faceURL;
  String identifier;
  int role;
  int gender;
  int level;
  String nickname;
  int language;
  IContactInfoProfileCustominfo customInfo;
  int allowType;

  IContactInfoProfile(
      {this.birthday,
      this.faceURL,
      this.identifier,
      this.role,
      this.gender,
      this.level,
      this.nickname,
      this.language,
      this.customInfo,
      this.allowType});

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
        ? new IContactInfoProfileCustominfo.fromJson(json['customInfo'])
        : null;
    allowType = json['allowType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this.birthday;
    data['faceURL'] = this.faceURL;
    data['identifier'] = this.identifier;
    data['role'] = this.role;
    data['gender'] = this.gender;
    data['level'] = this.level;
    data['nickname'] = this.nickname;
    data['language'] = this.language;
    if (this.customInfo != null) {
      data['customInfo'] = this.customInfo.toJson();
    }
    data['allowType'] = this.allowType;
    return data;
  }
}

class IContactInfoProfileCustominfo {
  IContactInfoProfileCustominfo.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class IContactInfoCustominfo {
  IContactInfoCustominfo.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
