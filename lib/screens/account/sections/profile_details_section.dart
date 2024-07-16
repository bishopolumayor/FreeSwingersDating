import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/conversations_controller.dart';
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

class ProfileDetailsSection extends StatefulWidget {
  const ProfileDetailsSection({super.key});

  @override
  State<ProfileDetailsSection> createState() => _ProfileDetailsSectionState();
}

class _ProfileDetailsSectionState extends State<ProfileDetailsSection> {
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  ConversationsController conversationsController =
      Get.find<ConversationsController>();

  var firstAgeController = TextEditingController();
  var secondAgeController = TextEditingController();
  var countryNameController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var usernameController = TextEditingController();

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

  bool isFriends = true;
  bool canMessage = false;

  bool _isLoading = false;

  String? _selectedIdentity;

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  UserModel? userModel;

  String frnTxt = 'Add friend';

  void initializeAccountSettings() async {
    await authController.restoreSession();
    UserModel user;
    if (userController.selectedUser.value != null) {
      user = userController.selectedUser.value!;
      bool friend =
          userController.myFriends.any((e) => e.userId == user.userId);

      setState(() {
        isFriends = friend;
        canMessage = friend;
      });

      if (user.userId == userController.user.value!.userId) {
        setState(() {
          isFriends = true;
          canMessage = false;
        });
      }
    } else {
      user = userController.user.value!;
    }

    userModel = user;

    String userId = user.userId;
    String identity = user.identity;
    Map<String, dynamic> userDetails =
        await userController.getUserDetails(userId: userId);

    setState(() {
      countryNameController.text = userDetails['country'] ?? '';
      firstAgeController.text = userDetails['start_age'] ?? '';
      secondAgeController.text = userDetails['end_age'] ?? '';
      firstNameController.text = userDetails['firstname'] ?? '';
      lastNameController.text = userDetails['lastname'] ?? '';
      usernameController.text = userDetails['username'] ?? '';

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

  void addFriend() async {
    setState(() {
      _isLoading = true;
    });
    String receiverId = userModel?.userId ?? '';
    bool success =
        await userController.sendFriendRequest(receiverId: receiverId);
    if (success) {
      setState(() {
        frnTxt = 'Request Sent';
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void messageFriend() async {
    setState(() {
      _isLoading = true;
    });
    String receiverId = userModel!.userId;

    bool isExisting = conversationsController.conversations.any((conversation) => conversation.secondUser.userId == receiverId);

    if(!isExisting) {
      bool success = await conversationsController.createConversationBool(receiverId);
      if(success){
        userController.removeSelectedUser();
        Get.toNamed(AppRoutes.getMessagesScreen());
      }
    } else {
      userController.removeSelectedUser();
      Get.toNamed(AppRoutes.getMessagesScreen());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeAccountSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isFriends)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        addFriend();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobileView ? 5 / 1.5 : 8 / 1.5,
                          horizontal: isMobileView ? 10 / 1.5 : 15 / 1.5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.mainColor,
                        ),
                        width: isMobileView
                            ? Dimensions.screenWidth / (430 / 150)
                            : 200,
                        child: Center(
                          child: Text(
                            frnTxt,
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: isMobileView ? 16 : 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                  ],
                ),
              if (canMessage)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        messageFriend();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobileView ? 5 / 1.5 : 8 / 1.5,
                          horizontal: isMobileView ? 10 / 1.5 : 15 / 1.5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.mainColor,
                        ),
                        width: isMobileView
                            ? Dimensions.screenWidth / (430 / 150)
                            : 200,
                        child: Center(
                          child: Text(
                            'Message',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: isMobileView ? 16 : 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                  ],
                ),
              // about
              Text(
                'About',
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // name
              Text(
                'Name : ${firstNameController.text} ${lastNameController.text}',
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // username
              Text(
                'Username: ${usernameController.text}',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              /* // space
          SizedBox(
            height: isMobileView ? 10 : 20,
          ),
          // joined
          Text(
            'Joined: over a year ago',
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: isMobileView ? 16 : 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
            ),
          ),*/
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // long line
              Container(
                height: 1.5,
                width: double.maxFinite,
                color: AppColors.greyColor1,
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // about
              Text(
                'Description',
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // age - sexuality
              Text(
                '${_selectedIdentity}',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              /*// space
          SizedBox(
            height: isMobileView ? 10 : 20,
          ),
          // height
          Text(
            '5\'7" 170cm',
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: isMobileView ? 16 : 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
            ),
          ),
          // space
          SizedBox(
            height: isMobileView ? 10 : 20,
          ),
          // athletic
          Text(
            'Athletic',
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: isMobileView ? 16 : 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
            ),
          ),*/
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // smoker
              Text(
                smoke ? 'Smokes' : 'Non Smoker',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // drinker
              Text(
                drink ? 'Social drinker' : 'Non drinker',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // tattoos
              Text(
                tattoo ? 'Has tattoos' : 'No tattoos',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // piercings
              Text(
                piercing ? 'Has piercings' : 'No piercings',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // long line
              Container(
                height: 1.5,
                width: double.maxFinite,
                color: AppColors.greyColor1,
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // looking for
              Text(
                'Looking for',
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (lookingMan)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Men',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (lookingWoman)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Women',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (lookingCouple)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Couple',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (lookingCoupleM)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Couple (Men)',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (lookingCoupleF)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Couple (Women)',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (lookingTvTs)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Couple (Tv/Ts)',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // age looking for
              Text(
                'Aged from ${firstAgeController.text} to ${secondAgeController.text}',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // smokers looking for
              Text(
                meetSmokers ? 'Can meet smokers' : 'won\'t meet smokers',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // long line
              Container(
                height: 1.5,
                width: double.maxFinite,
                color: AppColors.greyColor1,
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // meeting
              Text(
                'Meeting',
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // accommodation
              Text(
                canAccommodate ? 'Can accommodate' : 'Cannot accommodate',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // travel
              Text(
                canTravel ? 'Can travel' : 'Cannot travel',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // long line
              Container(
                height: 1.5,
                width: double.maxFinite,
                color: AppColors.greyColor1,
              ),
              // space
              SizedBox(
                height: isMobileView ? 10 : 20,
              ),
              // interests
              Text(
                'Interests',
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: isMobileView ? 16 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (dp)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'DP',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (groupSex)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Group Sex',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (makingVideos)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Making Videos',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (oral)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Oral',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (rolePlay)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Role Play',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (safeSex)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Safe Sex',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (threesome)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Threesome',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              if (toys)
                Column(
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // sexuality looking for
                    Text(
                      'Toys',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 16 : 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
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
    );
  }
}
