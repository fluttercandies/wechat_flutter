/*
* 实体类 - 个人信息
* @param birthday 生日
* @param identifier 用户ID
* @param role 角色
* @param gender 性别
* @param level 等级
* @param nickName 昵称
* @param language 语言
* @param customInfo 习俗信息
* @param selfSignature 自己的签名
* @param allowType 添加我的方式
* @param faceUrl 头像
* @param location 位置
* @param customInfoUint 自定义信息单元
*
* */
class PersonInfoEntity {
  int birthday;
  String identifier;
  int role;
  int gender;
  int level;
  String nickName;
  int language;
  PersonInfoCustominfo customInfo;
  String selfSignature;
  dynamic allowType;
  String faceUrl;
  String location;
  PersonInfoCustominfouint customInfoUint;

  PersonInfoEntity(
      {this.birthday,
      this.identifier,
      this.role,
      this.gender,
      this.level,
      this.nickName,
      this.language,
      this.customInfo,
      this.selfSignature,
      this.allowType,
      this.faceUrl,
      this.location,
      this.customInfoUint});

  PersonInfoEntity.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    identifier = json['identifier'];
    role = json['role'];
    gender = json['gender'];
    level = json['level'];
    nickName = json['nickName'];
    language = json['language'];
    customInfo = json['customInfo'] != null
        ? new PersonInfoCustominfo.fromJson(json['customInfo'])
        : null;
    selfSignature = json['selfSignature'];
    allowType = json['allowType'];
    faceUrl = json['faceUrl'];
    location = json['location'];
    customInfoUint = json['customInfoUint'] != null
        ? new PersonInfoCustominfouint.fromJson(json['customInfoUint'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this.birthday;
    data['identifier'] = this.identifier;
    data['role'] = this.role;
    data['gender'] = this.gender;
    data['level'] = this.level;
    data['nickName'] = this.nickName;
    data['language'] = this.language;
    if (this.customInfo != null) {
      data['customInfo'] = this.customInfo.toJson();
    }
    data['selfSignature'] = this.selfSignature;
    data['allowType'] = this.allowType;
    data['faceUrl'] = this.faceUrl;
    data['location'] = this.location;
    if (this.customInfoUint != null) {
      data['customInfoUint'] = this.customInfoUint.toJson();
    }
    return data;
  }
}

class PersonInfoCustominfo {
  PersonInfoCustominfo.fromJson(Map<String, dynamic> json) ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class PersonInfoCustominfouint {
  PersonInfoCustominfouint.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
