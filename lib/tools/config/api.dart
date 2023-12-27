class ApiUrlV1 {
  static const nameUrl = 'https://www.apiopen.top/femaleNameApi';
  static const avatarUrl = 'http://www.lorempixel.com/200/200/';
  static const cat = 'https://api.thecatapi.com/v1/images/search';
  static const upImg = "http://111.230.251.115/oldchen/fUser/oneDaySuggestion";
  static const update = 'http://www.flutterj.com/api/update.json';
  static const uploadImg = 'http://www.flutterj.com/upload/avatar';
}

class ApiUrlV2 {
  /// 基础url
  static const baseUrl = "http://xxx.com";

  /// 注册
  static const register = baseUrl + '/passport/register';

  /// 获取短信
  static const smsGet = baseUrl + '/sms/get/';

  /// 获取自己的信息
  static const userMe = baseUrl + '/users/me';

  /// 登录
  static const login = baseUrl + '/auth/login';

  /// 获取腾讯云签名
  static const timGetSig = baseUrl + '/tim/get-sig';

  /// 搜索用户
  static const searchUser = baseUrl + '/users';

  /// 更新用户资料
  static const updateUserInfo = baseUrl + '/users/';

  /// 上传图片
  static const uploadFile = baseUrl + '/files';

  /// 更新图片
  static const fileChange = baseUrl + '/files/';

  /// 刷新Token
  static const authRefresh = baseUrl + '/auth/refresh';
}
