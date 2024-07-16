import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/models/post_model.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/post_container.dart';
import 'package:get/get.dart';

class PostsSection extends StatefulWidget {
  const PostsSection({super.key});

  @override
  State<PostsSection> createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
  PostsController postsController = Get.find<PostsController>();

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
        List<PostModel> posts = postsController.posts;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PostContainer(
              postModel: posts[index],
            );
          },
          itemCount: posts.length,
        );
      }),
    );
  }
}
