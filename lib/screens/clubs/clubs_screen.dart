import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/controllers/clubs_controller.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/screens/clubs/sections/clubs_side_bar.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/bar_loading_animation.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:get/get.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  PostsController postsController = Get.find<PostsController>();
  SocketController socketController = Get.find<SocketController>();
  ClubsController clubsController = Get.find<ClubsController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var clubNameController = TextEditingController();
  var clubEmailController = TextEditingController();
  var clubLinkController = TextEditingController();
  var clubShortDescriptionController = TextEditingController();
  var clubLongDescriptionController = TextEditingController();

  var clubReviewCommentController = TextEditingController();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  bool _isLoading = false;

  int _currentPage = 0;

  int? selectedClubRating;

  String? selectedClubLocation;
  String? currentClubLocation;

  int selectedTab = 4;

  int selectedSection = 0;

  List<dynamic> clubs = [];
  List<dynamic> selectedClubs = [];

  Map<String, dynamic>? selectedClubDetails;

  bool isClubSelected = false;
  bool isCreateClubMode = false;
  bool isAddReviewMode = false;

  void switchSection(int section) {
    setState(() {
      selectedSection = section;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeClubsScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeClubsScreen() async {
    setState(() {
      _isLoading = true;
    });
    await authController.restoreSession(returnToHome: false);
    List<dynamic>? clubsData = await clubsController.getClubs();

    if (clubsData != null) {
      setState(() {
        clubs = clubsData;
        selectedClubs = clubs;
      });
    }

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
      Get.offNamed(AppRoutes.getHotPictures());
    }

    if (tab == 3) {
      Get.offNamed(AppRoutes.getEventsScreen());
    }

    if(tab == 4){
      // Get.offNamed(AppRoutes.getClubsScreen());
    }

    if (tab == 6) {
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
    if(page == 1){
      setState(() {
        isClubSelected = false;
        selectedClubDetails = null;
        isCreateClubMode = true;
      });
    } else if(page == 2) {
      setState(() {
        isClubSelected = false;
        selectedClubDetails = null;
      });
    }
  }

  bool validateClubCreate() {
    if (clubNameController.text.isEmpty ||
        clubEmailController.text.isEmpty ||
        clubLinkController.text.isEmpty ||
        clubShortDescriptionController.text.isEmpty ||
        clubLongDescriptionController.text.isEmpty ||
        selectedClubLocation == null) {
      Get.snackbar('Incomplete inputs', 'Enter all inputs');
      return false;
    }
    return true;
  }

  bool validateSendReview(){
    if(clubReviewCommentController.text.isEmpty || selectedClubRating == null){
      Get.snackbar('Incomplete inputs', 'Enter your comment and select your rating');
      return false;
    }
    return true;
  }

  void submitClubRequest() async {
    if (validateClubCreate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      await clubsController.createClub(
        name: clubNameController.text,
        shortDescription: clubShortDescriptionController.text,
        longDescription: clubLongDescriptionController.text,
        clubLink: clubLinkController.text,
        clubEmail: clubEmailController.text,
        clubLocation: selectedClubLocation!,
      );
      initializeClubsScreen();
      setState(() {
        _isLoading = false;
        isCreateClubMode = false;
      });
    }
  }

  void openClub(String clubId) async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic>? clubDetailsData = await clubsController.getClubDetails(clubId: clubId);

    if(clubDetailsData != null){
      setState(() {
        selectedClubDetails = clubDetailsData;
        isClubSelected = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void closeClub() async {
    setState(() {
      isClubSelected = false;
      selectedClubDetails = null;
    });
  }

  void openReview() async {
    setState(() {
      isAddReviewMode = true;
    });
  }

  void closeClubReview() async {
    setState(() {
      isAddReviewMode = false;
      selectedClubRating = null;
    });
  }

  void sendReview (String clubId) async {
    if(validateSendReview() && !_isLoading){
      setState(() {
        _isLoading = true;
      });

      await clubsController.reviewClub(comment: clubReviewCommentController.text, rating: selectedClubRating!, clubId: clubId,);

      Map<String, dynamic>? clubDetailsData = await clubsController.getClubDetails(clubId: clubId);

      if(clubDetailsData != null){
        setState(() {
          selectedClubDetails = clubDetailsData;
          isClubSelected = true;
        });
      }

      setState(() {
        _isLoading = false;
        selectedClubRating = null;
        isAddReviewMode = false;
      });
    }
  }

  void filterClubs(){
    if (currentClubLocation != null){
      if (currentClubLocation == 'All'){
        setState(() {
          selectedClubs = clubs;
        });
      } else {
        List<dynamic> newClubs = clubs.where((club) => club['location'] == currentClubLocation).toList();
        setState(() {
          selectedClubs = newClubs;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ClubSideBar(
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
                    Expanded(
                      child: Container(
                        color: Colors.grey.shade200,
                        height: isMobileView
                            ? Dimensions.screenHeight / (932 / 810)
                            : Dimensions.heightRatio(860),
                        child: !isCreateClubMode
                            ? !isClubSelected
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        if (_isLoading)
                                          const LinearProgressIndicator(
                                            color: AppColors.mainColor,
                                            backgroundColor:
                                                AppColors.mainColorLight,
                                            minHeight: 5,
                                          ),
                                        // space
                                        SizedBox(
                                          height: isMobileView ? 10 : 20,
                                        ),
                                        // submit registration request
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isCreateClubMode = true;
                                            });
                                          },
                                          child: Container(
                                            width: double.maxFinite,
                                            height: isMobileView ? 70 : 90,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  spreadRadius: 0,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Submit a club registration request',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize:
                                                        isMobileView ? 12 : 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.mainColor,
                                                  ),
                                                ),
                                                // space
                                                const Expanded(
                                                  child: SizedBox(),
                                                ),
                                                // icon
                                                Icon(
                                                  Icons.arrow_forward,
                                                  size: isMobileView ? 20 : 24,
                                                  color: AppColors.mainColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // space
                                        SizedBox(
                                          height: isMobileView ? 15 : 25,
                                        ),
                                        // search
                                        Row(
                                          mainAxisAlignment:  MainAxisAlignment.end,
                                          children: [
                                            // filter
                                            Container(
                                        width : isMobileView ? Dimensions.screenWidth / (430 / 200) : 350,
                                                child :  DropdownButtonFormField<
                                                    String>(
                                                  value: currentClubLocation,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      currentClubLocation =
                                                      newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'All',
                                                    'UK',
                                                    'France',
                                                    'Germany',
                                                    'Netherlands',
                                                    'Australia',
                                                    'The Caribbean',
                                                    'New Zealand',
                                                    'Spain',
                                                    'Canary Island',
                                                    'The USA',
                                                  ].map<
                                                      DropdownMenuItem<
                                                          String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value, style: const TextStyle(
                                                            color:  AppColors.mainColor,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w600,
                                                          ),),
                                                        );
                                                      }).toList(),
                                                  decoration: const InputDecoration(
                                                      contentPadding:
                                                       EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                          10.0),
                                                      border:
                                                       OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide.none,
                                                      ),
                                                      enabledBorder:
                                                       OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide.none,
                                                      ),
                                                      focusedBorder:
                                                       OutlineInputBorder(
                                                        borderSide:
                                                         BorderSide.none,
                                                      ),
                                                      filled : true,
                                                      fillColor : AppColors.whiteColor,
                                                      hintText:
                                                      'Filter based on Location',
                                                  ),
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                            ),
                                            // space
                                            SizedBox(
                                                width : isMobileView ? 15 : 25,
                                            ),
                                            // search
                                            GestureDetector(
                                                onTap: (){
                                                  filterClubs();
                                                },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: isMobileView ? 8 : 12,
                                                    vertical : isMobileView ? 5 : 8
                                                ),
                                                decoration : BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                  color: AppColors.mainColor,
                                                ),
                                                  child : Center(
                                                      child: Text(
                                                          'Search',
                                                      style: TextStyle(
                                                        color: AppColors.whiteColor,
                                                        fontFamily : 'Poppins',
                                                          fontWeight : FontWeight.w500,
                                                        fontSize : isMobileView ? 14 : 16,
                                                      ),
                                                      ),
                                                  ),
                                            ),
                                            ),
                                            // space
                                            SizedBox(
                                              width : isMobileView ? 15 : 25,
                                            ),
                                          ],
                                        ),
                                        // space
                                        SizedBox(
                                          height: isMobileView ? 15 : 25,
                                        ),
                                        // clubs
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            Map<String, dynamic> club =
                                                selectedClubs[index];
                                            return GestureDetector(
                                              onTap: (){
                                                openClub(club['club_id']);
                                              },
                                              child: Container(
                                                width: double.maxFinite,
                                                height: isMobileView ? 70 : 90,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                  isMobileView ? 20 : 40,
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                  vertical: isMobileView ? 2 : 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      spreadRadius: 0,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 5),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // name and short description
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        // name
                                                        Text(
                                                          club['name'],
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: isMobileView
                                                                ? 12
                                                                : 16,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: AppColors
                                                                .mainColor,
                                                          ),
                                                        ),
                                                        // space
                                                        SizedBox(
                                                          height: isMobileView
                                                              ? 3
                                                              : 6,
                                                        ),
                                                        // short description
                                                        Text(
                                                          club[
                                                          'short_description'],
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: isMobileView
                                                                ? 10
                                                                : 12,
                                                            fontWeight:
                                                            FontWeight.w300,
                                                            color: AppColors
                                                                .mainColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // space
                                                    const Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    // number of reviewers
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        // reviewers
                                                        Text(
                                                          club['total_reviews']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: isMobileView
                                                                ? 12
                                                                : 16,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: AppColors
                                                                .mainColor,
                                                          ),
                                                        ),
                                                        // space
                                                        SizedBox(
                                                          height: isMobileView
                                                              ? 3
                                                              : 6,
                                                        ),
                                                        // reviewers
                                                        Text(
                                                          'reviewers',
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: isMobileView
                                                                ? 10
                                                                : 12,
                                                            fontWeight:
                                                            FontWeight.w300,
                                                            color: AppColors
                                                                .mainColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: selectedClubs.length,
                                        ),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            color: AppColors.whiteColor,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // side bar
                                if (!isMobileView)
                                  SizedBox(
                                    width: 300,
                                    child: ClubSideBar(
                                      changePage: _changePage,
                                    ),
                                  ),
                                // main body
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (_isLoading)
                                            const LinearProgressIndicator(
                                              color: AppColors.mainColor,
                                              backgroundColor:
                                              AppColors.mainColorLight,
                                              minHeight: 5,
                                            ),
                                          // space
                                          SizedBox(
                                            height:  isMobileView ? 20 : 40,
                                          ),
                                          // club name
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: isMobileView ? 20 : 40,
                                            ),
                                            child: Text(
                                              selectedClubDetails?['club']['name']??'',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: isMobileView ? 20 : 24,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.blackColor,
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
                                          // short description
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: isMobileView ? 20 : 40,
                                            ),
                                            child: Text(
                                              selectedClubDetails?['club']['short_description']??'',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: isMobileView ? 16 : 18,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                          // space
                                          SizedBox(
                                            height:  isMobileView ? 10 : 20,
                                          ),
                                          // email
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: isMobileView ? 20 : 40,
                                            ),
                                            child: Text(
                                              selectedClubDetails?['club']['club_email']??'',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: isMobileView ? 16 : 18,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                          // space
                                          SizedBox(
                                            height:  isMobileView ? 5 : 10,
                                          ),
                                          // link
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: isMobileView ? 20 : 40,
                                            ),
                                            child: Text(
                                              selectedClubDetails?['club']['club_link']??'',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: isMobileView ? 16 : 18,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                          // space
                                          SizedBox(
                                            height:  isMobileView ? 5 : 10,
                                          ),
                                          // link to club listing
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: isMobileView ? 20 : 40,
                                            ),
                                            child: Text(
                                              'Link to club listing',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: isMobileView ? 16 : 18,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                          ),
                                          // space
                                          SizedBox(
                                            height:  isMobileView ? 15 : 25,
                                          ),
                                          // long description
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: isMobileView ? 20 : 40,
                                            ),
                                            child: Text(
                                              selectedClubDetails?['club']['long_description']??'',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: isMobileView ? 14 : 16,
                                                fontWeight: FontWeight.w300,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                          // space
                                          SizedBox(
                                            height:  isMobileView ? 15 : 25,
                                          ),
                                          // add a review
                                          GestureDetector(
                                            onTap : () {
                                              openReview();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: isMobileView ? 20 : 40,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: isMobileView ? 20 : 40,
                                                vertical: isMobileView ? 10 : 20,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Colors.grey.shade300,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Add a review ...',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: isMobileView ? 14 : 16,
                                                        fontWeight: FontWeight.w300,
                                                        color: AppColors.blackColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: isMobileView ? 25 : 40,
                                                    width: isMobileView ? 25 : 40,
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image : AssetImage('assets/images/send.png'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // space
                                          SizedBox(
                                            height:  isMobileView ? 20 : 40,
                                          ),
                                          // reviews
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index){
                                              List<dynamic> reviews = selectedClubDetails?['club']['reviews'];
                                              Map<String, dynamic> review = reviews[index];
                                              String firstname = review['firstname']??'';
                                              String lastname = review['lastname']??'';
                                              String username = review['username'];
                                              String comment = review['comment'];
                                              String image = review['profile_image']??'public/media/profile/default.png';
                                              int rating = review['rating'];
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: isMobileView ? 20 : 40,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                            left: isMobileView ? 30 : 55,
                                                            top: isMobileView ? 20 : 35,
                                                          ),
                                                          padding: EdgeInsets.only(
                                                            top: isMobileView ? 10 : 20,
                                                            bottom: isMobileView ? 10 : 20,
                                                            right: isMobileView ? 10 : 20,
                                                          ),
                                                          height: isMobileView ? 220 : 300,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            color: AppColors.mainColor,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // space
                                                              SizedBox(
                                                                width: isMobileView ? 120 : 180,
                                                              ),
                                                              // body
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    // name
                                                                    Text(
                                                                      firstname.isNotEmpty || lastname.isNotEmpty ? '$firstname $lastname' : username,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Poppins',
                                                                        fontSize: isMobileView ? 18 : 20,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: AppColors.whiteColor,
                                                                      ),
                                                                    ),
                                                                    // space
                                                                    SizedBox(
                                                                      height: isMobileView ? 15 : 20,
                                                                    ),
                                                                    // comment
                                                                    Text(
                                                                      comment,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Poppins',
                                                                        fontSize: isMobileView ? 12 : 14,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: AppColors.whiteColor,
                                                                      ),
                                                                    ),
                                                                    // space
                                                                    SizedBox(
                                                                      height: isMobileView ? 15 : 20,
                                                                    ),
                                                                    // rating
                                                                    Row(
                                                                      children: [
                                                                        // stars
                                                                        for(int i = 1; i <= rating; i++)
                                                                          Icon(Icons.star, color: Colors.white, size: isMobileView ? 14 : 16,),
                                                                        for(int i = rating + 1; i <= 5; i++)
                                                                          Icon(Icons.star_outline, color: Colors.white, size: isMobileView ? 14 : 16,),
                                                                        // space
                                                                        SizedBox(
                                                                          width: isMobileView ? 7 : 10,
                                                                        ),
                                                                        // rating text
                                                                        Text(
                                                                          '$rating.0 rating',
                                                                          style: TextStyle(
                                                                            fontFamily: 'Poppins',
                                                                            fontSize: isMobileView ? 12 : 14,
                                                                            fontWeight: FontWeight.w200,
                                                                            color: AppColors.whiteColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // space
                                                        SizedBox(
                                                          height: isMobileView ? 15 : 25,
                                                        ),
                                                      ],
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      left : 0,
                                                      child: Container(
                                                        height: isMobileView ? 180 : 230,
                                                        width: isMobileView ? 140 : 200,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15),
                                                          border: Border.all(
                                                            color: AppColors.whiteColor,
                                                            width: isMobileView ? 5 : 8,
                                                          ),
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              '${AppConstants.BASE_URL}/$image',
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: selectedClubDetails?['club']['reviews'].length,
                                          ),
                                        ],
                                      ),
                                      if(isAddReviewMode)
                                       Container(
                                         color : AppColors.whiteColor,
                                         padding : EdgeInsets.only(
                                           top : isMobileView ? 50 : 75,
                                           bottom : isMobileView ? 50 : 75,
                                         ),
                                         child:  Column(
                                           children: [
                                             // back
                                             Container(
                                               padding: EdgeInsets.symmetric(
                                                 horizontal:
                                                 isMobileView ? 20 : 40,
                                                 vertical: isMobileView ? 20 : 40,
                                               ),
                                               child: GestureDetector(
                                                 onTap: () {
                                                   closeClubReview();
                                                 },
                                                 child: Row(
                                                   children: [
                                                     Icon(
                                                       Icons.arrow_back,
                                                       size:
                                                       isMobileView ? 20 : 24,
                                                       color: AppColors.mainColor,
                                                     ),
                                                     SizedBox(
                                                       width:
                                                       isMobileView ? 15 : 20,
                                                     ),
                                                     Text(
                                                       'Back',
                                                       style: TextStyle(
                                                         color:
                                                         AppColors.mainColor,
                                                         fontWeight:
                                                         FontWeight.w500,
                                                         fontSize: isMobileView
                                                             ? 15
                                                             : 18,
                                                         fontFamily: 'Poppins',
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ),
                                             // rating
                                             Container(
                                               width: double.maxFinite,
                                               padding: EdgeInsets.symmetric(
                                                 horizontal:
                                                 isMobileView ? 20 : 40,
                                                 vertical: isMobileView ? 10 : 20,
                                               ),
                                               child : Row(
                                                 crossAxisAlignment:
                                                 CrossAxisAlignment.start,
                                                 children: [
                                                   Expanded(
                                                     child:
                                                     DropdownButtonFormField<
                                                         int>(
                                                       value: selectedClubRating,
                                                       onChanged:
                                                           (int? newValue) {
                                                         setState(() {
                                                           selectedClubRating =
                                                           newValue!;
                                                         });
                                                       },
                                                       items: <int>[
                                                         1,2,3,4,5
                                                       ].map<
                                                           DropdownMenuItem<
                                                               int>>(
                                                               (int value) {
                                                             return DropdownMenuItem<
                                                                 int>(
                                                               value: value,
                                                               child: Text('${value.toString()} stars'),
                                                             );
                                                           }).toList(),
                                                       decoration: InputDecoration(
                                                           contentPadding:
                                                           const EdgeInsets
                                                               .symmetric(
                                                               horizontal:
                                                               10.0),
                                                           border:
                                                           OutlineInputBorder(
                                                             borderSide:
                                                             const BorderSide(
                                                               color: AppColors
                                                                   .mainColor,
                                                               width: 0.75,
                                                             ),
                                                             borderRadius:
                                                             BorderRadius
                                                                 .circular(15),
                                                           ),
                                                           enabledBorder:
                                                           OutlineInputBorder(
                                                             borderSide:
                                                             const BorderSide(
                                                               color: AppColors
                                                                   .mainColor,
                                                               width: 0.75,
                                                             ),
                                                             borderRadius:
                                                             BorderRadius
                                                                 .circular(15),
                                                           ),
                                                           focusedBorder:
                                                           OutlineInputBorder(
                                                             borderSide:
                                                             const BorderSide(
                                                               color: AppColors
                                                                   .mainColor,
                                                               width: 1.5,
                                                             ),
                                                             borderRadius:
                                                             BorderRadius
                                                                 .circular(15),
                                                           ),
                                                           hintText:
                                                           'Select rating'),
                                                       icon: const Icon(
                                                           Icons.arrow_drop_down),
                                                     ),
                                                   )
                                                 ],
                                               ),
                                             ),
                                             // comment
                                             Container(
                                               width: double.maxFinite,
                                               padding: EdgeInsets.symmetric(
                                                 horizontal:
                                                 isMobileView ? 20 : 40,
                                                 vertical: isMobileView ? 10 : 20,
                                               ),
                                               child: Row(
                                                 crossAxisAlignment:
                                                 CrossAxisAlignment.start,
                                                 children: [
                                                   // comment
                                                   Expanded(
                                                     child: TextField(
                                                       controller:
                                                       clubReviewCommentController,
                                                       keyboardType:
                                                       TextInputType.text,
                                                       cursorColor:
                                                       AppColors.mainColor,
                                                       maxLines: 2,
                                                       decoration: InputDecoration(
                                                         border:
                                                         OutlineInputBorder(
                                                           borderSide:
                                                           const BorderSide(
                                                             color: AppColors
                                                                 .mainColor,
                                                             width: 0.75,
                                                           ),
                                                           borderRadius:
                                                           BorderRadius
                                                               .circular(15),
                                                         ),
                                                         focusedBorder:
                                                         OutlineInputBorder(
                                                           borderSide:
                                                           const BorderSide(
                                                             color: AppColors
                                                                 .mainColor,
                                                             width: 1.5,
                                                           ),
                                                           borderRadius:
                                                           BorderRadius
                                                               .circular(15),
                                                         ),
                                                         hintText:
                                                         'Your comment',
                                                       ),
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                             // submit
                                             Center(
                                               child: GestureDetector(
                                                 onTap: () {
                                                   sendReview(selectedClubDetails?['club']['club_id']);
                                                 },
                                                 child: Container(
                                                   width: isMobileView ? 200 : 250,
                                                   padding: EdgeInsets.symmetric(
                                                     horizontal:
                                                     isMobileView ? 20 : 40,
                                                     vertical:
                                                     isMobileView ? 5 : 10,
                                                   ),
                                                   decoration: BoxDecoration(
                                                     color: _isLoading
                                                         ? AppColors.greyColor1
                                                         : AppColors.mainColor,
                                                     borderRadius:
                                                     BorderRadius.circular(15),
                                                   ),
                                                   child: Center(
                                                     child: Text(
                                                       _isLoading
                                                           ? 'Please wait ... '
                                                           : 'Submit',
                                                       style: TextStyle(
                                                         color:
                                                         AppColors.whiteColor,
                                                         fontSize: isMobileView
                                                             ? 14
                                                             : 16,
                                                         fontFamily: 'Poppins',
                                                         fontWeight:
                                                         FontWeight.w400,
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                      if(_isLoading)
                                        const Center(
                                          child:  BarLoadingAnimation(),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    if (_isLoading)
                                      const LinearProgressIndicator(
                                        color: AppColors.mainColor,
                                        backgroundColor:
                                            AppColors.mainColorLight,
                                        minHeight: 5,
                                      ),
                                    if (isMobileView)
                                      Column(
                                        children: [
                                          // back
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 20 : 40,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isCreateClubMode = false;
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.arrow_back,
                                                    size:
                                                        isMobileView ? 20 : 24,
                                                    color: AppColors.mainColor,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        isMobileView ? 15 : 20,
                                                  ),
                                                  Text(
                                                    'Back',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.mainColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: isMobileView
                                                          ? 15
                                                          : 18,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // name
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              children: [
                                                // name
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubNameController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText: 'Club name',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // location
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              children: [
                                                // location
                                                Expanded(
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: selectedClubLocation,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        selectedClubLocation =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: <String>[
                                                      'UK',
                                                      'France',
                                                      'Germany',
                                                      'Netherlands',
                                                      'Australia',
                                                      'The Caribbean',
                                                      'New Zealand',
                                                      'Spain',
                                                      'Canary Island',
                                                      'The USA',
                                                      'Others'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: 0.75,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: 0.75,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: 1.5,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        hintText:
                                                            'Select club location'),
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // mail
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              children: [
                                                // mail
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubEmailController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText: 'Club mail',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // link
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              children: [
                                                // link
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubLinkController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText:
                                                          'Link to club listing',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // short
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // short description
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubShortDescriptionController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    maxLines: 4,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText:
                                                          'Short description',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // long description
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // long description
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubLongDescriptionController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    maxLines: 10,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText:
                                                          'Full club description',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // submit
                                          Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                submitClubRequest();
                                              },
                                              child: Container(
                                                width: isMobileView ? 200 : 250,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      isMobileView ? 20 : 40,
                                                  vertical:
                                                      isMobileView ? 5 : 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _isLoading
                                                      ? AppColors.greyColor1
                                                      : AppColors.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    _isLoading
                                                        ? 'Please wait ... '
                                                        : 'Submit',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.whiteColor,
                                                      fontSize: isMobileView
                                                          ? 14
                                                          : 16,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        children: [
                                          // back
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 20 : 40,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isCreateClubMode = false;
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.arrow_back,
                                                    size:
                                                        isMobileView ? 20 : 24,
                                                    color: AppColors.mainColor,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        isMobileView ? 15 : 20,
                                                  ),
                                                  Text(
                                                    'Back',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.mainColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: isMobileView
                                                          ? 15
                                                          : 18,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // name and location
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              children: [
                                                // name
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubNameController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText: 'Club name',
                                                    ),
                                                  ),
                                                ),
                                                // space
                                                SizedBox(
                                                  width: isMobileView ? 10 : 20,
                                                ),
                                                // location
                                                Expanded(
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: selectedClubLocation,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        selectedClubLocation =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: <String>[
                                                      'UK',
                                                      'France',
                                                      'Germany',
                                                      'Netherlands',
                                                      'Australia',
                                                      'The Caribbean',
                                                      'New Zealand',
                                                      'Spain',
                                                      'Canary Island',
                                                      'The USA',
                                                      'Others'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: 0.75,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: 0.75,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: 1.5,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        hintText:
                                                            'Select club location'),
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // mail and link
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              children: [
                                                // mail
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubEmailController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText: 'Club mail',
                                                    ),
                                                  ),
                                                ),
                                                // space
                                                SizedBox(
                                                  width: isMobileView ? 10 : 20,
                                                ),
                                                // link
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubLinkController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText:
                                                          'Link to club listing',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // short
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // short description
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubShortDescriptionController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    maxLines: 2,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText:
                                                          'Short description',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // long description
                                          Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  isMobileView ? 20 : 40,
                                              vertical: isMobileView ? 10 : 20,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // long description
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        clubLongDescriptionController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    maxLines: 10,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 0.75,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .mainColor,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      hintText:
                                                          'Full club description',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // submit
                                          Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                submitClubRequest();
                                              },
                                              child: Container(
                                                width: isMobileView ? 200 : 250,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      isMobileView ? 20 : 40,
                                                  vertical:
                                                      isMobileView ? 5 : 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _isLoading
                                                      ? AppColors.greyColor1
                                                      : AppColors.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    _isLoading
                                                        ? 'Please wait ... '
                                                        : 'Submit',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.whiteColor,
                                                      fontSize: isMobileView
                                                          ? 14
                                                          : 16,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
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
