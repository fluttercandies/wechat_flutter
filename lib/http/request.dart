import 'package:dio/dio.dart';

class Request {
  int connectTimeOut = 5 * 1000; //连接超时时间为5秒
  int receiveTimeOut = 7 * 1000; //响应超时时间为7秒

  String url() => null;

  BaseOptions options = new BaseOptions();
//  Options options = BaseOptions(
//    baseUrl: "https://www.xx.com/api",
//    connectTimeout: 5000,
//    receiveTimeout: 3000,
//  );
  Dio dio = Dio();

}
