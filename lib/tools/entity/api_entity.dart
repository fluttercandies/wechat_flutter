import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class CodeRspEntity {
  CodeRspEntity({
    this.token,
    this.code,
    this.phone,
  });

  factory CodeRspEntity.fromJson(Map<String, dynamic>? json) => json == null
      ? CodeRspEntity()
      : CodeRspEntity(
          token: asT<String>(json['token']),
          code: asT<String>(json['code']),
          phone: asT<String>(json['phone']),
        );

  String? token;
  String? code;
  String? phone;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'token': token,
        'code': code,
        'phone': phone,
      };
}

class LoginRspEntity {
  LoginRspEntity({
    this.accessToken,
    this.expires,
    this.refreshToken,
  });

  factory LoginRspEntity.fromJson(Map<String, dynamic>? json) => json == null
      ? LoginRspEntity()
      : LoginRspEntity(
          accessToken: asT<String>(json['access_token']),
          expires: asT<int>(json['expires']),
          refreshToken: asT<String>(json['refresh_token']),
        );

  String? accessToken;
  int? expires;
  String? refreshToken;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'access_token': accessToken,
        'expires': expires,
        'refresh_token': refreshToken,
      };
}

class UserInfoRspEntity {
  UserInfoRspEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.location,
    this.title,
    this.description,
    this.tags,
    this.avatar,
    this.language,
    this.theme,
    this.tfaSecret,
    this.status,
    this.role,
    this.token,
    this.lastAccess,
    this.lastPage,
    this.provider,
    this.externalIdentifier,
    this.authData,
    this.emailNotifications,
    this.kid,
    this.mobile,
    this.nickname,
  });

  factory UserInfoRspEntity.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserInfoRspEntity();
    }

    final List<Object?>? tags = json['tags'] is List ? <Object?>[] : null;
    if (tags != null) {
      for (final dynamic item in json['tags']) {
        if (item != null) {
          tags.add(asT<Object>(item));
        }
      }
    }
    return UserInfoRspEntity(
      id: asT<String>(json['id']),
      firstName: asT<String>(json['first_name']),
      lastName: asT<String>(json['last_name']),
      email: asT<String>(json['email']),
      password: asT<String>(json['password']),
      location: asT<String>(json['location']),
      title: asT<String>(json['title']),
      description: asT<String>(json['description']),
      tags: tags,
      avatar: asT<String>(json['avatar']),
      language: asT<String>(json['language']),
      theme: asT<String>(json['theme']),
      tfaSecret: asT<String>(json['tfa_secret']),
      status: asT<String>(json['status']),
      role: asT<String>(json['role']),
      token: asT<String>(json['token']),
      lastAccess: asT<String>(json['last_access']),
      lastPage: asT<String>(json['last_page']),
      provider: asT<String>(json['provider']),
      externalIdentifier: asT<String>(json['external_identifier']),
      authData: asT<String>(json['auth_data']),
      emailNotifications: asT<bool>(json['email_notifications']),
      kid: asT<String>(json['kid']),
      mobile: asT<String>(json['mobile']),
      nickname: asT<String>(json['nickname']),
    );
  }

  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? location;
  String? title;
  String? description;
  List<Object?>? tags;
  String? avatar;
  String? language;
  String? theme;
  String? tfaSecret;
  String? status;
  String? role;
  String? token;
  String? lastAccess;
  String? lastPage;
  String? provider;
  String? externalIdentifier;
  String? authData;
  bool? emailNotifications;
  String? kid;
  String? mobile;
  String? nickname;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'location': location,
    'title': title,
    'description': description,
    'tags': tags,
    'avatar': avatar,
    'language': language,
    'theme': theme,
    'tfa_secret': tfaSecret,
    'status': status,
    'role': role,
    'token': token,
    'last_access': lastAccess,
    'last_page': lastPage,
    'provider': provider,
    'external_identifier': externalIdentifier,
    'auth_data': authData,
    'email_notifications': emailNotifications,
    'kid': kid,
    'mobile': mobile,
    'nickname': nickname,
  };
}
