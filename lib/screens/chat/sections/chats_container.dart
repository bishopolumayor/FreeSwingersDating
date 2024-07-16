import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/conversations_controller.dart';
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
import 'package:free_swingers_dating/widgets/message_bubble.dart';
import 'package:free_swingers_dating/widgets/message_text_field.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';

class ChatsContainer extends StatefulWidget {
  final ConversationModel conversationModel;
  final Function closeConversation;

  const ChatsContainer({
    super.key,
    required this.conversationModel,
    required this.closeConversation,
  });

  @override
  State<ChatsContainer> createState() => _ChatsContainerState();
}

class _ChatsContainerState extends State<ChatsContainer> {
  ConversationsController conversationsController =
      Get.find<ConversationsController>();

  final ScrollController _scrollController = ScrollController();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  TextEditingController textController = TextEditingController();

  @override
  initState() {
    super.initState();
    initializeMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate,
        );
      }
    });
  }

  Future<void> initializeMessages() async {
    ConversationModel conversation = widget.conversationModel;
    String conversationId = conversation.conversationId;
    conversationsController.getMessagesWithSocket(conversationId);
  }

  Future<void> sendMessage(String text) async {
    String conversationId = widget.conversationModel.conversationId;
    await conversationsController.sendMessageWithSocket(conversationId, text);
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    ConversationModel conversation = widget.conversationModel;
    UserModel conversationUser = conversation.secondUser;
    return Container(
      color: Colors.grey.shade300,
      child: Column(
        children: [
          // top bar
          Container(
            height: isMobileView ? 80 : 120,
            padding: EdgeInsets.symmetric(
              horizontal: isMobileView ? 15 : 25,
              vertical: isMobileView ? 8 : 15,
            ),
            color: Colors.white,
            child: Row(
              children: [
                // arrow back
                if (isMobileView)
                  GestureDetector(
                    onTap: () => widget.closeConversation(),
                    child: const SizedBox(
                      height: 40,
                      width: 30,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.mainColor,
                        size: 24,
                      ),
                    ),
                  ),
                // space
                if (isMobileView)
                  SizedBox(
                    width: isMobileView ? 8 : 12,
                  ),
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
                  width: isMobileView ? 8 : 12,
                ),
                // name and last seen
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name
                    Text(
                      conversationUser.firstName != null &&
                              conversationUser.lastName != null
                          ? '${conversationUser.firstName} ${conversationUser.lastName}'
                          : conversationUser.username,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: isMobileView ? 16 : 18,
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 2 : 5,
                    ),
                    // last seen
                    Text(
                      'Last seen 02:55 pm',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: isMobileView ? 16 : 18,
                      ),
                    ),
                  ],
                ),
                // space
                SizedBox(
                  width: isMobileView ? 8 : 12,
                ),
                // space
                const Expanded(
                  child: SizedBox(),
                ),
                // video call
                Container(
                  height: isMobileView ? 20 : 35,
                  width: isMobileView ? 20 : 35,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/vc.png',
                      ),
                    ),
                  ),
                ),
                // space
                SizedBox(
                  width: isMobileView ? 8 : 12,
                ),
                // voice call
                Container(
                  height: isMobileView ? 20 : 35,
                  width: isMobileView ? 20 : 35,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/phone.png',
                      ),
                    ),
                  ),
                ),
                // space
                SizedBox(
                  width: isMobileView ? 10 : 15,
                ),
                // more
                SizedBox(
                  height: isMobileView ? 30 : 45,
                  width: isMobileView ? 30 : 45,
                  child: const Center(
                    child: Icon(
                      Icons.more_vert,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // messages
          Obx(() {
            List<MessageModel> messages =
                conversationsController.selectedMessages.reversed.toList();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                );
              }
            });

            return Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return MessageBubble(
                    messageModel: messages[index],
                  );
                },
                itemCount: messages.length,
              ),
            );
          }),
          // message text field
          MessageTextField(
            textController: textController,
            onMessageSent: sendMessage,
          ),
        ],
      ),
    );
  }
}
