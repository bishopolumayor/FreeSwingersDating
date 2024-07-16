import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:free_swingers_dating/models/story_model.dart';
import 'package:free_swingers_dating/models/user_model.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:video_player/video_player.dart';

class StoryContainer extends StatefulWidget {
  final StoryModel storyModel;

  const StoryContainer({
    super.key,
    required this.storyModel,
  });

  @override
  State<StoryContainer> createState() => _StoryContainerState();
}

class _StoryContainerState extends State<StoryContainer> {
  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  VideoPlayerController? _videoPlayerController;

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
    print(videoPath);
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
    print(imagePath);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Image.network(imagePath, fit: BoxFit.cover),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  List<Color> myColors = [
    Colors.red,
    Colors.grey[900]!,
    Colors.grey[700]!,
    Colors.blue,
    Colors.purple,
    Colors.green[900]!,
    Colors.blue[900]!,
    Colors.red[900]!,
  ];

  Color getRandomColor() {
    Random random = Random();
    return myColors[random.nextInt(myColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    StoryModel story = widget.storyModel;
    UserModel storyUser = story.user;
    return Stack(
      children: [
        story.media != null
            ? GestureDetector(
                onTap: () {
                  if (isVideo(story.media!)) {
                    _playVideo('${AppConstants.BASE_URL}/${story.media!}');
                  } else if (isImage(story.media!)) {
                    _showImageDialog(
                        '${AppConstants.BASE_URL}/${story.media!}');
                  }
                },
                child: Container(
                    width: isMobileView ? 85 : 140,
                    height: isMobileView ? 150 : 250,
                    margin: EdgeInsets.symmetric(
                      horizontal: isMobileView ? 5 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        isVideo(story.media!)
                            ? Container(
                                width: isMobileView ? 85 : 140,
                                height: isMobileView ? 150 : 250,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(
                                  Icons.play_circle_outline_outlined,
                                  color: Colors.white,
                                ),
                              )
                            : isImage(story.media!)
                                ? Container(
                                    width: isMobileView ? 85 : 140,
                                    height: isMobileView ? 150 : 250,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            '${AppConstants.BASE_URL}/${story.media!}'),
                                      ),
                                    ),
                                  )
                                : Container(),
                        story.caption.isNotEmpty
                            ? Positioned(
                                bottom: 5,
                                right: 2,
                                left: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                  ),
                                  child: Text(
                                    story.caption,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: isMobileView ? 7 : 10,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )),
              )
            : story.caption.isNotEmpty
                ? Container(
                    width: isMobileView ? 85 : 140,
                    height: isMobileView ? 150 : 250,
                    margin: EdgeInsets.symmetric(
                      horizontal: isMobileView ? 5 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: getRandomColor(),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: AutoSizeText(
                          story.caption,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          minFontSize: 8,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: isMobileView ? 85 : 140,
                    height: isMobileView ? 150 : 250,
                    margin: EdgeInsets.symmetric(
                      horizontal: isMobileView ? 5 : 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    )),
        Positioned(
          top: 10,
          left: 15,
          child: Container(
            height: isMobileView ? 25 : 40,
            width: isMobileView ? 25 : 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  storyUser.profileImage != null
                      ? '${AppConstants.BASE_URL}/${storyUser.profileImage}'
                      : '${AppConstants.BASE_URL}/public/media/profile/default.png',
                ),
              ),
              border: Border.all(
                width: isMobileView ? 3 : 6,
                color: AppColors.mainColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
