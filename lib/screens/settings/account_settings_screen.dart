import 'dart:html';

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

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  SocketController socketController = Get.find<SocketController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var firstAgeController = TextEditingController();
  var secondAgeController = TextEditingController();
  var countryNameController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();

  bool smoke = false;
  bool drink = false;
  bool tattoo = false;
  bool piercing = false;
  bool lookingMan = false;
  bool lookingWoman = false;
  bool lookingCouple = false;
  bool lookingCoupleM = false;
  bool lookingCoupleF = false;
  bool lookingTvTs = false;
  bool meetSmokers = false;
  bool canTravel = false;
  bool canAccommodate = false;
  bool dp = false;
  bool groupSex = false;
  bool makingVideos = false;
  bool oral = false;
  bool rolePlay = false;
  bool safeSex = false;
  bool threesome = false;
  bool toys = false;

  XFile? profileImage;

  int _currentPage = 0;

  bool _isLoading = false;

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  int selectedTab = 0;

  String? _selectedIdentity;

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
    initializeAccountSettings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeAccountSettings() async {
    await authController.restoreSession();
    String userId = userController.user.value!.userId;
    String identity = userController.user.value!.identity;
    Map<String, dynamic> userDetails =
        await userController.getUserDetails(userId: userId);

    setState(() {
      countryNameController.text = userDetails['country'] ?? '';
      firstAgeController.text = userDetails['start_age'] ?? '';
      secondAgeController.text = userDetails['end_age'] ?? '';
      firstNameController.text = userDetails['firstname'] ?? '';
      lastNameController.text = userDetails['lastname'] ?? '';

      _selectedIdentity = identity;

      smoke = userDetails['smoke'] == 1;
      drink = userDetails['drink'] == 1;
      tattoo = userDetails['tattoo'] == 1;
      piercing = userDetails['piercing'] == 1;
      lookingMan = userDetails['looking_man'] == 1;
      lookingWoman = userDetails['looking_woman'] == 1;
      lookingCouple = userDetails['looking_couple'] == 1;
      lookingCoupleM = userDetails['looking_couple_m'] == 1;
      lookingCoupleF = userDetails['looking_couple_f'] == 1;
      lookingTvTs = userDetails['looking_tv_ts'] == 1;
      meetSmokers = userDetails['meet_smokers'] == 1;
      canTravel = userDetails['can_travel'] == 1;
      canAccommodate = userDetails['can_accommodate'] == 1;
      dp = userDetails['dp'] == 1;
      groupSex = userDetails['group_sex'] == 1;
      makingVideos = userDetails['making_videos'] == 1;
      oral = userDetails['oral'] == 1;
      rolePlay = userDetails['role_play'] == 1;
      safeSex = userDetails['safe_sex'] == 1;
      threesome = userDetails['threesome'] == 1;
      toys = userDetails['toys'] == 1;
    });
  }

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImage = image;
    });
  }

  Future<void> updateUserDetails() async {
    String userId = userController.user.value!.userId;

    setState(() {
      _isLoading = true;
    });

    bool success = await userController.updateUserDetails(
      userId: userId,
      country: countryNameController.text,
      startAge: firstAgeController.text,
      endAge: secondAgeController.text,
      smoke: smoke,
      drink: drink,
      tattoo: tattoo,
      piercing: piercing,
      lookingMan: lookingMan,
      lookingWoman: lookingWoman,
      lookingCouple: lookingCouple,
      lookingCoupleM: lookingCoupleM,
      lookingCoupleF: lookingCoupleF,
      lookingTvTs: lookingTvTs,
      meetSmokers: meetSmokers,
      canTravel: canTravel,
      canAccommodate: canAccommodate,
      dp: dp,
      groupSex: groupSex,
      makingVideos: makingVideos,
      oral: oral,
      rolePlay: rolePlay,
      safeSex: safeSex,
      threesome: threesome,
      toys: toys,
      profileImage: profileImage,
      identity: _selectedIdentity ?? '',
      firstname: firstNameController.text,
      lastname: lastNameController.text,
    );

    if (success) {
      await userController.fetchUser();
    }

    setState(() {
      _isLoading = false;
    });

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
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // profile image
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    pickProfileImage();
                                  },
                                  child: Stack(
                                    children: [
                                      // profile image
                                      Obx(() {
                                        UserModel? user =
                                            userController.user.value;
                                        if (user != null) {
                                          return Container(
                                            height: isMobileView
                                                ? Dimensions.screenHeight /
                                                    (932 / 180)
                                                : 300,
                                            width: isMobileView
                                                ? Dimensions.screenHeight /
                                                    (932 / 180)
                                                : 300,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.mainColorDark,
                                                width: 2,
                                              ),
                                              image: DecorationImage(
                                                image: profileImage != null
                                                    ? NetworkImage(
                                                        profileImage!.path)
                                                    : NetworkImage(
                                                        user.profileImage !=
                                                                null
                                                            ? '${AppConstants.BASE_URL}/${user.profileImage}'
                                                            : '${AppConstants.BASE_URL}/public/media/profile/default.png',
                                                      ) as ImageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            height: isMobileView
                                                ? Dimensions.screenHeight /
                                                    (932 / 180)
                                                : 300,
                                            width: isMobileView
                                                ? Dimensions.screenHeight /
                                                    (932 / 180)
                                                : 300,
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
                                      // edit icon
                                      Positioned(
                                        right: isMobileView ? 25 : 40,
                                        bottom: isMobileView ? 25 : 40,
                                        child: Container(
                                          height: isMobileView ? 25 : 40,
                                          width: isMobileView ? 25 : 40,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/images/edit.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // account details //// save changes
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // account details
                                        Text(
                                          'Account Details',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Poppins',
                                            fontSize: isMobileView ? 16 : 18,
                                          ),
                                        ),
                                        // save changes
                                        GestureDetector(
                                          onTap: () {
                                            updateUserDetails();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: isMobileView ? 7 : 10,
                                              horizontal:
                                                  isMobileView ? 10 : 15,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColors.mainColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Save changes',
                                                style: TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontFamily: 'Poppins',
                                                  fontSize:
                                                      isMobileView ? 15 : 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // line
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: isMobileView ? 3 : 6,
                                      ),
                                      width: double.maxFinite,
                                      height: 1.5,
                                      color: AppColors.mainColor,
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // your name
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Text(
                                  'Your Name',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: isMobileView ? 15 : 17,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // names
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                height: isMobileView ? 40 : 50,
                                child: Row(
                                  children: [
                                    // first name
                                    Expanded(
                                      child: TextField(
                                        controller: firstNameController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                color: AppColors.blackColor,
                                                width: 0.75,
                                              ),
                                            ),
                                            hintText: 'First name'),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: isMobileView ? 15 : 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    // space
                                    SizedBox(
                                      width: isMobileView ? 40 : 75,
                                    ),
                                    // last name
                                    Expanded(
                                      child: TextField(
                                        controller: lastNameController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                color: AppColors.blackColor,
                                                width: 0.75,
                                              ),
                                            ),
                                            hintText: 'Last name'),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: isMobileView ? 15 : 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // your identity
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Text(
                                  'Your Identity',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: isMobileView ? 15 : 17,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // identity
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: isMobileView ? 200 : 400,
                                    child: RadioListTile<String>(
                                      title: const Text('Male'),
                                      value: 'Male',
                                      groupValue: _selectedIdentity,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedIdentity = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: isMobileView ? 200 : 400,
                                    child: RadioListTile<String>(
                                      title: const Text('Female'),
                                      value: 'Female',
                                      groupValue: _selectedIdentity,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedIdentity = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: isMobileView ? 200 : 400,
                                    child: RadioListTile<String>(
                                      title: const Text('Couple (MF)'),
                                      value: 'Couple (MF)',
                                      groupValue: _selectedIdentity,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedIdentity = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: isMobileView ? 200 : 400,
                                    child: RadioListTile<String>(
                                      title: const Text('Male Couple (MM)'),
                                      value: 'Male Couple (MM)',
                                      groupValue: _selectedIdentity,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedIdentity = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: isMobileView ? 200 : 400,
                                    child: RadioListTile<String>(
                                      title: const Text('Female Couple (FF)'),
                                      value: 'Female Couple (FF)',
                                      groupValue: _selectedIdentity,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedIdentity = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: isMobileView ? 200 : 400,
                                    child: RadioListTile<String>(
                                      title: const Text('TV/TS/CD'),
                                      value: 'TV/TS/CD',
                                      groupValue: _selectedIdentity,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedIdentity = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // your country
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Text(
                                  'Your Country',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: isMobileView ? 15 : 17,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // your country
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                height: isMobileView ? 40 : 50,
                                width: isMobileView ? 200 : 250,
                                child: TextField(
                                  controller: countryNameController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                          color: AppColors.blackColor,
                                          width: 0.75,
                                        ),
                                      ),
                                      hintText: 'your country'),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: isMobileView ? 15 : 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // line
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 23 : 46,
                                ),
                                width: double.maxFinite,
                                height: 1.5,
                                color: AppColors.mainColor,
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // other details
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Text(
                                  'Other details',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: isMobileView ? 15 : 17,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // i smoke
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: smoke,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          smoke = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'I smoke',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
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
                              // i drink
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: drink,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          drink = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'I drink',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
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
                              // i have tattoos
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: tattoo,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          tattoo = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'I have tattoos',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
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
                              // i have piercings
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: piercing,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          piercing = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'I have piercings',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
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
                              // line
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 23 : 46,
                                ),
                                width: double.maxFinite,
                                height: 1.5,
                                color: AppColors.mainColor,
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // looking for
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Text(
                                  'Looking For',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: isMobileView ? 15 : 17,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // a man
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: lookingMan,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          lookingMan = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'A man',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // a woman
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: lookingWoman,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          lookingWoman = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'A woman',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // a couple
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: lookingCouple,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          lookingCouple = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'A couple (Male & Female)',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // a couple, 2 men
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: lookingCoupleM,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          lookingCoupleM = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'A couple (2 men)',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // a couple, 2 women
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: lookingCoupleF,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          lookingCoupleF = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'A couple (2 women)',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // tv/ts
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: lookingTvTs,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          lookingTvTs = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'Tv/Ts',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // line
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 23 : 46,
                                ),
                                width: double.maxFinite,
                                height: 1.5,
                                color: AppColors.mainColor,
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // between age
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Text(
                                  'Between Age',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: isMobileView ? 15 : 17,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // age range
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: isMobileView ? 40 : 50,
                                      width: isMobileView ? 60 : 85,
                                      child: TextField(
                                        controller: firstAgeController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                              color: AppColors.blackColor,
                                              width: 0.75,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: isMobileView ? 15 : 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'And',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: isMobileView ? 40 : 50,
                                      width: isMobileView ? 60 : 85,
                                      child: TextField(
                                        controller: secondAgeController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: const BorderSide(
                                              color: AppColors.blackColor,
                                              width: 0.75,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: isMobileView ? 15 : 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // line
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 23 : 46,
                                ),
                                width: double.maxFinite,
                                height: 1.5,
                                color: AppColors.mainColor,
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // smokers
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: meetSmokers,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          meetSmokers = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'I can meet smokers',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // travel
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: canTravel,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          canTravel = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'I can travel',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // accommodate
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: canAccommodate,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          canAccommodate = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'I can accommodate',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
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
                              // line
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 23 : 46,
                                ),
                                width: double.maxFinite,
                                height: 1.5,
                                color: AppColors.mainColor,
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 15 : 25,
                              ),
                              // interests
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Text(
                                  'Interests',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: isMobileView ? 15 : 17,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // DP
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: dp,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          dp = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'DP',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // group sex
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: groupSex,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          groupSex = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'Group sex',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // making videos
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: makingVideos,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          makingVideos = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'Making videos',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // oral
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: oral,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          oral = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'Oral',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // role play
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: rolePlay,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          rolePlay = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'Role Play',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // safe sex
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: safeSex,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          safeSex = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'Safe sex',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // threesome
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: threesome,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          threesome = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'Threesome',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
                              ),
                              // toys
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: toys,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          toys = value!;
                                        });
                                      },
                                      activeColor: AppColors.mainColor,
                                    ),
                                    SizedBox(
                                      width: isMobileView ? 5 : 10,
                                    ),
                                    Text(
                                      'Toys',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: isMobileView ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // space
                              SizedBox(
                                height: isMobileView ? 10 : 15,
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
          if (_isLoading)
            const Center(
              child: BarLoadingAnimation(),
            ),
        ],
      ),
    );
  }
}
