import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/screens/account/sections/account_banner.dart';
import 'package:free_swingers_dating/screens/account/sections/account_friends.dart';
import 'package:free_swingers_dating/screens/account/sections/account_media.dart';
import 'package:free_swingers_dating/screens/account/sections/account_timeline.dart';
import 'package:free_swingers_dating/screens/account/sections/account_videos.dart';
import 'package:free_swingers_dating/screens/account/sections/profile_details_section.dart';
import 'package:free_swingers_dating/screens/chat/messages_screen.dart';
import 'package:free_swingers_dating/screens/home/sections/home_feed.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/home_side_bar.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  SocketController socketController = Get.find<SocketController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPage = 0;

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  int selectedTab = 1;

  int selectedSection = 0;

  bool _isLoading = false;

  void switchSection(int section){
    setState(() {
      selectedSection = section;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeAccountScreen();
  }

  @override
  void dispose() {
    userController.removeSelectedUser();
    super.dispose();
  }

  void initializeAccountScreen() async {
    setState(() {
      _isLoading = true;
    });
    await authController.restoreSession();
    if(userController.selectedUser.value != null){
      if(userController.selectedUser.value!.userId != userController.user.value!.userId){
        String lookedAtId = userController.selectedUser.value!.userId;
        await userController.createLook(lookedAtId: lookedAtId);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void switchTabs(int tab) {
    setState(() {
      selectedTab = tab;
    });

    if (tab == 0) {
      Get.offNamed(AppRoutes.getHomeScreen());
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

    userController.removeSelectedUser();
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
    userController.removeSelectedUser();
  }

  List<Widget> sections = <Widget>[
    const ProfileDetailsSection(),
    const AccountMedia(),
    const AccountTimeline(),
    Container(),
    const AccountFriends(),
    const AccountVideo(),
  ];

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
                        height: isMobileView ? Dimensions.screenHeight / (932 / 810) : Dimensions.heightRatio(860),
                        color: AppColors.whiteColor,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // banner
                              AccountBanner(
                                selectedSection: selectedSection,
                                switchSection: switchSection,
                              ),
                              if(_isLoading)
                                const LinearProgressIndicator(
                                  color: AppColors.mainColor,
                                  backgroundColor: AppColors.mainColorLight,
                                ),
                              // section
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: isMobileView ? 20 : 40,
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: sections[selectedSection],
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
