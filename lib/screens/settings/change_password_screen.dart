import 'dart:html';

import 'package:flutter/foundation.dart';
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
import 'package:free_swingers_dating/widgets/bar_loading_animation.dart';
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/home_side_bar.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  SocketController socketController = Get.find<SocketController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();

  int _currentPage = 0;

  bool _isLoading = false;

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  int selectedTab = 0;

  Map<String, dynamic>? resultMessage;

  void switchTabs(int tab) {
    setState(() {
      selectedTab = tab;
    });

    if (tab == 0) {
      Get.offNamed(AppRoutes.getHomeScreen());
    }

    if (tab == 1) {
      setState(() {
        // _currentPage = 1;
      });
      Get.toNamed(AppRoutes.getMyAccountScreen());
    }

    if (tab == 2) {
      Get.offNamed(AppRoutes.getHotPictures());
    }

    if (tab == 3) {
      Get.offNamed(AppRoutes.getEventsScreen());
    }

    if(tab == 4){
      Get.offNamed(AppRoutes.getClubsScreen());
    }

    if (tab == 6) {
      setState(() {
        _currentPage = 1;
      });
      Get.toNamed(AppRoutes.getMessagesScreen());
    }
  }

  void _openDrawer() {
    isMobileView ? _scaffoldKey.currentState?.openDrawer() : null;
  }

  void _closeDrawer() {
    isMobileView ? _scaffoldKey.currentState?.closeDrawer() : null;
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });

    switch (page) {
      case 0:
        setState(() {
          selectedTab = 0;
        });
        _closeDrawer();
        Get.offNamed(AppRoutes.getHomeScreen());

      case 1:
        setState(() {
          selectedTab = 6;
        });
        _closeDrawer();
        Get.toNamed(AppRoutes.getMessagesScreen());
      case 2 :
        setState(() {
          selectedTab = 1;
        });
        _closeDrawer();
        Get.toNamed(AppRoutes.getLookedAtMeScreen());
      case 4 :
        setState(() {
          selectedTab = 1;
        });
        _closeDrawer();
        Get.toNamed(AppRoutes.getFriendsPage());
      case 7:
        setState(() {
          selectedTab = 1;
        });
        _closeDrawer();
        Get.toNamed(AppRoutes.getAccountSettings());
    }

    _closeDrawer();
  }

  @override
  void initState() {
    super.initState();
    initializeSettings();
  }

  void initializeSettings() async {
    setState(() {
      _isLoading = true;
    });
    await authController.restoreSession();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool validate(){
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmNewPassword = confirmNewPasswordController.text;
    if(oldPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty){
      Get.snackbar('Incomplete Inputs', 'Enter all fields',);
      return false;
    }
    if(oldPassword == newPassword){
      Get.snackbar('Invalid Inputs', 'Your current password and new password should be different',);
      return false;
    }
    if(newPassword != confirmNewPassword){
      Get.snackbar('Passwords Mismatch', 'Your new password and confirm password are different',);
      return false;
    }
    return true;
  }

  void changePassword() async {
    if (validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic>? result = await userController.changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );
      setState(() {
        resultMessage = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: HomeSideBar(
        changePage: _changePage,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      if (isNotWidest)
                        GestureDetector(
                          onTap: _openDrawer,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: Dimensions.widthRatio(5),
                            ),
                            child: const Icon(
                              Icons.menu,
                              color: AppColors.mainColor,
                              size: 16,
                            ),
                          ),
                        ),
                      Header(
                        selectedTab: selectedTab,
                        onTabChanged: (tab) => switchTabs(tab),
                      ),
                    ],
                  ),
                ),
                // space
                SizedBox(
                  height: isMobileView ? 0 : 10,
                ),
                // body
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // side bar
                    if (!isMobileView)
                      SizedBox(
                        width: 300,
                        child: HomeSideBar(
                          changePage: _changePage,
                        ),
                      ),
                    // main body
                    Expanded(
                      child: Container(
                        height: isMobileView
                            ? Dimensions.screenHeight / (932 / 810)
                            : Dimensions.heightRatio(860),
                        color: Colors.grey.shade100,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(_isLoading)
                                const LinearProgressIndicator(
                                  backgroundColor: AppColors.mainColorLight,
                                  color: AppColors.mainColor,
                                ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // change password
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 10 : 20,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Change Password',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 18 : 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Container(),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 1 : 2,
                              ),
                              // line
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 10 : 20,
                                ),
                                width: double.maxFinite,
                                height: 1.5,
                                color: AppColors.mainColor,
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // old password
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 10 : 20,
                                ),
                                child: TextField(
                                  controller: oldPasswordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.75,
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.25,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: 'Old password',
                                  ),
                                  cursorColor: AppColors.mainColor,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // new password
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 10 : 20,
                                ),
                                child: TextField(
                                  controller: newPasswordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.75,
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.25,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: 'New password',
                                  ),
                                  cursorColor: AppColors.mainColor,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // confirm password
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 10 : 20,
                                ),
                                child: TextField(
                                  controller: confirmNewPasswordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.75,
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.25,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: 'Confirm new password',
                                  ),
                                  cursorColor: AppColors.mainColor,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // result message
                              if(resultMessage != null)
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: isMobileView ? 10 : 20,
                                  ),
                                  child:  Column(
                                    children: [
                                      // space
                                      SizedBox(
                                        height: isMobileView ? 5 : 7,
                                      ),
                                      // result text
                                      Text(
                                        resultMessage!['message'],
                                        style: TextStyle(
                                          color: resultMessage!['color'],
                                          fontSize: isMobileView ? 8 : 10,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // change
                              Center(
                                child: GestureDetector(
                                  onTap: (){
                                    changePassword();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: isMobileView ? 10 : 20,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isMobileView ? 30 : 50,
                                      vertical: isMobileView ? 10 : 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isLoading ? AppColors.greyColor1 : AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isLoading ? 'Please Wait...' : 'Change Password',
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: isMobileView ? 14 : 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
