import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/conversations_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/models/conversation_model.dart';
import 'package:free_swingers_dating/models/message_model.dart';
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
import 'package:free_swingers_dating/widgets/message_text_field.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  final MessageModel messageModel;

  const MessageBubble({
    super.key,
    required this.messageModel,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  UserController userController = Get.find<UserController>();
  ConversationsController conversationsController =
      Get.find<ConversationsController>();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  String formatDatetime (DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    MessageModel message = widget.messageModel;
    UserModel sender = message.sender;
    bool isSender = sender.userId == userController.user.value!.userId;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isMobileView ? Dimensions.screenHeight / (932 / 8) : 10,
        horizontal: isMobileView ? Dimensions.screenWidth / (439 / 15) : 20,
      ),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(!isSender)
            Row(
              children: [
                // profile image
                Container(
                  height: isMobileView ? 35 : 50,
                  width: isMobileView ? 35 : 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade500,
                    image: DecorationImage(
                      image: NetworkImage(
                        sender.profileImage != null
                            ? '${AppConstants.BASE_URL}/${sender.profileImage}'
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
              ],
            ),
          Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: isMobileView ? Dimensions.screenHeight / (932 / 5) : 8,
                  horizontal:
                      isMobileView ? Dimensions.screenWidth / (439 / 8) : 15,
                ),
                constraints: BoxConstraints(
                  minHeight:
                      isMobileView ? Dimensions.screenHeight / (932 / 40) : 50,
                  minWidth:
                      isMobileView ? Dimensions.screenWidth / (439 / 80) : 150,
                  maxWidth:
                      isMobileView ? Dimensions.screenWidth / (439 / 300) : 650,
                ),
                decoration: BoxDecoration(
                  color: isSender ? AppColors.greyColor1 : AppColors.mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: isMobileView ? 15 : 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: isMobileView ? Dimensions.screenHeight / (932 / 4) : 6,
                  horizontal: isMobileView ? Dimensions.screenWidth / (439 / 10) : 15,
                ),
                child: Text(
                  formatDatetime(message.createdAt),
                  style: TextStyle(
                    color: AppColors.greyColor1,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Poppins',
                    fontSize: isMobileView ? 10 : 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
