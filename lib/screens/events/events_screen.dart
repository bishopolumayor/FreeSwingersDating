import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/clubs_controller.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/screens/clubs/sections/clubs_side_bar.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/bar_loading_animation.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:get/get.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  bool _isLoading = false;

  int _currentPage = 0;

  int selectedTab = 3;

  @override
  void initState() {
    super.initState();
    initializeEventsScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeEventsScreen() async {
    setState(() {
      _isLoading = true;
    });
    await authController.restoreSession(returnToHome: false);
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

    if(tab == 1){
      setState(() {
        // _currentPage = 1;
      });
      Get.toNamed(AppRoutes.getMyAccountScreen());
    }

    if (tab == 2) {
      Get.offNamed(AppRoutes.getHotPictures());
    }

    if (tab == 3) {
      // Get.offNamed(AppRoutes.getEventsScreen());
    }

    if(tab == 4){
      Get.offNamed(AppRoutes.getClubsScreen());
    }

    if (tab == 6) {
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    Expanded(
                      child: Container(
                        color: Colors.white,
                      height: isMobileView
                          ? Dimensions.screenHeight / (932 / 810)
                          : Dimensions.heightRatio(860),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              // upcoming events
                              Container(
                                color: Colors.grey.shade200,
                                width: double.maxFinite,
                                padding : EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 40 : 80,
                                  vertical: isMobileView ? 30 : 65,
                                ),
                                child: isMobileView? Column(
                                  children: [
                                    // texts
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // upcoming events
                                        Text(
                                          'Upcoming\nEvents',
                                          style: TextStyle(
                                            color: AppColors.mainColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: isMobileView ? 25 : 30,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        // space
                                        SizedBox(
                                          height: isMobileView ? 15 : 25,
                                        ),
                                        // text
                                        Text(
                                          'Looking to connect with fellow club\nmembers and explore your passions? \nWe\'ve got something for everyone! Check\nout the exciting lineup of events',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: isMobileView ? 14 : 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                    // space
                                    SizedBox(
                                      height: isMobileView ? 40 : 65,
                                    ),
                                    // events
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: isMobileView ? 10 : 20
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.event_busy,
                                              color: AppColors.mainColor,
                                              size: isMobileView ? 45 : 65,
                                            ),
                                            // space
                                            SizedBox(
                                              height: isMobileView ? 20 : 40,
                                            ),
                                            Text(
                                              '😞 No Upcoming Events\ncheck back later',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.mainColor,
                                                fontWeight: FontWeight.w800,
                                                fontSize: isMobileView ? 20 : 24,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ) : Row(
                                  children: [
                                    // texts
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // upcoming events
                                        Text(
                                          'Upcoming\nEvents',
                                          style: TextStyle(
                                            color: AppColors.mainColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: isMobileView ? 25 : 30,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        // space
                                        SizedBox(
                                          height: isMobileView ? 15 : 25,
                                        ),
                                        // text
                                        Text(
                                          'Looking to connect with fellow club\nmembers and explore your passions? \nWe\'ve got something for everyone! Check\nout the exciting lineup of events',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: isMobileView ? 14 : 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                    // space
                                    SizedBox(
                                      width: isMobileView ? 20 : 40,
                                    ),
                                    // events
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isMobileView ? 10 : 20
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.event_busy,
                                              color: AppColors.mainColor,
                                              size: isMobileView ? 45 : 65,
                                              ),
                                              // space
                                              SizedBox(
                                                height: isMobileView ? 20 : 40,
                                              ),
                                              Text(
                                                '😞 No Upcoming Events\ncheck back later',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppColors.mainColor,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: isMobileView ? 20 : 24,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 30 : 45,
                              ),
                              // recent events
                              Container(
                                color: Colors.white,
                                width: double.maxFinite,
                                padding : EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 40 : 80,
                                  vertical: isMobileView ? 30 : 65,
                                ),
                                child: isMobileView? Column(
                                  children: [
                                    // texts
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // recent events
                                        Text(
                                          'Recent Events',
                                          style: TextStyle(
                                            color: AppColors.mainColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: isMobileView ? 25 : 30,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        // space
                                        SizedBox(
                                          height: isMobileView ? 15 : 25,
                                        ),
                                        // text
                                        Text(
                                          'Looking to connect with fellow club\nmembers and explore your passions? \nWe\'ve got something for everyone! Check\nout the exciting lineup of events',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: isMobileView ? 14 : 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                    // space
                                    SizedBox(
                                      height: isMobileView ? 40 : 65,
                                    ),
                                    // events
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: isMobileView ? 10 : 20
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // icon
                                            Icon(
                                              Icons.event_busy,
                                              color: AppColors.mainColor,
                                              size: isMobileView ? 45 : 65,
                                            ),
                                            // space
                                            SizedBox(
                                              height: isMobileView ? 20 : 40,
                                            ),
                                            // text
                                            Text(
                                              '😫 No Recent Events\ncheck back later',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.mainColor,
                                                fontWeight: FontWeight.w800,
                                                fontSize: isMobileView ? 20 : 24,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ) : Row(
                                  children: [
                                    // texts
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // recent events
                                        Text(
                                          'Recent Events',
                                          style: TextStyle(
                                            color: AppColors.mainColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: isMobileView ? 25 : 30,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        // space
                                        SizedBox(
                                          height: isMobileView ? 15 : 25,
                                        ),
                                        // text
                                        Text(
                                          'Looking to connect with fellow club\nmembers and explore your passions? \nWe\'ve got something for everyone! Check\nout the exciting lineup of events',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: isMobileView ? 14 : 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                    // space
                                    SizedBox(
                                      width: isMobileView ? 20 : 40,
                                    ),
                                    // events
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: isMobileView ? 10 : 20
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.event_busy,
                                                color: AppColors.mainColor,
                                                size: isMobileView ? 45 : 65,
                                              ),
                                              // space
                                              SizedBox(
                                                height: isMobileView ? 20 : 40,
                                              ),
                                              // text
                                              Text(
                                                '😫 No Recent Events\ncheck back later',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppColors.mainColor,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: isMobileView ? 20 : 24,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
