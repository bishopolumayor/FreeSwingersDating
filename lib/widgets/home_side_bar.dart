import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/menu_item.dart';
import 'package:get/get.dart';

class HomeSideBar extends StatefulWidget {
  final Function(int) changePage;

  const HomeSideBar({
    super.key,
    required this.changePage,
  });

  @override
  State<HomeSideBar> createState() => _HomeSideBarState();
}

class _HomeSideBarState extends State<HomeSideBar> {
  AuthController authController = Get.find<AuthController>();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  void logout () async {
    authController.logout();
  }

  void goToChangeUsernameScreen() async {
    Get.offNamed(AppRoutes.getChangeUsernameScreen());
  }

  void goToChangePasswordScreen() async {
    Get.offNamed(AppRoutes.getChangePasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobileView ? Dimensions.screenWidth / (430 / 350) : 300,
      height: isMobileView ? double.maxFinite : Dimensions.heightRatio(845),
      // 700 ,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // menu
          Container(
            height: 70,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: AppColors.mainColor,
            ),
            child: Row(children: [
              SizedBox(
                width: isMobileView ? 50 : 50,
              ),
              Text(
                'MENU',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontFamily: 'Poppins',
                  fontSize: isMobileView ? 18 : 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // space
                  const SizedBox(
                    height: 20,
                  ),
                  // messages
                  MenuItem(
                    onPressed: () {
                      widget.changePage(1);
                    },
                    text: 'Messages',
                  ),
                  // looked at me
                  MenuItem(
                    onPressed: () {
                      widget.changePage(2);
                    },
                    text: 'Looked at me',
                  ),
                  /*MenuItem(
                    onPressed: () {},
                    text: 'Tips',
                  ),*/
                  // friends list
                  MenuItem(
                    onPressed: () {
                      widget.changePage(4);
                    },
                    text: 'Friends List',
                  ),
                  // winks
                  /*MenuItem(
                    onPressed: () {},
                    text: 'Winks',
                  ),*/
                  // manage photos
                  /*MenuItem(
                    onPressed: () {},
                    text: 'Manage Photos',
                  ),*/
                  // verification
                  MenuItem(
                    onPressed: () {},
                    text: 'Verification',
                  ),
                  // edit account
                  MenuItem(
                    onPressed: () {
                      widget.changePage(7);
                    },
                    text: 'Edit Account',
                  ),
                  // change password
                  MenuItem(
                    onPressed: () {
                      goToChangePasswordScreen();
                    },
                    text: 'Change Password',
                  ),
                  // change username
                  MenuItem(
                    onPressed: () {
                      goToChangeUsernameScreen();
                    },
                    text: 'Change username',
                  ),
                  // manage filters
                  MenuItem(
                    onPressed: () {},
                    text: 'Manage Filters',
                  ),
                  // block list
                  MenuItem(
                    onPressed: () {},
                    text: 'Block List',
                  ),
                  // email notifications
                  MenuItem(
                    onPressed: () {},
                    text: 'Email Notifications',
                  ),
                  // privacy
                  MenuItem(
                    onPressed: () {},
                    text: 'Privacy',
                  ),
                  // delete account
                  MenuItem(
                    onPressed: () {},
                    text: 'Delete Account',
                  ),
                  // logout
                  MenuItem(
                    onPressed: () {
                      logout();
                    },
                    text: 'Logout',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
