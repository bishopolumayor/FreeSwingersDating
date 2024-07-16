import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/models/story_model.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/home_side_bar.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:free_swingers_dating/widgets/story_container.dart';
import 'package:get/get.dart';

class StorySection extends StatefulWidget {
  const StorySection({super.key});

  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  PostsController postsController = Get.find<PostsController>();

  bool get isNotWidest => Dimensions.isNotWidest();
  bool get isMobileView => Dimensions.isMobileView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Stories',
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: 'Poppins',
                fontSize: isMobileView ? 14 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See all',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontFamily: 'Poppins',
                  fontSize: isMobileView ? 14 : 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        // space
        const SizedBox(
          height: 10,
        ),
        Obx(() {
          List<StoryModel> stories = postsController.stories;
          return SizedBox(
            height: isMobileView ? 152 : 252,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return StoryContainer(
                  storyModel: stories[index],
                );
              },
              itemCount: stories.length,
            ),
          );
        }),
      ],
    );
  }
}
