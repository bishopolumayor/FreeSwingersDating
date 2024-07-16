import 'package:free_swingers_dating/data/api/api_client.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  PostsRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> getStories() async {
    return await apiClient.getData(AppConstants.GET_STORY_URI);
  }

  Future<Response> getPosts() async {
    return await apiClient.getData(AppConstants.GET_POST_URI);
  }

  Future<Response> getHotPictures() async {
    return await apiClient.getData(AppConstants.GET_HOT_PICTURES);
  }

  Future<Response> uploadStory(FormData formData) async {
    return await apiClient.postData(AppConstants.UPLOAD_STORY_URI, formData);
  }

  Future<Response> uploadPost(FormData formData) async {
    return await apiClient.postData(AppConstants.UPLOAD_POST_URI, formData);
  }
}
