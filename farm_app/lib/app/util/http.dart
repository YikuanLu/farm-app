import 'dart:io';
// import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:farm_app/app/config/cinfig.dart';

class HttpUtil {
  static HttpUtil instance;
  BuildContext context;
  Dio dio;
  BaseOptions options;

  CancelToken cancelToken = new CancelToken();

  static HttpUtil getInstance(BuildContext context) {
    if (null == instance) instance = new HttpUtil(context);
    return instance;
  }

  /*
   * config it and create
   */
  HttpUtil(BuildContext context) {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    this.context = context;
    options = new BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: Api.baseUrl,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,
      //Http请求头.
      headers: {
        //do something
        "version": "1.0.0"
      },
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: ContentType.json,
      //表示期望以那种格式(方式)接受响应数据。接受三种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );

    dio = new Dio(options);

    //Cookie管理
    // dio.interceptors.add(CookieManager(CookieJar()));

    //添加拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("请求之前");
      // Do something before request is sent
      return options; //continue
    }, onResponse: (Response response) {
      print("响应之前");
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) {
      print("错误之前");
      print(e.response.data);
      // Do something with response error
      return e; //continue
    }));
  }

  /*
   * get请求
   */
  get(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');

//      response.data; 响应体
//      response.headers; 响应头
//      response.request; 请求体
//      response.statusCode; 状态码

    } on DioError catch (e) {
      print('get error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * post请求
   */
  post(url, {data, options, cancelToken}) async {
    // FormData formData = new FormData.from(data);
    Response response;
    try {
      /* response = await dio.post(
        url,
        queryParameters: data,
        options: options,
        cancelToken: cancelToken,
      ); */
      response = await dio.post(
        url,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      print('post success---------${response.data}');
    } on DioError catch (e) {
      print('post error---------$e');
      formatError(e);
    }
    return response.data;
  }

  // testPost(url, {data, options, cancelToken}) {
  //   print(data);
  // }

  /*
   * 下载文件
   */
  /* downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
      print('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    return response.data;
  } */

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    print("type=======${e.type}");
    String msg;
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      msg = "连接超时";
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      msg = "请求超时";
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      msg = "响应超时";
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      msg = e.response.data["message"];
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      msg = "请求取消";
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      msg = "网络异常";
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "提示",
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(msg),
        );
      },
    );
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
