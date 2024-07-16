import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/conversations_controller.dart';
import 'package:free_swingers_dating/models/conversation_model.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/screens/home/sections/home_feed.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/conversation_container.dart';
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/home_side_bar.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';

class ConversationsComponent extends StatefulWidget {
  final Function(ConversationModel) openConversation;

  const ConversationsComponent({
    super.key,
    required this.openConversation,
  });

  @override
  State<ConversationsComponent> createState() => _ConversationsComponentState();
}

class _ConversationsComponentState extends State<ConversationsComponent> {
  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  ConversationsController conversationsController =
      Get.find<ConversationsController>();

  @override
  initState() {
    super.initState();
    initializeConversationsComponent();
  }

  Future<void> initializeConversationsComponent() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      width: isMobileView ? double.maxFinite : 500,
      padding: EdgeInsets.symmetric(
        horizontal: isMobileView ? 10 : 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // space
          SizedBox(
            height: isMobileView ? 15 : 25,
          ),
          // messages
          Text(
            'MESSAGES',
            style: TextStyle(
              color: AppColors.mainColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: isMobileView ? 16 : 20,
              letterSpacing: isMobileView ? 5 : 7,
            ),
          ),
          // space
          SizedBox(
            height: isMobileView ? 15 : 20,
          ),
          // conversations
          Obx(() {
            List<ConversationModel> conversations =
                conversationsController.conversations;
            return Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => widget.openConversation(conversations[index]),
                    child: ConversationContainer(
                      conversationModel: conversations[index],
                    ),
                  );
                },
                itemCount: conversations.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}
