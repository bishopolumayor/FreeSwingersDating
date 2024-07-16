import 'package:free_swingers_dating/data/api/api_client.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> getTotalUsers() async {
    return await apiClient.getData(AppConstants.TOTAL_USERS_URI);
  }

  Future<Response> signUp(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.SIGN_UP_URI, data);
  }

  Future<Response> login(Map<String, dynamic> data, bool rememberMe) async {
    await sharedPreferences.setBool(AppConstants.REMEMBER_KEY, rememberMe);
    return await apiClient.postData(AppConstants.LOGIN_URI, data);
  }

  Future<void> setToken(String newToken) async {
    apiClient.updateHeader(newToken);
    await sharedPreferences.setString(AppConstants.TOKEN, newToken);
  }

  Future<bool> getRememberMeStatus() async {
    return sharedPreferences.getBool(AppConstants.REMEMBER_KEY) ?? false;
  }

  Future<void> clearAllData() async {
    await sharedPreferences.clear();
  }

}