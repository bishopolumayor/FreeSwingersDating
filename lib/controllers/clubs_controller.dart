import 'package:flutter/foundation.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/data/repo/clubs_repo.dart';
import 'package:free_swingers_dating/models/user_model.dart';
import 'package:get/get.dart';

class ClubsController extends GetxController {
  final ClubsRepo clubsRepo;

  ClubsController({
    required this.clubsRepo,
  });

  UserController userController = Get.find<UserController>();

  Future<List<dynamic>?> getClubs() async {
    try {
      Response response = await clubsRepo.getClubs();
      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          return result['data']['clubs'];
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('getClubs exception $e');
      }
      return null;
    }
  }

  Future<void> createClub({
    required String name,
    required String shortDescription,
    required String longDescription,
    required String clubLink,
    required String clubEmail,
    required String clubLocation,
  }) async {
    try {
      UserModel? user = userController.user.value;

      if (user == null) {
        Get.snackbar(
          'No user found',
          'Login to continue',
        );
        return;
      }

      String userId = user.userId;
      var data = {
        "creator": userId,
        "name": name,
        "short_description": shortDescription,
        "long_description": longDescription,
        "club_link": clubLink,
        "club_email": clubEmail,
        "location": clubLocation,
      };

      Response response = await clubsRepo.createClub(data);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          Get.snackbar('Success', result['message']);
        } else {
          Get.snackbar('Failed', result['message']);
        }
      } else {
        Get.snackbar('Failed', result['message']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('createClub exception $e');
      }
    }
  }

  Future<Map<String, dynamic>?> getClubDetails({
    required String clubId,
  }) async {
    try {
      Response response = await clubsRepo.getClubDetails(clubId);
      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          return result['data'];
        } else {
          Get.snackbar('Failed', result['message']);
        }
      } else {
        Get.snackbar('Failed', result['message']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('getClubDetails exception $e');
      }
      return null;
    }
  }


  Future<void> reviewClub({
    required String comment,
    required int rating,
    required String clubId,
  }) async {
    try {
      UserModel? user = userController.user.value;

      if (user == null) {
        Get.snackbar(
          'No user found',
          'Login to continue',
        );
        return;
      }

      String userId = user.userId;
      var data = {
        "reviewer": userId,
        "club_id": clubId,
        "rating": rating,
        "comment": comment,
      };

      Response response = await clubsRepo.reviewClub(data);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          Get.snackbar('Success', result['message']);
        } else {
          Get.snackbar('Failed', result['message']);
        }
      } else {
        Get.snackbar('Failed', result['message']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('createClub exception $e');
      }
    }
  }
}
