import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/conversations_controller.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/data/repo/auth_repo.dart';
import 'package:free_swingers_dating/models/user_model.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo,
  });

  UserController userController = Get.find<UserController>();
  PostsController postsController = Get.find<PostsController>();
  ConversationsController conversationsController = Get.find<ConversationsController>();
  SocketController socketController  = Get.find<SocketController>();

  var registrationUsername = ''.obs;
  var registrationEmail = ''.obs;

  var loginIdentifier = ''.obs;

  Future<int?> getTotalUsers () async {
    try{
      Response response = await authRepo.getTotalUsers();
      var result = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          return result['data']['totalUsers'];
        }
      }
      return null;
    }catch(e){
      if (kDebugMode) {
        print('getTotalUsers exception $e');
      }
      return null;
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String identity,
    required String dateOfBirth,
  }) async {
    registrationEmail.value = email;

    var data = {
      "username": username,
      "email": email,
      "password": password,
      "identity": identity,
      "date_of_birth": dateOfBirth,
    };

    try {
      Response response = await authRepo.signUp(data);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          Get.snackbar(
            'Account Created',
            'You can successfully login now',
            backgroundColor: AppColors.mainColor,
            colorText: AppColors.whiteColor,
          );
          print(result['data']);
        } else {
          Get.snackbar('Failed', result['message'],
            backgroundColor: Colors.red,
            colorText: Colors.white,);
        }
      } else {
        Get.snackbar('Failed', result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,);
      }
    } catch (e) {
      if (kDebugMode) {
        print('sign up exception $e');
      }
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    loginIdentifier.value = identifier;

    var data = {
      "identifier": identifier,
      "password": password,
    };
    try {
      Response response = await authRepo.login(data, rememberMe);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          await authRepo.setToken(result['data']['token']);
          if (result['data']['user'] != null ) {
            UserModel user = UserModel.fromJson(result['data']['user']);
            await userController.saveUser(user);
            Get.snackbar('Successful', result['message'],
              backgroundColor: AppColors.mainColor,
              colorText: AppColors.whiteColor,);
            Get.offAllNamed(AppRoutes.getHomeScreen());
          }
        } else {
          Get.snackbar('Failed', result['message'],
            backgroundColor: Colors.red,
            colorText: Colors.white,);
        }
      } else {
        Get.snackbar('Failed', result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,);
      }
    } catch (e) {
      if (kDebugMode) {
        print('login exception $e');
      }
    }
  }

  Future<bool> checkRememberMeStatus() async {
    return await authRepo.getRememberMeStatus();
  }

  Future<void> restoreSession({
    bool returnToHome = true,
}) async {
    bool userExists = await userController.checkUserExists();
    bool rememberMe = await checkRememberMeStatus();

    if (userExists) {
      await userController.loadUser();
      await userController.loadSelectedUser();
      await userController.getMyFriends();
      socketController.connectSocket();
      await postsController.fetchStories();
      await postsController.fetchPosts();
      await conversationsController.fetchConversationsWithSocket();
      // Get.offAllNamed(AppRoutes.getHomeScreen());
    } else {
      if(returnToHome) {
        Get.offAllNamed(AppRoutes.getHomepage());
      }
    }
  }

  Future<void> restoreFromSplash() async {
    bool userExists = await userController.checkUserExists();
    bool rememberMe = await checkRememberMeStatus();

    if (userExists && rememberMe) {
      await userController.loadUser();
      await userController.loadSelectedUser();
      await userController.getMyFriends();
      socketController.connectSocket();
      await postsController.fetchStories();
      await postsController.fetchPosts();
      await conversationsController.fetchConversationsWithSocket();
      // Get.offAllNamed(AppRoutes.getHomeScreen());
    } else {
      Get.offAllNamed(AppRoutes.getHomepage());
    }
  }

  void logout() async {
    Get.offAllNamed(AppRoutes.getHomepage());
    socketController.disconnectSocket();
    await authRepo.clearAllData();
    clearLocalValues();
    userController.clearUserData();
  }

  void clearLocalValues () {
   registrationUsername.value = '';
   registrationEmail.value = '';
   loginIdentifier.value = '';
}
}
