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

class LookedAtMeScreen extends StatefulWidget {
  const LookedAtMeScreen({super.key});

  @override
  State<LookedAtMeScreen> createState() => _LookedAtMeScreenState();
}

class _LookedAtMeScreenState extends State<LookedAtMeScreen> {
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  SocketController socketController = Get.find<SocketController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPage = 0;

  bool _isLoading = false;

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  int selectedTab = 0;

  List<Map<String, dynamic>> looks = [];

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
    initializeLookedAtMe();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeLookedAtMe() async {
    setState(() {
      _isLoading = true;
    });
    await authController.restoreSession();
    List<Map<String, dynamic>>? looksData = await userController.getLooks();
    if (looksData != null){
      setState(() {
        looks = looksData;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  String timeAgo(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();
    Duration diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      if (diff.inSeconds < 10) {
        return 'just now';
      }
      return '${diff.inSeconds} seconds ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      int weeks = (diff.inDays / 7).floor();
      return '$weeks weeks ago';
    } else if (diff.inDays < 365) {
      int months = (diff.inDays / 30).floor();
      return '$months months ago';
    } else {
      int years = (diff.inDays / 365).floor();
      return '$years years ago';
    }
  }

  void selectLooker(Map<String, dynamic> looker) async {
    try {
      UserModel user = UserModel.fromJson(looker);
      userController.saveSelectedUser(user);
      Get.toNamed(AppRoutes.getMyAccountScreen());
    } catch (e){
      if (kDebugMode) {
        print('selectLooker exception $e');
      }
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
                                // profile image
                                Center(
                                  child:
                                  // profile image
                                  Obx(() {
                                    UserModel? user =
                                        userController.user.value;
                                    if (user != null) {
                                      return Container(
                                        height: isMobileView
                                            ? Dimensions.screenHeight /
                                            (932 / 100)
                                            : 200,
                                        width: isMobileView
                                            ? Dimensions.screenHeight /
                                            (932 / 100)
                                            : 200,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.mainColorDark,
                                            width: 2,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              user.profileImage !=
                                                  null
                                                  ? '${AppConstants.BASE_URL}/${user.profileImage}'
                                                  : '${AppConstants.BASE_URL}/public/media/profile/default.png',
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: isMobileView
                                            ? Dimensions.screenHeight /
                                            (932 / 100)
                                            : 200,
                                        width: isMobileView
                                            ? Dimensions.screenHeight /
                                            (932 / 100)
                                            : 200,
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
                                // space
                                SizedBox(
                                  height: isMobileView ? 15 : 25,
                                ),
                                // looked at me
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: isMobileView ? 10 : 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Looked At Me',
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
                                // looks
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: isMobileView ? 10 : 20,
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                      Map<String, dynamic> looker = looks[index];
                                      String? profileImage = looker['profile_image'];
                                      String? firstname = looker['firstname'];
                                      String? lastname = looker['lastname'];
                                      String username = looker['username'];
                                      String identity = looker['identity'];
                                      String? country = looker['country'];
                                      String timestamp = looker['created_at'];
                                      return GestureDetector(
                                        onTap: () {
                                          selectLooker(looker);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isMobileView ? 20 : 40,
                                            vertical: isMobileView ? 15 : 30,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                              color: AppColors.mainColor,
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // profile Image
                                              Container(
                                                height: isMobileView
                                                    ? Dimensions.screenHeight /
                                                    (932 / 75)
                                                    : 150,
                                                width: isMobileView
                                                    ? Dimensions.screenHeight /
                                                    (932 / 75)
                                                    : 150,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: AppColors.mainColorDark,
                                                    width: 2,
                                                  ),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      profileImage !=
                                                          null
                                                          ? '${AppConstants.BASE_URL}/$profileImage'
                                                          : '${AppConstants.BASE_URL}/public/media/profile/default.png',
                                                    ),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              // space
                                              SizedBox(
                                                width: isMobileView ? 12 : 20,
                                              ),
                                              // others
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    // name ... verified ... badge
                                                    Row(
                                                      children: [
                                                        // name
                                                        Text(
                                                          firstname != null && lastname != null
                                                              ? '$firstname $lastname'
                                                              : username,
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: isMobileView ? 12 : 14,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        // space
                                                        SizedBox(
                                                          width: isMobileView ? 7 : 10,
                                                        ),
                                                        // verified
                                                        Container(
                                                          height: isMobileView ? 15 : 18,
                                                          width: isMobileView ? 15 : 18,
                                                          decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage('assets/images/verified.png'),
                                                            ),
                                                          ),
                                                        ),
                                                        // space
                                                        SizedBox(
                                                          width: isMobileView ? 7 : 10,
                                                        ),
                                                        // badge
                                                        Container(
                                                          height: isMobileView ? 15 : 18,
                                                          width: isMobileView ? 15 : 18,
                                                          decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage('assets/images/badge.png'),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // space
                                                    SizedBox(
                                                      height: isMobileView ? 8 : 12,
                                                    ),
                                                    // identity and looking for
                                                    Row(
                                                      children: [
                                                        // identity
                                                        Text(
                                                          identity,
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: isMobileView ? 12 : 14,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        // space
                                                        SizedBox(
                                                          width: isMobileView ? 4 : 6,
                                                        ),
                                                        // looking for
                                                        Text(
                                                          'looking for',
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: isMobileView ? 12 : 14,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        // space
                                                        SizedBox(
                                                          width: isMobileView ? 4 : 6,
                                                        ),
                                                        // looking for man
                                                        if(looker['looking_man'] == 1)
                                                          Text(
                                                            'men, ',
                                                            style: TextStyle(
                                                              color: AppColors.blackColor,
                                                              fontSize: isMobileView ? 12 : 14,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        // looking for woman
                                                        if(looker['looking_woman'] == 1)
                                                          Text(
                                                            'women, ',
                                                            style: TextStyle(
                                                              color: AppColors.blackColor,
                                                              fontSize: isMobileView ? 12 : 14,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        // looking for couple
                                                        if(looker['looking_couple'] == 1)
                                                          Text(
                                                            'couples, ',
                                                            style: TextStyle(
                                                              color: AppColors.blackColor,
                                                              fontSize: isMobileView ? 12 : 14,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        // looking for couple m
                                                        if(looker['looking_couple_m'] == 1)
                                                          Text(
                                                            'male couples, ',
                                                            style: TextStyle(
                                                              color: AppColors.blackColor,
                                                              fontSize: isMobileView ? 12 : 14,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        // looking for couple f
                                                        if(looker['looking_couple_f'] == 1)
                                                          Text(
                                                            'female couples, ',
                                                            style: TextStyle(
                                                              color: AppColors.blackColor,
                                                              fontSize: isMobileView ? 12 : 14,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        // looking for couple
                                                        if(looker['looking_tv_ts'] == 1)
                                                          Text(
                                                            'TV/TS ',
                                                            style: TextStyle(
                                                              color: AppColors.blackColor,
                                                              fontSize: isMobileView ? 12 : 14,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    // space
                                                    SizedBox(
                                                      height: isMobileView ? 5 : 8,
                                                    ),
                                                    // country
                                                    if(country != null)
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Location: $country',
                                                            style: TextStyle(
                                                              color: AppColors.blackColor,
                                                              fontSize: isMobileView ? 10 : 12,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w300,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    // space
                                                    SizedBox(
                                                      height: isMobileView ? 8 : 12,
                                                    ),
                                                    // looked : time
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        // timer
                                                        Container(
                                                          height: isMobileView ? 15 : 18,
                                                          width: isMobileView ? 15 : 18,
                                                          decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage('assets/images/timer.png'),
                                                            ),
                                                          ),
                                                        ),
                                                        // space
                                                        SizedBox(
                                                          width: isMobileView ? 7 : 10,
                                                        ),
                                                        // looked
                                                        Text(
                                                          'Looked: ${timeAgo(timestamp)}',
                                                          style: TextStyle(
                                                            color: AppColors.blackColor,
                                                            fontSize: isMobileView ? 12 : 14,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: looks.length,
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
