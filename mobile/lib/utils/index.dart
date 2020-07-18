import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobile/constrants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String link) async {
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Could not launch $link';
  }
}

String formatDateStringWithFormat({String d, String format = "yyyy-MM-dd"}) {
  final DateFormat formatter = DateFormat(format);
  final String formatted = formatter.format(DateFormat("dd-MM-yyyy").parse(d));
  return formatted;
}

String formatDate(DateTime d) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(d);
  return formatted;
}

Future<bool> setPref(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString(key, value);
}

Future<String> getPref(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool> setFCMToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('FCMToken', value);
}

Future<String> getFCMToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('FCMToken');
}

Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('token', value);
}

Future<String> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    print(
        "REQUEST[${options?.method}] => PATH: ${options?.path} HEADER: ${options.headers.toString()}");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    print(
        "RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    return super.onError(err);
  }
}

// or new Dio with a BaseOptions instance.

class MyRequest {
  static BaseOptions options = new BaseOptions(
    baseUrl: DEV_SERVER_API,
    headers: {
      Headers.contentTypeHeader: "application/json",
    },
  );
  Dio _inner;
  MyRequest() {
    _inner = new Dio(options);
    _inner.interceptors.add(CustomInterceptors());
  }

  Dio get request {
    return _inner;
  }

  set setToken(token) {
    options.headers["Authorization"] = "Bearer $token";
  }
}

final requestObj = new MyRequest();
final request = requestObj.request;
