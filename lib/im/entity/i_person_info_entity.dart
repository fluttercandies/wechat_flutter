class IPersonInfoEntity {
  String? identifier;
  String? nickname;
  String? faceURL;
  int? gender;
  int? birthday;
  String? signature;
  int? role;
  int? level;
  int? allowType;
  int? language;
  int? location;
  String? selfSignature;
  int? friendAddTime;
  int? lastUpdatedTime;

  IPersonInfoEntity({
    this.identifier,
    this.nickname,
    this.faceURL,
    this.gender,
    this.birthday,
    this.signature,
    this.role,
    this.level,
    this.allowType,
    this.language,
    this.location,
    this.selfSignature,
    this.friendAddTime,
    this.lastUpdatedTime,
  });

  IPersonInfoEntity.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    nickname = json['nickname'];
    faceURL = json['faceURL'];
    gender = json['gender'];
    birthday = json['birthday'];
    signature = json['signature'];
    role = json['role'];
    level = json['level'];
    allowType = json['allowType'];
    language = json['language'];
    location = json['location'];
    selfSignature = json['selfSignature'];
    friendAddTime = json['friendAddTime'];
    lastUpdatedTime = json['lastUpdatedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    data['nickname'] = nickname;
    data['faceURL'] = faceURL;
    data['gender'] = gender;
    data['birthday'] = birthday;
    data['signature'] = signature;
    data['role'] = role;
    data['level'] = level;
    data['allowType'] = allowType;
    data['language'] = language;
    data['location'] = location;
    data['selfSignature'] = selfSignature;
    data['friendAddTime'] = friendAddTime;
    data['lastUpdatedTime'] = lastUpdatedTime;
    return data;
  }
}