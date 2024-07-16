import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/clubs_controller.dart';
import 'package:free_swingers_dating/controllers/conversations_controller.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/data/api/api_client.dart';
import 'package:free_swingers_dating/data/repo/auth_repo.dart';
import 'package:free_swingers_dating/data/repo/clubs_repo.dart';
import 'package:free_swingers_dating/data/repo/conversations_repo.dart';
import 'package:free_swingers_dating/data/repo/posts_repo.dart';
import 'package:free_swingers_dating/data/repo/user_repo.dart';
import 'package:free_swingers_dating/data/services/socket_service.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  //api clients
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  //repos
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => UserRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => PostsRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      ConversationsRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      ClubsRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // services
  Get.lazyPut(() => SocketService());

  //controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => PostsController(postsRepo: Get.find()));
  Get.lazyPut(() => ConversationsController(conversationsRepo: Get.find()));
  Get.lazyPut(() => SocketController());
  Get.lazyPut(() => ClubsController(clubsRepo: Get.find()));
}
