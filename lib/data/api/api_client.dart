import 'package:flutter/foundation.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;

  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    _mainHeaders = {
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Authorization': 'Bearer $token',
    };

    sharedPreferences.setString(AppConstants.TOKEN, token);

    if (kDebugMode) {
      print('update header called for $token');
    }
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    if (kDebugMode) {
      print('getting ${AppConstants.BASE_URL}$uri');
    }
    try {
      Response response = await get(uri, headers: headers ?? _mainHeaders);
      if (kDebugMode) {
        print("get response : ${response.body}");
      }
      return response;
    } catch (e) {
      return Response(
        statusCode: 1,
        statusText: e.toString(),
      );
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    if (kDebugMode) {
      print('posting ${AppConstants.BASE_URL}$uri $body');
    }
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      if (kDebugMode) {
        print("post response : ${response.body}");
      }

      // ApiChecker.checkApi(response);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('from api post client');
        print(e.toString());
      }
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {

      Response response = await put(uri, body, headers: headers ?? _mainHeaders);
      if (kDebugMode) {
        print("put response : ${response.body}");
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('from api put client');
        print(e.toString());
      }
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String uri,  {Map<String, String>? headers}) async {
    try {
      Response response = await delete(uri,  headers: headers ?? _mainHeaders);
      if (kDebugMode) {
        print("delete response : ${response.body}");
      }
      return response;
    } catch(e){
      return Response(
        statusCode: 1,
        statusText: e.toString(),
      );
    }
  }

}