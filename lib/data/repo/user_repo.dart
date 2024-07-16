import 'dart:convert';

import 'package:free_swingers_dating/data/api/api_client.dart';
import 'package:free_swingers_dating/models/user_model.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  UserRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<void> saveUser(UserModel user) async {
    String userJson = json.encode(user.toJson());
    await sharedPreferences.setString(AppConstants.USER_KEY, userJson);
  }

  Future<void> saveSelectedUser(UserModel user) async {
    String userJson = json.encode(user.toJson());
    await sharedPreferences.setString(AppConstants.SELECTED_USER_KEY, userJson);
  }

  Future<bool> checkUserExists() async {
    bool userExists = sharedPreferences.containsKey(AppConstants.USER_KEY);
    return userExists;
  }

  Future<bool> checkSelectedUserExists() async {
    bool userExists = sharedPreferences.containsKey(AppConstants.SELECTED_USER_KEY);
    return userExists;
  }

  Future<UserModel?> getUser() async {
    String? userJson = sharedPreferences.getString(AppConstants.USER_KEY);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<UserModel?> getSelectedUser() async {
    String? userJson = sharedPreferences.getString(AppConstants.SELECTED_USER_KEY);
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> removeSelectedUser() async {
    await sharedPreferences.remove(AppConstants.SELECTED_USER_KEY);
  }

  Future<Response> fetchUser(String userId) async {
    return await apiClient.getData('${AppConstants.GET_USER}/$userId');
  }

  Future<Response> updateUserDetails(FormData formData) async {
    return await apiClient.postData(AppConstants.UPDATE_USER_DETAILS_URI, formData);
  }
  
  Future<Response> getUserDetails(String userId) async {
    return await apiClient.getData('${AppConstants.USER_URI}/$userId/details');
  }

  Future<Response> getUserMedia(String userId) async {
    return await apiClient.getData('${AppConstants.GET_MEDIA_URI}/$userId');
  }

  Future<Response> getFriends(String userId) async {
    return await apiClient.getData('${AppConstants.GET_FRIENDS_URI}/$userId');
  }

  Future<Response> getFriendRequests(String userId) async {
    return await apiClient.getData('${AppConstants.GET_FRIEND_REQUESTS_URI}/$userId');
  }

  Future<Response> respondFriendRequest(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.RESPOND_FRIEND_REQUESTS_URI, data);
  }

  Future<Response> sendFriendRequest(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.SEND_FRIEND_REQUEST_URI, data);
  }

  Future<Response> createLook(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.LOOKS_URI, data);
  }
  
  Future<Response> getLooks(String userId) async {
    return await apiClient.getData('${AppConstants.LOOKS_URI}/$userId');
  }

  Future<Response> changeUsername(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.CHANGE_USERNAME_URI, data);
  }

  Future<Response> changePassword(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.CHANGE_PASSWORD_URI, data);
  }

}