import 'package:flutter/material.dart';
import 'package:free_swingers_dating/screens/home/sections/posts_section.dart';
import 'package:free_swingers_dating/screens/home/sections/share_post_section.dart';
import 'package:free_swingers_dating/screens/home/sections/story_section.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/home_side_bar.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobileView ? Dimensions.screenHeight / (932 / 810) : Dimensions.heightRatio(860),
      color: Colors.grey.shade100,
      padding:  EdgeInsets.all(isMobileView ? 15 : 25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // story section
            const StorySection(),
            // space
            SizedBox(
              height: isMobileView ? 30 : 50,
            ),
            // share post section
            const SharePostSection(),
            // space
            SizedBox(
              height: isMobileView ? 30 : 50,
            ),
            // posts
            const PostsSection(),
          ],
        ),
      ),
    );
  }
}
