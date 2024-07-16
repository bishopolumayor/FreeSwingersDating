import 'package:flutter/material.dart';
import 'package:free_swingers_dating/models/conversation_model.dart';
import 'package:free_swingers_dating/models/user_model.dart';
import 'package:free_swingers_dating/routes/routes.dart';
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

class ConversationContainer extends StatefulWidget {
  final ConversationModel conversationModel;

  const ConversationContainer({
    super.key,
    required this.conversationModel,
  });

  @override
  State<ConversationContainer> createState() => _ConversationContainerState();
}

class _ConversationContainerState extends State<ConversationContainer> {
  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  @override
  Widget build(BuildContext context) {
    ConversationModel conversation = widget.conversationModel;
    UserModel conversationUser = conversation.secondUser;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isMobileView ? 8 : 10,
      ),
      padding: EdgeInsets.symmetric(
        vertical: isMobileView ? 10 : 15,
        horizontal: isMobileView ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // profile image
          Container(
            height: isMobileView ? 60 : 83,
            width: isMobileView ? 60 : 83,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade500,
              image: DecorationImage(
                image: NetworkImage(
                  conversationUser.profileImage != null
                      ? '${AppConstants.BASE_URL}/${conversationUser.profileImage}'
                      : '${AppConstants.BASE_URL}/public/media/profile/default.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // space
          SizedBox(
            width: isMobileView ? 10 : 12,
          ),
          // name and last message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name
                Text(
                  conversationUser.firstName != null &&
                          conversationUser.lastName != null
                      ? '${conversationUser.firstName} ${conversationUser.lastName}'
                      : conversationUser.username,
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: isMobileView ? 16 : 18,
                  ),
                ),
                // space
                SizedBox(
                  height: isMobileView ? 5 : 7,
                ),
                // text
                Text(
                  conversation.lastMessage != null
                      ? conversation.lastMessage!.isNotEmpty
                          ? conversation.lastMessage!
                          : 'Start conversation'
                      : 'Start conversation',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor,
                    fontSize: isMobileView ? 14 : 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
