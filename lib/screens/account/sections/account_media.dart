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
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/home_side_bar.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AccountMedia extends StatefulWidget {
  const AccountMedia({super.key});

  @override
  State<AccountMedia> createState() => _AccountMediaState();
}

class _AccountMediaState extends State<AccountMedia> {
  UserController userController = Get.find<UserController>();

  VideoPlayerController? _videoPlayerController;

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  List<String> media  = [];

  @override
  void initState() {
    super.initState();
    initializeMedia();
  }

  void initializeMedia() async {

    UserModel user;
    if(userController.selectedUser.value != null) {
      user = userController.selectedUser.value!;
    }else {
      user = userController.user.value!;
    }
    String userId = user.userId;

    List<String> mediaData = await userController.getUserMedia(userId: userId);

    List<String> images = mediaData.where((item) => isImage(item)).toList();

    setState(() {
      media = images;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobileView ? 3 : 6,
          crossAxisSpacing: isMobileView ? 10 : 20,
          mainAxisSpacing:  isMobileView ? 10 : 20,
        ),
        itemBuilder: (context, index) {
          return isImage(media[index])
              ? GestureDetector(
            onTap: () {
              _showImageDialog('${AppConstants.BASE_URL}/${media[index]}');
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      '${AppConstants.BASE_URL}/${media[index]}'),
                ),
              ),
            ),
          )
              : isVideo(media[index])
              ? GestureDetector(
            onTap: () {
              _playVideo('${AppConstants.BASE_URL}/${media[index]}');
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
          );
        },
        itemCount: media.length,
      ),
    );
  }
}
