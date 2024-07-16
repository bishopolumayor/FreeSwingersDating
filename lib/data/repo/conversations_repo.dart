import 'package:free_swingers_dating/data/api/api_client.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationsRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  ConversationsRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> getConversations(String userId) async {
    return await apiClient
        .getData('${AppConstants.USER_URI}/$userId/conversations');
  }

  Future<Response> getMessagesByConversation(String conversationId) async {
    return await apiClient
        .getData('${AppConstants.CONVERSATIONS_URI}/$conversationId/messages');
  }

  Future<Response> createConversation(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.CONVERSATIONS_URI, data);
  }

  Future<Response> createMessage(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.MESSAGES_URI, data);
  }
}
