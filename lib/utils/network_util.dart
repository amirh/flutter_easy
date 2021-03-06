import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:session/session.dart';

import '../utils/loading_util.dart';
import '../utils/logger_util.dart';

export 'package:session/session.dart';

typedef _ResultCallBack = Result Function<T>(
    Result result, bool validResult, BuildContext context);

class NetworkUtil {
  NetworkUtil._();

  static init(Session session, {_ResultCallBack onResult}) {
    _session = session;
    _onResult = onResult;
  }
}

Session _session;

_ResultCallBack _onResult;

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// <T>: 要解析的实体类名(需要自动转换时必须要加)
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// queryParameters: URL携带请求参数
/// validResult: 是否检验返回结果
/// context: 上下文
/// autoLoading: 展示Loading
///
Future<Result> get<T>(
    {String baseUrl,
    String path = '',
    Map data,
    Map<String, dynamic> queryParameters,
    bool validResult = true,
    BuildContext context,
    bool autoLoading = false}) async {
  return request<T>(
      baseUrl: baseUrl,
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: Options(method: 'get'),
      validResult: validResult,
      context: context,
      autoLoading: autoLoading);
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// <T>: 要解析的实体类名(需要自动转换时必须要加)
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// validResult: 是否检验返回结果
/// context: 上下文
/// autoLoading: 展示Loading
///
Future<Result> post<T>(
    {String baseUrl,
    String path = '',
    Map data,
    bool validResult = true,
    BuildContext context,
    bool autoLoading = false}) async {
  return request<T>(
      baseUrl: baseUrl,
      path: path,
      data: data,
      options: Options(method: 'post'),
      validResult: validResult,
      context: context,
      autoLoading: autoLoading);
}

///
/// 发送请求并解析远程服务器返回的result对应的实体类型
///
/// <T>: 要解析的实体类名(需要自动转换时必须要加)
/// baseUrl: 主机地址
/// path: 请求路径
/// data: 请求参数
/// validResult: 是否检验返回结果
/// context: 上下文
/// autoLoading: 展示Loading
///
Future<Result> request<T>(
    {String baseUrl,
    String path = '',
    Map data,
    Map<String, dynamic> queryParameters,
    Options options,
    bool validResult = true,
    BuildContext context,
    bool autoLoading = false}) async {
  // Loading is show
  bool alreadyShowLoading = false;
  if (autoLoading && context != null) {
    try {
      showLoading(context);
      alreadyShowLoading = true;
    } catch (e) {
      log('showLoading(); error:', e.toString());
    }
  }
  Session session = Session(
      config: Config(
          baseUrl:
              baseUrl?.isNotEmpty == true ? baseUrl : _session.config.baseUrl,
          proxy: _session.config.proxy,
          badCertificateCallback: _session.config.badCertificateCallback,
          connectTimeout: _session.config.connectTimeout,
          receiveTimeout: _session.config.receiveTimeout,
          code: _session.config.code,
          data: _session.config.data,
          list: _session.config.list,
          message: _session.config.message,
          validCode: _session.config.validCode,
          errorTimeout: _session.config.errorTimeout,
          errorResponse: _session.config.errorResponse,
          errorCancel: _session.config.errorCancel,
          errorOther: _session.config.errorOther),
      onRequest: _session.onRequest,
      onResult: validResult ? _session.onResult : null);
  Result result = await session.request(path,
      data: data, queryParameters: queryParameters, options: options);
  if (autoLoading && alreadyShowLoading) {
    // Dismiss loading
    dismissLoading(context);
  }
  return _onResult != null
      ? _onResult<T>(result, validResult, context)
      : result;
}
