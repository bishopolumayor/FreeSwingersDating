import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:free_swingers_dating/data/repo/user_repo.dart';
import 'package:free_swingers_dating/models/user_model.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  final UserRepo userRepo;

  UserController({
    required this.userRepo,
  });

  Rx<UserModel?> user = Rx<UserModel?>(null);
  Rx<UserModel?> selectedUser = Rx<UserModel?>(null);

  var userFriends = <UserModel>[].obs;
  var myFriends = <UserModel>[].obs;

  Future<void> saveUser(UserModel user) async {
    await userRepo.saveUser(user);
    this.user.value = user;
  }

  Future<void> saveSelectedUser(UserModel user) async {
    await userRepo.saveSelectedUser(user);
    selectedUser.value = user;
  }

  Future<bool> checkUserExists() async {
    return await userRepo.checkUserExists();
  }

  Future<bool> checkSelectedUserExists() async {
    return await userRepo.checkSelectedUserExists();
  }

  Future<void> loadUser() async {
    UserModel? loadedUser = await userRepo.getUser();
    if (loadedUser != null) {
      user.value = loadedUser;
    }
  }

  Future<void> loadSelectedUser() async {
    UserModel? loadedUser = await userRepo.getSelectedUser();
    if (loadedUser != null) {
      selectedUser.value = loadedUser;
    }
  }

  Future<void> fetchUser() async {
    try {
      String userId = user.value!.userId;
      Response response = await userRepo.fetchUser(userId);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          UserModel user = UserModel.fromJson(result['data']);
          await saveUser(user);
        } else {}
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print('fetchUser exception $e');
      }
    }
  }

  Future<void> fetchSelectedUser() async {
    try {
      String userId = selectedUser.value?.userId ?? '';
      Response response = await userRepo.fetchUser(userId);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          UserModel user = UserModel.fromJson(result['data']);
          await saveSelectedUser(user);
        } else {}
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print('fetchSelectedUser exception $e');
      }
    }
  }

  Future<bool> updateUserDetails({
    required String userId,
    required String country,
    required String startAge,
    required String endAge,
    required bool smoke,
    required bool drink,
    required bool tattoo,
    required bool piercing,
    required bool lookingMan,
    required bool lookingWoman,
    required bool lookingCouple,
    required bool lookingCoupleM,
    required bool lookingCoupleF,
    required bool lookingTvTs,
    required bool meetSmokers,
    required bool canTravel,
    required bool canAccommodate,
    required bool dp,
    required bool groupSex,
    required bool makingVideos,
    required bool oral,
    required bool rolePlay,
    required bool safeSex,
    required bool threesome,
    required bool toys,
    required String identity,
    required String firstname,
    required String lastname,
    XFile? profileImage,
  }) async {
    try {
      var formData = FormData({});

      formData.fields.add(MapEntry('user_id', userId));
      formData.fields.add(MapEntry('country', country));
      formData.fields.add(MapEntry('start_age', startAge));
      formData.fields.add(MapEntry('end_age', endAge));
      formData.fields.add(MapEntry('smoke', smoke.toString()));
      formData.fields.add(MapEntry('drink', drink.toString()));
      formData.fields.add(MapEntry('tattoo', tattoo.toString()));
      formData.fields.add(MapEntry('piercing', piercing.toString()));
      formData.fields.add(MapEntry('looking_man', lookingMan.toString()));
      formData.fields.add(MapEntry('looking_woman', lookingWoman.toString()));
      formData.fields.add(MapEntry('looking_couple', lookingCouple.toString()));
      formData.fields
          .add(MapEntry('looking_couple_m', lookingCoupleM.toString()));
      formData.fields
          .add(MapEntry('looking_couple_f', lookingCoupleF.toString()));
      formData.fields.add(MapEntry('looking_tv_ts', lookingTvTs.toString()));
      formData.fields.add(MapEntry('meet_smokers', meetSmokers.toString()));
      formData.fields.add(MapEntry('can_travel', canTravel.toString()));
      formData.fields
          .add(MapEntry('can_accommodate', canAccommodate.toString()));
      formData.fields.add(MapEntry('dp', dp.toString()));
      formData.fields.add(MapEntry('group_sex', groupSex.toString()));
      formData.fields.add(MapEntry('making_videos', makingVideos.toString()));
      formData.fields.add(MapEntry('oral', oral.toString()));
      formData.fields.add(MapEntry('role_play', rolePlay.toString()));
      formData.fields.add(MapEntry('safe_sex', safeSex.toString()));
      formData.fields.add(MapEntry('threesome', threesome.toString()));
      formData.fields.add(MapEntry('toys', toys.toString()));
      formData.fields.add(MapEntry('identity', identity));
      formData.fields.add(MapEntry('firstname', firstname));
      formData.fields.add(MapEntry('lastname', lastname));

      if (profileImage != null) {
        Uint8List mediaBytes = await profileImage.readAsBytes();
        formData.files.add(MapEntry(
          'profile_image',
          MultipartFile(
            mediaBytes,
            filename: profileImage.name,
          ),
        ));
      }

      Response response = await userRepo.updateUserDetails(formData);
      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          Get.snackbar(
            'Updated',
            result['message'],
            backgroundColor: AppColors.mainColor,
            colorText: AppColors.whiteColor,
          );
          return true;
        } else {
          Get.snackbar(
            'Failed',
            result['message'],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        Get.snackbar(
          'Failed',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('updateUserDetails exception $e');
      }
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserDetails({
    required String userId,
  }) async {
    try {
      Response response = await userRepo.getUserDetails(userId);
      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          return result['data'];
        } else {
          return {};
        }
      } else {
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print('getUserDetails exception $e');
      }
      return {};
    }
  }

  Future<List<String>> getUserMedia({
    required String userId,
  }) async {
    try {
      Response response = await userRepo.getUserMedia(userId);
      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> dynamicList = result['data']['media'];
          List<String> stringList =
              dynamicList.map((e) => e.toString()).toList();
          return stringList;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('getUserMedia exception $e');
      }
      return [];
    }
  }

  Future<List<UserModel>> getFriends({
    required String userId,
  }) async {
    try {
      Response response = await userRepo.getFriends(userId);
      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> friendsData = result['data']['friends'];
          List<UserModel> friends =
              friendsData.map((friend) => UserModel.fromJson(friend)).toList();
          userFriends.value = [];
          userFriends.assignAll(friends);
          return friends;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('getFriends exception $e');
      }
      return [];
    }
  }

  Future<List<UserModel>> getMyFriends() async {
    try {
      String userId = user.value!.userId;
      Response response = await userRepo.getFriends(userId);
      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> friendsData = result['data']['friends'];
          List<UserModel> friends =
              friendsData.map((friend) => UserModel.fromJson(friend)).toList();
          myFriends.value = [];
          myFriends.assignAll(friends);
          return friends;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('getFriends exception $e');
      }
      return [];
    }
  }

  Future<List<dynamic>> getFriendRequests({
    required String userId,
  }) async {
    try {
      Response response = await userRepo.getFriendRequests(userId);
      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> requests = result['data'];
          return requests;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('getFriendRequests exception $e');
      }
      return [];
    }
  }

  Future<bool> respondFriendRequest({
    required String requestId,
    required int status,
  }) async {
    try {
      var data = {
        'requestId': requestId,
        'status': status,
      };

      Response response = await userRepo.respondFriendRequest(data);

      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          String userId = user.value!.userId;
          Get.snackbar(
            'Success',
            status == 1 ? 'Request accepted' : 'Request declined',
          );
          await getFriends(
            userId: userId,
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('getFriendRequests exception $e');
      }
      return false;
    }
  }

  Future<bool> sendFriendRequest({
    required String receiverId,
  }) async {
    try {
      String senderId = user.value!.userId;
      var data = {
        'senderId': senderId,
        'receiverId': receiverId,
      };
      Response response = await userRepo.sendFriendRequest(data);

      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          Get.snackbar(
            'Success',
            'Request sent',
          );
          return true;
        } else {
          Get.snackbar(
            'Failed',
            result['message'],
          );
          return false;
        }
      } else {
        Get.snackbar(
          'Failed',
          result['message'],
        );
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('sendFriendRequest exception $e');
      }
      return false;
    }
  }

  Future<bool> createLook({required String lookedAtId}) async {
    try {
      String lookerId = user.value!.userId;
      var data = {
        'looker_id': lookerId,
        'looked_at_id': lookedAtId,
      };

      Response response = await userRepo.createLook(data);
      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          return true;
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('createLook exception $e');
      }
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> getLooks() async {
    try {
      String userId = user.value!.userId;
      Response response = await userRepo.getLooks(userId);
      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> looksData = result['data']['looks'];
          List<Map<String, dynamic>> looksList =
              looksData.map((look) => look as Map<String, dynamic>).toList();
          return looksList;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('getLooks exception $e');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> changeUsername({
    required String username,
  }) async {
    try {
      String userId = user.value!.userId;
      var data = {
        "userId": userId,
        "newUsername": username,
      };

      Response response = await userRepo.changeUsername(data);
      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          Get.snackbar(
            'Success',
            result['message'],
            colorText: AppColors.whiteColor,
            backgroundColor: AppColors.mainColor,
          );
          await fetchUser();
          return {'message' : result['message'], 'color' : Colors.green,};
        } else {
          return {'message' : result['message'], 'color' : Colors.red,};
        }
      } else if (result['message'] != null) {
        return {'message' : result['message'], 'color' : Colors.red,};
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('changeUsername exception $e');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      String userId = user.value!.userId;
      var data = {
        "userId": userId,
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      };

      Response response = await userRepo.changePassword(data);
      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          Get.snackbar(
            'Success',
            result['message'],
            colorText: AppColors.whiteColor,
            backgroundColor: AppColors.mainColor,
          );
          return {'message' : result['message'], 'color' : Colors.green,};
        } else {
          return {'message' : result['message'], 'color' : Colors.red,};
        }
      } else if (result['message'] != null) {
        return {'message' : result['message'], 'color' : Colors.red,};
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('changePassword exception $e');
      }
      return null;
    }
  }

  void removeSelectedUser() async {
    await userRepo.removeSelectedUser();
    selectedUser.value = null;
  }

  void clearUserData() {
    user.value = null;
    selectedUser.value = null;
    userFriends.value = [];
  }
}
