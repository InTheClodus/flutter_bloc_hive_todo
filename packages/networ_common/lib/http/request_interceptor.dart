import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:networ_common/http/sp.dart';
import 'app_exceptions.dart';

/// 请求处理拦截器
class RequestInterceptor extends Interceptor {
  onRequest(options, handle) {
    debugPrint(
        '======================\n*** Request *** \nData:\n ${options.data.toString()} \nQuery:\n ${options.queryParameters.toString()} \n======================');
    // 设置cookie
    // var cookie = SpUtil.getStringList('cookie'); ////登录时保存cookie
    //
    // if (options.path != 'api/auth/login' &&
    //     cookie != null &&
    //     cookie.length > 0) {
    //   options.headers['cookie'] = cookie;//这里就是除了登录的情况其他都加cookie
    // }
    // options.headers['User-Agent'] = 'gzzoc-1';//
    //
    // if (options.data?.runtimeType == FormData) {
    //   options.headers['content-type'] = 'multipart/form-data';//FormData这种情况改content-type
    // }

    // 加载动画----这个就是请求页面时的那个loading窗 --处理逻辑 我是用options?.data['showLoading']或options?.queryParameters['showLoading'],
    //就是我们在传参的时候多加一个参数，这个因为前人就这样做的，也跟后端约定的，后端见showLoading不做处理。这样不是很好，反正options是有其他字段加的
    // if (options.data?.runtimeType == FormData) {
    //   // Alert.showLoading();
    //
    // } else if ((options.data != null &&
    //         false == options.data['showLoading']) ||
    //     (options.queryParameters != null &&
    //         false == options.queryParameters['showLoading'])) {
    //   // 不显示加载动画
    // } else {
    //   // Alert.showLoading();
    //   BotToast.closeAllLoading();
    // }
    ///在这做请求时显不显示Loading的处理
    ///
    BotToast.showLoading();
    Future.delayed(const Duration(seconds: 2), () {
      BotToast.closeAllLoading();
    });
    handle.next(options);
    //return super.onRequest(options);
  }

  @override
  onResponse(response, handle) {
    debugPrint(
        '======================\n*** Response *** \n${response.toString()}');
    if (response.data != null &&
        response.data is Map &&
        response.data['code'] == 1) {
      // 这个条件也是根据自己情况加的
      ///    Alert.hide();请求成功后关闭loading窗

      // 登录请求
      if (response.requestOptions.path == 'api/auth/login') {
        // 缓存cookie
        var cookie = response.headers['set-cookie'];
        //   SpUtil.putStringList('cookie', cookie!);缓存cookie
      }
      handle.next(response);
      //     return super.onResponse(response);
    } else if (response.requestOptions.path ==
            'api/auth/login' && // 登录登录成功, 但没有默认就诊人// 缓存cookie以便后续创建默认就诊人（需求）
        response.data != null &&
        response.data is Map &&
        response.data['code'] == '11') {
      // 缓存cookie
      var cookie = response.headers['set-cookie'];
      //    SpUtil.putStringList('cookie', cookie!);

      //     Alert.hide();
      handle.next(response);
    } else {
      handle.reject(DioError(
          requestOptions: response.requestOptions,
          error: response.data != null &&
                  response.data is Map &&
                  response.data['msg'] != null &&
                  response.data['msg'].length > 0
              ? response.data['msg']
              : '未知错误',
          response: response));
    }
  }

  @override
  onError(err, handle) {
    // Alert.hide();关闭弹窗

    // 账户登录异常
    if (err.response != null &&
        err.response?.data != null &&
        err.response?.data is Map &&
        err.response?.data != null &&
        err.response?.data['code'] == '2') {
      // Alert.showAlert(
      //   message: err.message ?? '未知错误',
      //   showCancel: false,
      //   onConfirm: () {
      //     // 清除账号缓存
      //     SpUtil.putString("account_phone", '');
      //     SpUtil.putString("account_password", '');
      //     SpUtil.putObject("account", '');
      //
      //     // 退出到登录页面
      //     //  push(Routes.login, replace: true, clearStack: true);
      //   },
      // );
    } else {
      //    Alert.showAlert(message: err.message ?? '未知错误', showCancel: false);//在页面显示一个错误弹窗
    }
    AppException appException = AppException.create(err);
    err.error = appException;
    return super.onError(err, handle);
  }
}
