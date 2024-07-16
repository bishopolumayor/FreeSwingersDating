import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/models/hot_pictures_model.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/screens/hot_pictures/sections/hot_pictures_side_bar.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class HotPicturesScreen extends StatefulWidget {
  const HotPicturesScreen({super.key});

  @override
  State<HotPicturesScreen> createState() => _HotPicturesScreenState();
}

class _HotPicturesScreenState extends State<HotPicturesScreen> {

  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  PostsController postsController = Get.find<PostsController>();
  SocketController socketController = Get.find<SocketController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  VideoPlayerController? _videoPlayerController;

  int _currentPage = 0;

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  bool _isLoading = false;

  String selectedIdentity = 'All';

  int selectedTab = 2;

  int selectedSection = 0;

  bool isVideo(String mediaPath) {
    const videoExtensions = ['mp4', 'mov', 'wmv', 'avi', 'mkv', 'flv', 'webm'];
    String extension = mediaPath.split('.').last.toLowerCase();
    return videoExtensions.contains(extension);
  }

  bool isImage(String mediaPath) {
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    String extension = mediaPath.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  void _playVideo(String videoPath) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.network(videoPath)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: AspectRatio(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController!),
        ),
      ),
    );
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Image.network(imagePath, fit: BoxFit.cover),
      ),
    );
  }

  void switchSection(int section){
    setState(() {
      selectedSection = section;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeHotPicturesScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeHotPicturesScreen() async {
    setState(() {
      _isLoading = true;
    });
    await authController.restoreSession(returnToHome: false);
    await postsController.fetchHotPictures();
    setState(() {
      _isLoading = false;
    });
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
      // Get.offNamed(AppRoutes.getHotPictures());
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

    userController.removeSelectedUser();
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
        _closeDrawer();
      case 1:
        _closeDrawer();

      case 4 :
        _closeDrawer();
      case 7:
        _closeDrawer();
    }

    _closeDrawer();
    userController.removeSelectedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: HotPicturesSideBar(
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
                        child: HotPicturesSideBar(
                          changePage: _changePage,
                        ),
                      ),
                    // main body
                    Expanded(
                      child: Container(
                        color: Colors.grey.shade200,
                        height: isMobileView ? Dimensions.screenHeight / (932 / 810) : Dimensions.heightRatio(860),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(_isLoading)
                                const LinearProgressIndicator(
                                  color: AppColors.mainColor,
                                  backgroundColor: AppColors.mainColorLight,
                                  minHeight: 5,
                                ),
                              // space
                              SizedBox(
                                height:  isMobileView ? 20 : 40,
                              ),
                              // gallery
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Text(
                                  'Gallery',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: isMobileView ? 20 : 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.mainColor,
                                  ),
                                ),
                              ),
                              // space
                              SizedBox(
                                height:  isMobileView ? 1 : 2,
                              ),
                              // line
                              Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: isMobileView ? 20 : 40,
                                  ),
                                height: 3,
                                color: AppColors.mainColor,
                              ),
                              // space
                              SizedBox(
                                height:  isMobileView ? 10 : 20,
                              ),
                              // updated by
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Text(
                                  'Updated by:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: isMobileView ? 16 : 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                              // select identity
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                               width: isMobileView ? 200 : 250,
                                child: DropdownButtonFormField<String>(
                                  value: selectedIdentity,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedIdentity = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'All',
                                    'Male',
                                    'Female',
                                    'Couple (MF)',
                                    'Male Couple (MM)',
                                    'Female Couple (FM)',
                                    'TV/TD/CD'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  icon: Icon(Icons.arrow_drop_down),
                                ),
                              ),
                              // space
                              SizedBox(
                                height:  isMobileView ? 10 : 20,
                              ),
                              // images
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobileView ? 20 : 40,
                                ),
                                child: Obx((){
                                  List<HotPicturesModel> unFilteredHotPictures = postsController.hotPictures;
                                  List<HotPicturesModel> hotPictures = selectedIdentity == 'All'
                                      ? unFilteredHotPictures
                                      : unFilteredHotPictures.where((unFilteredHotPictures) => unFilteredHotPictures.identity == selectedIdentity).toList();
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isMobileView ? 2 : 4,
                                      crossAxisSpacing: isMobileView ? 10 : 20,
                                      mainAxisSpacing:  isMobileView ? 10 : 20,
                                    ),
                                    itemBuilder: (context, index) {
                                      HotPicturesModel hotPicture = hotPictures[index];
                                     /* return Column(
                                        children: [
                                          isImage(hotPicture.mediaUrl)
                                              ? GestureDetector(
                                            onTap: () {
                                              _showImageDialog('${AppConstants.BASE_URL}/${hotPicture.mediaUrl}');
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${AppConstants.BASE_URL}/${hotPicture.mediaUrl}'),
                                                ),
                                              ),
                                            ),
                                          )
                                              : isVideo(hotPicture.mediaUrl)
                                              ? GestureDetector(
                                            onTap: () {
                                              _playVideo('${AppConstants.BASE_URL}/${hotPicture.mediaUrl}');
                                            },
                                            child: Container(
                                              width: isMobileView
                                                  ? double.maxFinite
                                                  : Dimensions.widthRatio(500),
                                              height: isMobileView ? 280 : Dimensions.widthRatio(500),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: const Icon(
                                                Icons.play_circle_outline_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                              : Container(
                                            width: isMobileView
                                                ? double.maxFinite
                                                : Dimensions.widthRatio(500),
                                            height: isMobileView ? 280 : Dimensions.widthRatio(500),
                                            color: Colors.white,
                                          ),
                                          // name ... verified ... badge
                                          Row(
                                            children: [
                                              // name
                                              Text(
                                                hotPicture.firstname.isNotEmpty && hotPicture.lastname.isNotEmpty
                                                    ? '${hotPicture.firstname} ${hotPicture.lastname}'
                                                    : hotPicture.username,
                                                style: TextStyle(
                                                  color: AppColors.mainColor,
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
                                        ],
                                      );*/
                                      return  isImage(hotPicture.mediaUrl)
                                          ? GestureDetector(
                                        onTap: () {
                                          _showImageDialog('${AppConstants.BASE_URL}/${hotPicture.mediaUrl}');
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height : isMobileView ? 150 : 200,
                                              decoration: BoxDecoration(
                                                color: AppColors.mainColorLight,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${AppConstants.BASE_URL}/${hotPicture.mediaUrl}'),
                                                ),
                                              ),
                                            ),
                                            // space
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            // name ... verified ... badge
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                // name
                                                Text(
                                                  hotPicture.firstname.isNotEmpty && hotPicture.lastname.isNotEmpty
                                                      ? '${hotPicture.firstname} ${hotPicture.lastname}'
                                                      : hotPicture.username,
                                                  style: TextStyle(
                                                    color: AppColors.mainColor,
                                                    fontSize: isMobileView ? 10 : 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                // space
                                                SizedBox(
                                                  width: isMobileView ? 3 : 5,
                                                ),
                                                // verified
                                                Container(
                                                  height: isMobileView ? 10 : 14,
                                                  width: isMobileView ? 10 : 14,
                                                  decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage('assets/images/verified.png'),
                                                    ),
                                                  ),
                                                ),
                                                // space
                                                SizedBox(
                                                  width: isMobileView ? 3 : 5,
                                                ),
                                                // badge
                                                Container(
                                                  height: isMobileView ? 10 : 14,
                                                  width: isMobileView ? 10 : 14,
                                                  decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage('assets/images/badge.png'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // identity
                                            Text(
                                              hotPicture.identity,
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: isMobileView ? 8 : 10,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          : isVideo(hotPicture.mediaUrl)
                                          ? GestureDetector(
                                        onTap: () {
                                          _playVideo('${AppConstants.BASE_URL}/${hotPicture.mediaUrl}');
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height : isMobileView ? 150 : 200,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: const Icon(
                                                Icons.play_circle_outline_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                            // space
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            // name ... verified ... badge
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                // name
                                                Text(
                                                  hotPicture.firstname.isNotEmpty && hotPicture.lastname.isNotEmpty
                                                      ? '${hotPicture.firstname} ${hotPicture.lastname}'
                                                      : hotPicture.username,
                                                  style: TextStyle(
                                                    color: AppColors.mainColor,
                                                    fontSize: isMobileView ? 10 : 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                // space
                                                SizedBox(
                                                  width: isMobileView ? 3 : 5,
                                                ),
                                                // verified
                                                Container(
                                                  height: isMobileView ? 10 : 14,
                                                  width: isMobileView ? 10 : 14,
                                                  decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage('assets/images/verified.png'),
                                                    ),
                                                  ),
                                                ),
                                                // space
                                                SizedBox(
                                                  width: isMobileView ? 3 : 5,
                                                ),
                                                // badge
                                                Container(
                                                  height: isMobileView ? 10 : 14,
                                                  width: isMobileView ? 10 : 14,
                                                  decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage('assets/images/badge.png'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // identity
                                            Text(
                                              hotPicture.identity,
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: isMobileView ? 8 : 10,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          : Container(
                                        height : isMobileView ? 150 : 200,
                                        color: Colors.white,
                                      );
                                    },
                                    itemCount: hotPictures.length,
                                  );
                                }),
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
