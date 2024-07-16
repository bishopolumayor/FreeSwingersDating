import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/clubs_controller.dart';
import 'package:free_swingers_dating/controllers/conversations_controller.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/helpers/dependencies.dart' as dep;
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_) {
      return GetBuilder<UserController>(builder: (_) {
        return GetBuilder<PostsController>(builder: (_) {
          return GetBuilder<SocketController>(builder: (_) {
            return GetBuilder<ConversationsController>(
              builder: (_) {
                return GetBuilder<ClubsController>(builder: (_){
                  return GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Free Swingers',
                    getPages: AppRoutes.routes,
                    initialRoute: AppRoutes.getHomepage(),
                  );
                });
              },
            );
          });
        });
      });
    });
  }
}
