class PersonInfoEntity {
  String? identifier;
  String? nickName;
  String? faceUrl;
  int? gender;
  int? birthday;
  String? signature;
  int? role;
  int? level;
  String? allowType;
  int? language;
  int? location;
  String? selfSignature;
  int? friendAddTime;
  int? lastUpdatedTime;

  PersonInfoEntity({
    this.identifier,
    this.nickName,
    this.faceUrl,
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

  PersonInfoEntity.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    nickName = json['nickName'];
    faceUrl = json['faceUrl'];
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
    data['nickName'] = nickName;
    data['faceUrl'] = faceUrl;
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