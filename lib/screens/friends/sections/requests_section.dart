import 'package:flutter/cupertino.dart';
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

class FriendRequestsSection extends StatefulWidget {
  const FriendRequestsSection({super.key});

  @override
  State<FriendRequestsSection> createState() => _FriendRequestsSectionState();
}

class _FriendRequestsSectionState extends State<FriendRequestsSection> {
  UserController userController = Get.find<UserController>();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  bool _isLoading = false;

  List<dynamic> requests = [];

  @override
  void initState() {
    super.initState();
    initializeFriends();
  }

  void initializeFriends() async {
    UserModel user = userController.user.value!;
    String userId = user.userId;

    setState(() {
      _isLoading = true;
    });
    List<dynamic> friendRequests =
        await userController.getFriendRequests(userId: userId);

    setState(() {
      requests = friendRequests;
      _isLoading = false;
    });
  }

  void respondToRequest(String requestId, int status) async {
    setState(() {
      _isLoading = true;
    });
    bool success = await userController.respondFriendRequest(
      requestId: requestId,
      status: status,
    );
    if(success) {
      initializeFriends();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var userData = requests[index]['sender'];
              String requestId = requests[index]['request_id'];
              UserModel user = UserModel.fromJson(userData);
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isMobileView ? 10 : 15,
                  horizontal: isMobileView ? 10 : 15,
                ),
                child: GestureDetector(
                  onTap: () {
                    userController.saveSelectedUser(user);
                    Get.toNamed(AppRoutes.getMyAccountScreen());
                  },
                  child: Row(
                    children: [
                      // profile image
                      Container(
                        height: isMobileView
                            ? Dimensions.screenHeight / (932 / 50)
                            : 90,
                        width: isMobileView
                            ? Dimensions.screenHeight / (932 / 50)
                            : 90,
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
                      ),
                      // space
                      SizedBox(
                        width: isMobileView ? 15 : 20,
                      ),
                      // name
                      Text(
                        user.firstName != null && user.lastName != null
                            ? '${user.firstName} ${user.lastName}'
                            : user.username,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: isMobileView ? 16 : 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // space
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Column(
                        children: [
                          // accept
                          GestureDetector(
                            onTap: () {
                              respondToRequest(requestId, 1);
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
                              child: Center(
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: isMobileView ? 13 : 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // space
                          SizedBox(
                            height: isMobileView ? 8 : 12,
                          ),
                          // decline
                          GestureDetector(
                            onTap: () {
                              respondToRequest(requestId, 2);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: isMobileView ? 5 / 1.5 : 8 / 1.5,
                                horizontal: isMobileView ? 10 / 1.5 : 15 / 1.5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  'Decline',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: isMobileView ? 13 : 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: requests.length,
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
