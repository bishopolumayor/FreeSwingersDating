import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/models/post_model.dart';
import 'package:free_swingers_dating/models/user_model.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/screens/chat/messages_screen.dart';
import 'package:free_swingers_dating/screens/home/sections/home_feed.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/home_side_bar.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/post_container.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';

class AccountTimeline extends StatefulWidget {
  const AccountTimeline({super.key});

  @override
  State<AccountTimeline> createState() => _AccountTimelineState();
}

class _AccountTimelineState extends State<AccountTimeline> {

  PostsController postsController = Get.find<PostsController>();
  UserController userController = Get.find<UserController>();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobileView ? 15 : 20,
        vertical: isMobileView ? 10 : 15,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Obx(() {
        UserModel user;
        if(userController.selectedUser.value != null) {
          user = userController.selectedUser.value!;
        }else {
          user = userController.user.value!;
        }
        String userId = user.userId;
        List<PostModel> posts = postsController.posts;
        List<PostModel> myPosts = posts.where((post) => post.userId == userId).toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PostContainer(
              postModel: myPosts[index],
            );
          },
          itemCount: myPosts.length,
        );
      }),
    );
  }
}
