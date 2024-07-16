import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/conversations_controller.dart';
import 'package:free_swingers_dating/models/conversation_model.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/screens/chat/sections/chats_container.dart';
import 'package:free_swingers_dating/screens/chat/sections/conversations_component.dart';
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

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  AuthController authController = Get.find<AuthController>();
  ConversationsController conversationsController =
      Get.find<ConversationsController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  int selectedTab = 6;

  int _currentPage = 1;

  ConversationModel? currentConversation;

  @override
  initState() {
    super.initState();
    initializeMessageScreen();
  }

  Future<void> initializeMessageScreen() async {
    await authController.restoreSession();
    if (conversationsController.conversations.isNotEmpty) {
      ConversationModel conversationModel = conversationsController.conversations[0];

      setState(() {
        currentConversation = conversationModel;
      });
    }
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
      Get.offNamed(AppRoutes.getEventsScreen());
    }

    if(tab == 4){
      Get.offNamed(AppRoutes.getClubsScreen());
    }

    if (tab == 6) {
      // setState(() {
      //   _currentPage = 1;
      // });
      // Get.toNamed(AppRoutes.getMessagesScreen());
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
  }

  void _openConversation(ConversationModel conversationModel) {
    setState(() {
      _mobileChatScreenOpen = true;
      currentConversation = conversationModel;
    });
    String conversationId = conversationModel.conversationId;
    conversationsController.getMessagesWithSocket(conversationId);
  }

  void _closeConversation() {
    setState(() {
      _mobileChatScreenOpen = false;
    });
  }

  bool _mobileChatScreenOpen = false;

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
                Expanded(
                  child: isMobileView
                      ? ConversationsComponent(
                          openConversation: _openConversation,
                        )
                      : Row(
                          children: [
                            ConversationsComponent(
                              openConversation: _openConversation,
                            ),
                            Expanded(
                              child: currentConversation != null
                                  ? ChatsContainer(
                                      conversationModel: currentConversation!,
                                      closeConversation: _closeConversation,
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          if (isMobileView && _mobileChatScreenOpen)
            currentConversation != null
                ? ChatsContainer(
                    conversationModel: currentConversation!,
                    closeConversation: _closeConversation,
                  )
                : const SizedBox(),
        ],
      ),
    );
  }
}
