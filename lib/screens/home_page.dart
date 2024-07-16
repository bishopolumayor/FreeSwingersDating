import 'package:flutter/material.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  void _openDrawer() {
    isMobileView ? _scaffoldKey.currentState?.openDrawer() : null;
  }

  bool isLoginMode = true;

  bool isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    // Get.offNamed(AppRoutes.getHomeScreen());
    // goToHomeScreen();
  }

  int selectedTab = 0;

  void switchTabs(int tab) {
    setState(() {
      selectedTab = tab;
    });

    if (tab == 0) {
      // Get.offNamed(AppRoutes.getHomeScreen());
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
      // Get.toNamed(AppRoutes.getMessagesScreen());
    }

  }

  void goToHomeScreen() async {
    if (isLoggedIn) {
      Get.offNamed(AppRoutes.getHomeScreen());
    }
  }

  void toggleLoginMode(bool newValue) {
    setState(() {
      isLoginMode = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      drawer: isNotWidest ? MobileSideBar(
        isLoginMode: isLoginMode,
      ) : null,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/fs_bg.png',
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SingleChildScrollView(
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
                  height: isMobileView ? 0 : 20,
                ),
                // main body
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // side bar
                      if (!isNotWidest)  SideBar(
                        isLoginMode: isLoginMode,
                      ),
                      // main content
                      HomeMainContainer(
                        isLoginMode: isLoginMode,
                        onToggle: toggleLoginMode,
                        openDrawer: () => _openDrawer(),
                      ),
                    ],
                  ),
                ),
                // footer
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Footer(),
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
