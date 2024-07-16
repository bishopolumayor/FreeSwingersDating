import 'package:free_swingers_dating/data/api/api_client.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClubsRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  ClubsRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> getClubs() async {
    return await apiClient.get(AppConstants.GET_CLUBS_URI);
  }

  Future<Response> getClubDetails(String clubId) async {
    return await apiClient.getData('${AppConstants.GET_CLUBS_URI}/$clubId');
  }

  Future<Response> createClub (Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.CREATE_CLUB_URI, data);
  }

  Future<Response> reviewClub (Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.REVIEW_CLUB_URI, data);
  }
}
