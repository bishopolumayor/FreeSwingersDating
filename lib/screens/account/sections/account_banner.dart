import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
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
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';

class AccountBanner extends StatefulWidget {
  final int selectedSection;
  final Function(int) switchSection;

  const AccountBanner({
    super.key,
    required this.selectedSection,
    required this.switchSection,
  });

  @override
  State<AccountBanner> createState() => _AccountBannerState();
}

class _AccountBannerState extends State<AccountBanner> {
  UserController userController = Get.find<UserController>();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  @override
  Widget build(BuildContext context) {
    int selectedTab = widget.selectedSection;
    Function (int) switchTab = widget.switchSection;
    return Container(
      child: Stack(
        children: [
          // banner and tabs
          Column(
            children: [
              // banner
              Container(
                width: double.maxFinite,
                height: isMobileView ? 150 : 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/banner.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // tabs
              Container(
                width: double.maxFinite,
                height: isMobileView ? 65 : 85,
                decoration: const BoxDecoration(
                  color: AppColors.mainColor,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: isMobileView
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.center,
                    children: [
                      // profile
                      GestureDetector(
                        onTap: () => switchTab(0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // profile
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: isMobileView ? 13 : 20,
                              ),
                            ),
                            // space
                            SizedBox(
                              height: isMobileView ? 8 : 15,
                            ),
                            // line
                            Container(
                              height: 2,
                              width: isMobileView ? 40 : 80,
                              color: selectedTab == 0
                                  ? AppColors.whiteColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      // space
                      SizedBox(
                        width: isMobileView ? 10 : 22,
                      ),
                      // pictures
                      GestureDetector(
                        onTap: () => switchTab(1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // media
                            Text(
                              'Pictures',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: isMobileView ? 13 : 20,
                              ),
                            ),
                            // space
                            SizedBox(
                              height: isMobileView ? 8 : 15,
                            ),
                            // line
                            Container(
                              height: 2,
                              width: isMobileView ? 40 : 80,
                              color: selectedTab == 1
                                  ? AppColors.whiteColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      // space
                      SizedBox(
                        width: isMobileView ? 10 : 22,
                      ),
                      // videos
                      GestureDetector(
                        onTap: () => switchTab(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // media
                            Text(
                              'Videos',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: isMobileView ? 13 : 20,
                              ),
                            ),
                            // space
                            SizedBox(
                              height: isMobileView ? 8 : 15,
                            ),
                            // line
                            Container(
                              height: 2,
                              width: isMobileView ? 40 : 80,
                              color: selectedTab == 5
                                  ? AppColors.whiteColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      // space
                      SizedBox(
                        width: isMobileView ? 10 : 22,
                      ),
                      // Timeline
                      GestureDetector(
                        onTap: () => switchTab(2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Timeline
                            Text(
                              'Timeline',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: isMobileView ? 13 : 20,
                              ),
                            ),
                            // space
                            SizedBox(
                              height: isMobileView ? 8 : 15,
                            ),
                            // line
                            Container(
                              height: 2,
                              width: isMobileView ? 40 : 80,
                              color: selectedTab == 2
                                  ? AppColors.whiteColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      // space
                      SizedBox(
                        width: isMobileView ? 10 : 22,
                      ),
                      // Verification
                      GestureDetector(
                        onTap: () => switchTab(3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Verification
                            Text(
                              'Verification',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: isMobileView ? 13 : 20,
                              ),
                            ),
                            // space
                            SizedBox(
                              height: isMobileView ? 8 : 15,
                            ),
                            // line
                            Container(
                              height: 2,
                              width: isMobileView ? 40 : 80,
                              color: selectedTab == 3
                                  ? AppColors.whiteColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      // space
                      SizedBox(
                        width: isMobileView ? 10 : 22,
                      ),
                      // Friends
                      GestureDetector(
                        onTap: () => switchTab(4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Friends
                            Text(
                              'Friends',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: isMobileView ? 13 : 20,
                              ),
                            ),
                            // space
                            SizedBox(
                              height: isMobileView ? 8 : 15,
                            ),
                            // line
                            Container(
                              height: 2,
                              width: isMobileView ? 40 : 80,
                              color: selectedTab == 4
                                  ? AppColors.whiteColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      // space
                      if (isMobileView)
                        SizedBox(
                          width: isMobileView ? 10 : 22,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // profile image
          Positioned(
            bottom: isMobileView ? 10 : 20,
            left: isMobileView ? 15 : 35,
            child: Obx(() {
              UserModel? user;
              if(userController.selectedUser.value != null) {
                user = userController.selectedUser.value;
              }else {
                user = userController.user.value;
              }
              if (user != null) {
                return Container(
                  height:
                      isMobileView ? Dimensions.screenHeight / (932 / 80) : 205,
                  width:
                      isMobileView ? Dimensions.screenHeight / (932 / 80) : 205,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.mainColorDark,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        user.profileImage != null
                            ? '${AppConstants.BASE_URL}/${user.profileImage}'
                            : '${AppConstants.BASE_URL}/public/media/profile/default.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              } else {
                return Container(
                  height:
                      isMobileView ? Dimensions.screenHeight / (932 / 80) : 205,
                  width:
                      isMobileView ? Dimensions.screenHeight / (932 / 80) : 205,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.mainColorDark,
                      width: 2,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        '${AppConstants.BASE_URL}/public/media/profile/default.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
