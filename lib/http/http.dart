import 'package:dio/dio.dart';

typedef OnData(t);
typedef OnError(String msg, int code);

class Request {
  static const int CONNECT_TIMEOUT = 1 * 1000;//连接超时时间为5秒
  static const int RECEIVE_TIMEOUT = 3 * 1000;//响应超时时间为7秒

  Dio _client;

  BaseOptions options = new BaseOptions();

//  Options options = BaseOptions(
//    baseUrl: "https://www.xx.com/api",
//    connectTimeout: 5000,
//    receiveTimeout: 3000,
//  );
  Dio dio = Dio();
}
