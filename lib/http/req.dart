import 'package:dio/dio.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

var _id = 0;

typedef OnData(t);
typedef OnError(String msg, int code);

enum RequestType { GET, POST }

class Req {
  static Req _instance;

  ///连接超时时间为5秒
  static const int connectTimeOut = 5 * 1000;

  ///响应超时时间为7秒
  static const int receiveTimeOut = 7 * 1000;

  Dio _client;

  static Req getInstance() {
    if (_instance == null) {
      _instance = Req._internal();
    }
    return _instance;
  }

  Req._internal() {
    if (_client == null) {
      BaseOptions options = new BaseOptions();
      options.connectTimeout = connectTimeOut;
      options.receiveTimeout = receiveTimeOut;
      _client = new Dio(options);
    }
  }

  Dio get client => _client;

  ///get请求
  void get(
    String url,
    OnData callBack, {
    Map<String, String> params,
    OnError errorCallBack,
    CancelToken token,
  }) async {
    this._request(
      url,
      callBack,
      method: RequestType.GET,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
    );
  }

  //post请求
  void post(
    String url,
    OnData callBack, {
    Map<String, String> params,
    OnError errorCallBack,
    CancelToken token,
  }) async {
    this._request(
      url,
      callBack,
      method: RequestType.POST,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
    );
  }

  //post请求
  void postUpload(
    String url,
    OnData callBack,
    ProgressCallback progressCallBack, {
    FormData formData,
    OnError errorCallBack,
    CancelToken token,
  }) async {
    this._request(
      url,
      callBack,
      method: RequestType.POST,
      formData: formData,
      errorCallBack: errorCallBack,
      progressCallBack: progressCallBack,
      token: token,
    );
  }

  void _request(
    String url,
    OnData callBack, {
    RequestType method,
    Map<String, String> params,
    FormData formData,
    OnError errorCallBack,
    ProgressCallback progressCallBack,
    CancelToken token,
  }) async {
    final id = _id++;
    int statusCode;
    try {
      Response response;
      if (method == RequestType.GET) {
        ///组合GET请求的参数
        if (mapNoEmpty(params)) {
          response = await _client.get(url,
              queryParameters: params, cancelToken: token);
        } else {
          response = await _client.get(url, cancelToken: token);
        }
      } else {
        if (mapNoEmpty(params) || formData != null) {
          response = await _client.post(
            url,
            data: formData ?? params,
            onSendProgress: progressCallBack,
            cancelToken: token,
          );
        } else {
          response = await _client.post(url, cancelToken: token);
        }
      }

      statusCode = response.statusCode;

      if (response != null) {
        if (response.data is List) {
          Map data = response.data[0];
          callBack(data);
        } else {
          Map data = response.data;
          callBack(data);
        }
        print('HTTP_REQUEST_URL::[$id]::$url');
        print('HTTP_REQUEST_BODY::[$id]::${params ?? ' no'}');
        print('HTTP_RESPONSE_BODY::[$id]::${response.data}');
      }

      ///处理错误部分
      if (statusCode < 0) {
        _handError(errorCallBack, statusCode);
        return;
      }
    } catch (e) {
      _handError(errorCallBack, statusCode);
    }
  }

  ///处理异常
  static void _handError(OnError errorCallback, int statusCode) {
    String errorMsg = 'Network request error';
    if (errorCallback != null) {
      errorCallback(errorMsg, statusCode);
    }
    print("HTTP_RESPONSE_ERROR::$errorMsg code:$statusCode");
  }
}
