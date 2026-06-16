import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../../app/features/auth/login/view/get_started_screen.dart';
import '../../app/features/auth/login/view/login_screen.dart';
import '../../main.dart';
import '../../utils/app_log.dart';
import '../../utils/app_prompt.dart';
import '../../utils/app_utils.dart';
import '../../utils/shared_preferences.dart';
import 'network_urls.dart';
import 'package:get/get.dart' as getX;



class NetworkService {
  static final NetworkService _service = NetworkService._internal();
  NetworkService._internal();

  factory NetworkService() {
    return _service;
  }

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: NetworkUrl.baseUrl,
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 40),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sp!.getString(SpUtil.accessToken) ?? ""}',
        'language': sp!.getString(SpUtil.languageCode) ?? "en",
      },
    ),
  );

  // ── Add this helper method ─────────────────────────────────────────
   void refreshHeaders() {
    dio.options.headers["Authorization"] = "Bearer ${sp!.getString(SpUtil.accessToken) ?? ''}";
    dio.options.headers["language"] = sp!.getString(SpUtil.languageCode) ?? 'en';
  }

  Future<void> initRepo() async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          AppLog.printLog("onRequest::: Api Uri ->> ${options.uri}");
          AppLog.printLog("onRequest::: Api Headers ->> ${options.headers}");
          AppLog.printLog("onRequest::: Post Data ->> ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          AppLog.printLog("onResponse::: Api Uri ->> ${response.realUri}");
          AppLog.printLog("onResponse::: Status Code ->> ${response.statusCode}");
          AppLog.printLog("onResponse::: Get Data ->> ${json.encode(response.data)}");
          return handler.next(response);
        },
        onError: (options, handler) async {
          AppLog.printLog("onError::: Error ->> ${options.toString()}");
          return handler.next(options);
        },
      ),
    );
  }

  Future<dynamic> getApiCall({required String url}) async {
    bool internetAvailable = await isInternetAvailable();
    dynamic responseJson;
    try {
      if (internetAvailable) {
        String? accessToken = sp!.getString(SpUtil.accessToken);
        dio.options.headers["Authorization"] = "Bearer $accessToken";
        Response response = await dio.get(url);
        responseJson = response.data;
      } else {
        showAppToast(
          isForError: true,
          msg: 'Please turn your internet connection and try again',
        );
      }
      return responseJson;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> postApiCall(
      {required String url, required body}) async {
    bool internetAvailable = await isInternetAvailable();
    dynamic responseJson;
    try {
      if (internetAvailable) {
        String? accessToken = sp!.getString(SpUtil.accessToken);
        dio.options.headers["Authorization"] = "Bearer $accessToken";
        AppLog.printLog("Post Body ->> ${body.toString()}");
        Response response = await dio.post(url, data: body);
        responseJson = response.data;
      } else {
        showAppToast(
          isForError: true,
          msg: 'Please turn your internet connection and try again',
        );      }
      return responseJson;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> putApiCall({required String url, required body}) async {
    bool internetAvailable = await isInternetAvailable();
    dynamic responseJson;
    try {
      if (internetAvailable) {
        String? accessToken = sp!.getString(SpUtil.accessToken);
        dio.options.headers["Authorization"] = "Bearer $accessToken";
        AppLog.printLog("Put Body ->> ${body.toString()}");
        Response response = await dio.put(url, data: body);
        responseJson = response.data;
      } else {
        showAppToast(
          isForError: true,
          msg: 'Please turn your internet connection and try again',
        );      }
      return responseJson;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> patchApiCall({required String url, required body}) async {
    bool internetAvailable = await isInternetAvailable();
    dynamic responseJson;
    try {
      if (internetAvailable) {
        String? accessToken = sp!.getString(SpUtil.accessToken);
        dio.options.headers["Authorization"] = "Bearer $accessToken";
        AppLog.printLog("Patch Body ->> ${body.toString()}");
        Response response = await dio.patch(url, data: body);
        responseJson = response.data;
      } else {
        showAppToast(
          isForError: true,
          msg: 'Please turn your internet connection and try again',
        );      }
      return responseJson;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> deleteApiCall({
    required String url,
  }) async {
    bool internetAvailable = await isInternetAvailable();
    dynamic responseJson;
    try {
      if (internetAvailable) {
        String? accessToken = sp!.getString(SpUtil.accessToken);
        dio.options.headers["Authorization"] = "Bearer $accessToken";
        Response response = await dio.delete(url);
        responseJson = response.data;
      } else {
        showAppToast(
          isForError: true,
          msg: 'Please turn your internet connection and try again',
        );      }
      return responseJson;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> deleteApiCallBody(
      {required String url, required body}) async {
    bool internetAvailable = await isInternetAvailable();
    dynamic responseJson;
    try {
      if (internetAvailable) {
        String? accessToken = sp!.getString(SpUtil.accessToken);
        dio.options.headers["Authorization"] = "Bearer $accessToken";
        Response response = await dio.delete(url, data: body);
        AppLog.printLog("Get Body ->> ${json.encode(response.data)}");
        responseJson = response.data;
      } else {
        showAppToast(
          isForError: true,
          msg: 'Please turn your internet connection and try again',
        );      }
      return responseJson;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }


  String _handleDioError(DioException e) {
    AppLog.printLog("Dio Exception Message ->> ${e.message.toString()}");
    String errorMsg = "Something went wrong. Please try again.";

    if (e.type == DioExceptionType.connectionTimeout) {
      errorMsg = "Connection Timeout. Please try again.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      errorMsg = "Receive Timeout. Please try again.";
    } else if (e.response != null) {
      AppLog.printLog("Dio Exception Data ->> ${e.response!.data!.toString()}");

      final data = e.response?.data;
      if (data != null && data is Map) {
        errorMsg =
            data['msg']?.toString() ?? e.response?.statusMessage ?? errorMsg;

        // Handle specific status codes/msgCodes
        if (e.response?.statusCode == 401) {
          AppUtils.logOut();
          getX.Get.to(() => GetStartedScreen());
        } else if (e.response?.statusCode == 400) {
          String msgCode = data['msgCode']?.toString() ?? "";

        } else if (e.response?.statusCode == 500) {
          AppLog.printLog("Dio Exception Data 500 Code");
        }
      } else {
        errorMsg = e.response?.statusMessage ?? errorMsg;
      }
    } else if (e.message != null) {
      errorMsg = e.message!;
    }

    AppLog.printLog("Dio Exception Final Msg ->> $errorMsg");
    return errorMsg;
  }


/*  String _handleDioError(DioException e) {
    AppLog.printLog("Dio Exception Message ->> ${e.message.toString()}");
    AppLog.printLog("Dio Exception Data ->> ${e.response!.data!.toString()}");
    AppLog.printLog("Dio Exception Messages ->> ${e.response?.data?['msg'].toString()}");
    String errorMsg = "Something went wrong, please try again.";

    if (e.type == DioExceptionType.connectionTimeout) {
      errorMsg = "Connection Timeout. Please try again.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      errorMsg = "Receive Timeout. Please try again.";
    } else if (e.response?.statusCode == 401) {
      //Handle token expiration / unauthorized
      AppUtils.logOut();
      getX.Get.offAll(LoginScreen());

      errorMsg = "Session expired. Please login again.";
    } else if (e.response?.statusCode == 400) {
      String msgCode = data['msgCode']?.toString() ?? "";
      if (msgCode == "2003") {
        // deactivate case
        getX.Get.offAllNamed(
          Routes.deactivateScreen,
          arguments: {
            'status': 'deactivated',
            'message': data['msg']?.toString() ?? 'Your account has been deactivated',
          },
        );
      }else if(msgCode == "1013"){
        // delete user case
        getX.Get.offAllNamed(
          Routes.deactivateScreen,
          arguments: {
            'status': 'deleted',
            'message': data['msg']?.toString() ?? 'Your account has been deleted',
          },
        );
      }
    } else if (e.response?.statusCode == 500) {
      AppLog.printLog("Dio Exception Data 500 Code");
    }else if (e.response?.data != null) {
      errorMsg = e.response?.data['msg']?.toString() ??
          e.response?.statusMessage ??
          errorMsg;
    } else if (e.message != null) {
      errorMsg = e.message!;
    }

    AppLog.printLog("Dio Exception ->> $errorMsg");

    return errorMsg;
  }*/




  Future<bool> isInternetAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult.any((result) =>
    result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.other);
  }
}
