import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/models/post_model.dart';
import 'package:free_swingers_dating/models/user_model.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PostContainer extends StatefulWidget {
  final PostModel postModel;

  const PostContainer({
    super.key,
    required this.postModel,
  });

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  UserController userController = Get.find<UserController>();
  PostsController postsController = Get.find<PostsController>();

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  VideoPlayerController? _videoPlayerController;

  bool postLiked = false;
  int likesNumber = 0;

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

  String timeAgo(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays >= 365) {
      int years = difference.inDays ~/ 365;
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 30) {
      int months = difference.inDays ~/ 30;
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 7) {
      int weeks = difference.inDays ~/ 7;
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      postLiked = checkIfUserLikedPost();
      likesNumber = widget.postModel.likes.length;
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  bool checkIfUserLikedPost() {
    PostModel post = widget.postModel;
    UserModel currentUser = userController.user.value!;
    return post.likes.any((like) => like.likerId == currentUser.userId);
  }

  void toggleLike() async {
    postsController.toggleLike(widget.postModel.postId);
    if (postLiked) {
      setState(() {
        postLiked = false;
        likesNumber = likesNumber - 1;
      });
    } else if (!postLiked) {
      setState(() {
        postLiked = true;
        likesNumber = likesNumber + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PostModel post = widget.postModel;
    int mediaNumber = post.media.isEmpty ? 0 : post.media.length;
    UserModel postUser = post.user;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isMobileView ? 20 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image ... / name etc
          GestureDetector(
            onTap: (){
              userController.saveSelectedUser(postUser);
              Get.toNamed(AppRoutes.getMyAccountScreen());
            },
            child: Row(
              children: [
                // profile image
                Container(
                  height: isMobileView ? 35 : 50,
                  width: isMobileView ? 35 : 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade400,
                    image: DecorationImage(
                      image: NetworkImage(
                        postUser.profileImage != null
                            ? '${AppConstants.BASE_URL}/${postUser.profileImage}'
                            : '${AppConstants.BASE_URL}/public/media/profile/default.png',
                      ),
                    ),
                  ),
                ),
                // space
                SizedBox(
                  width: isMobileView ? 10 : 18,
                ),
                // name and time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name ... verified ... badge
                    Row(
                      children: [
                        // name
                        Text(
                          postUser.firstName != null && postUser.lastName != null
                              ? '${postUser.firstName} ${postUser.lastName}'
                              : postUser.username,
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
                    // time
                    Text(
                      timeAgo(post.createdAt),
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: isMobileView ? 12 : 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // space
          SizedBox(
            height: isMobileView ? 10 : 15,
          ),
          // caption
          Text(
            post.caption ?? '',
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: isMobileView ? 12 : 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          // space
          SizedBox(
            height: isMobileView ? 10 : 15,
          ),
          // post media
          buildMediaLayout(post, mediaNumber),
          // space
          SizedBox(
            height: isMobileView ? 10 : 15,
          ),
          // like comments share
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // comments
              GestureDetector(
                child: Row(
                  children: [
                    // icon
                    Container(
                      height: isMobileView ? 15 : 18,
                      width: isMobileView ? 15 : 18,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/comment.png',
                          ),
                        ),
                      ),
                    ),
                    // space
                    SizedBox(
                      width: isMobileView ? 7 : 12,
                    ),
                    // number
                    Text(
                      post.comments.length.toString(),
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: isMobileView ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              // space
              SizedBox(
                width: isMobileView ? 30 : 50,
              ),
              // likes
              GestureDetector(
                onTap: toggleLike,
                child: Row(
                  children: [
                    // icon
                    Container(
                      height: isMobileView ? 15 : 18,
                      width: isMobileView ? 15 : 18,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            postLiked
                                ? 'assets/images/liked.png'
                                : 'assets/images/like.png',
                          ),
                        ),
                      ),
                    ),
                    // space
                    SizedBox(
                      width: isMobileView ? 7 : 12,
                    ),
                    // number
                    Text(
                      likesNumber.toString(),
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: isMobileView ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              // space
              SizedBox(
                width: isMobileView ? 30 : 50,
              ),
              // shares
              GestureDetector(
                child: Row(
                  children: [
                    // icon
                    Container(
                      height: isMobileView ? 15 : 18,
                      width: isMobileView ? 15 : 18,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/share.png',
                          ),
                        ),
                      ),
                    ),
                    // space
                    SizedBox(
                      width: isMobileView ? 7 : 12,
                    ),
                    // number
                    Text(
                      post.shares.length.toString(),
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: isMobileView ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // space
          SizedBox(
            height: isMobileView ? 10 : 15,
          ),
        ],
      ),
    );
  }

  Widget buildMediaLayout(PostModel post, int mediaNumber) {
    List<String> media = post.media;
    switch (mediaNumber) {
      case 0:
        return const SizedBox();
      case 1:
        return isImage(media[0])
            ? GestureDetector(
                onTap: () {
                  _showImageDialog('${AppConstants.BASE_URL}/${post.media[0]}');
                },
                child: Container(
                  width: isMobileView
                      ? double.maxFinite
                      : Dimensions.widthRatio(500),
                  height: isMobileView ? 280 : Dimensions.widthRatio(500),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          '${AppConstants.BASE_URL}/${post.media[0]}'),
                    ),
                  ),
                ),
              )
            : isVideo(media[0])
                ? GestureDetector(
                    onTap: () {
                      _playVideo('${AppConstants.BASE_URL}/${post.media[0]}');
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
      case 2:
        return Row(
          children: [
            // 1st
            Expanded(
              child: isImage(media[0])
                  ? GestureDetector(
                      onTap: () {
                        _showImageDialog(
                            '${AppConstants.BASE_URL}/${post.media[0]}');
                      },
                      child: Container(
                        height: isMobileView ? 200 : Dimensions.widthRatio(500),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                '${AppConstants.BASE_URL}/${post.media[0]}'),
                          ),
                        ),
                      ),
                    )
                  : isVideo(media[0])
                      ? GestureDetector(
                          onTap: () {
                            _playVideo(
                                '${AppConstants.BASE_URL}/${post.media[0]}');
                          },
                          child: Container(
                            height:
                                isMobileView ? 200 : Dimensions.widthRatio(500),
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
                          height:
                              isMobileView ? 200 : Dimensions.widthRatio(500),
                          color: Colors.red,
                        ),
            ),
            // space
            SizedBox(
              width: isMobileView ? 6 : 12,
            ),
            // 2nd
            Expanded(
              child: isImage(media[1])
                  ? GestureDetector(
                      onTap: () {
                        _showImageDialog(
                            '${AppConstants.BASE_URL}/${post.media[1]}');
                      },
                      child: Container(
                        height: isMobileView ? 200 : Dimensions.widthRatio(500),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                '${AppConstants.BASE_URL}/${post.media[1]}'),
                          ),
                        ),
                      ),
                    )
                  : isVideo(media[1])
                      ? GestureDetector(
                          onTap: () {
                            _playVideo(
                                '${AppConstants.BASE_URL}/${post.media[1]}');
                          },
                          child: Container(
                            height:
                                isMobileView ? 200 : Dimensions.widthRatio(500),
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
                          height:
                              isMobileView ? 200 : Dimensions.widthRatio(500),
                          color: Colors.white,
                        ),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            // 1st
            isImage(media[0])
                ? GestureDetector(
                    onTap: () {
                      _showImageDialog(
                          '${AppConstants.BASE_URL}/${post.media[0]}');
                    },
                    child: Container(
                      width: isMobileView
                          ? double.maxFinite
                          : Dimensions.widthRatio(500),
                      height: isMobileView ? 280 : Dimensions.widthRatio(500),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              '${AppConstants.BASE_URL}/${post.media[0]}'),
                        ),
                      ),
                    ),
                  )
                : isVideo(media[0])
                    ? GestureDetector(
                        onTap: () {
                          _playVideo(
                              '${AppConstants.BASE_URL}/${post.media[0]}');
                        },
                        child: Container(
                          width: isMobileView
                              ? double.maxFinite
                              : Dimensions.widthRatio(500),
                          height:
                              isMobileView ? 280 : Dimensions.widthRatio(500),
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
            // space
            SizedBox(
              height: isMobileView ? 7 : 12,
            ),
            // 2nd and 3rd
            Row(
              children: [
                // 2nd
                Expanded(
                  child: isImage(media[1])
                      ? GestureDetector(
                          onTap: () {
                            _showImageDialog(
                                '${AppConstants.BASE_URL}/${post.media[1]}');
                          },
                          child: Container(
                            height:
                                isMobileView ? 200 : Dimensions.widthRatio(500),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    '${AppConstants.BASE_URL}/${post.media[1]}'),
                              ),
                            ),
                          ),
                        )
                      : isVideo(media[1])
                          ? GestureDetector(
                              onTap: () {
                                _playVideo(
                                    '${AppConstants.BASE_URL}/${post.media[1]}');
                              },
                              child: Container(
                                height: isMobileView
                                    ? 200
                                    : Dimensions.widthRatio(500),
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
                              height: isMobileView
                                  ? 200
                                  : Dimensions.widthRatio(500),
                              color: Colors.white,
                            ),
                ),
                // space
                SizedBox(
                  width: isMobileView ? 6 : 12,
                ),
                // 3rd
                Expanded(
                  child: isImage(media[2])
                      ? GestureDetector(
                          onTap: () {
                            _showImageDialog(
                                '${AppConstants.BASE_URL}/${post.media[2]}');
                          },
                          child: Container(
                            height:
                                isMobileView ? 200 : Dimensions.widthRatio(500),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    '${AppConstants.BASE_URL}/${post.media[2]}'),
                              ),
                            ),
                          ),
                        )
                      : isVideo(media[2])
                          ? GestureDetector(
                              onTap: () {
                                _playVideo(
                                    '${AppConstants.BASE_URL}/${post.media[2]}');
                              },
                              child: Container(
                                height: isMobileView
                                    ? 200
                                    : Dimensions.widthRatio(500),
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
                              height: isMobileView
                                  ? 200
                                  : Dimensions.widthRatio(500),
                              color: Colors.white,
                            ),
                ),
              ],
            ),
          ],
        );
      case 4:
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: isMobileView ? 7 : 10,
          crossAxisSpacing: isMobileView ? 7 : 10,
          children: [
            // 1st
            isImage(media[0])
                ? GestureDetector(
                    onTap: () {
                      _showImageDialog(
                          '${AppConstants.BASE_URL}/${post.media[0]}');
                    },
                    child: Container(
                      height: isMobileView ? 200 : Dimensions.widthRatio(250),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              '${AppConstants.BASE_URL}/${post.media[0]}'),
                        ),
                      ),
                    ),
                  )
                : isVideo(media[0])
                    ? GestureDetector(
                        onTap: () {
                          _playVideo(
                              '${AppConstants.BASE_URL}/${post.media[0]}');
                        },
                        child: Container(
                          height:
                              isMobileView ? 200 : Dimensions.widthRatio(250),
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
                        height: isMobileView ? 200 : Dimensions.widthRatio(250),
                        color: Colors.white,
                      ),
            // 2nd
            isImage(media[1])
                ? GestureDetector(
                    onTap: () {
                      _showImageDialog(
                          '${AppConstants.BASE_URL}/${post.media[1]}');
                    },
                    child: Container(
                      height: isMobileView ? 200 : Dimensions.widthRatio(250),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              '${AppConstants.BASE_URL}/${post.media[1]}'),
                        ),
                      ),
                    ),
                  )
                : isVideo(media[1])
                    ? GestureDetector(
                        onTap: () {
                          _playVideo(
                              '${AppConstants.BASE_URL}/${post.media[1]}');
                        },
                        child: Container(
                          height:
                              isMobileView ? 200 : Dimensions.widthRatio(250),
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
                        height: isMobileView ? 200 : Dimensions.widthRatio(250),
                        color: Colors.white,
                      ),
            // 3rd
            isImage(media[2])
                ? GestureDetector(
                    onTap: () {
                      _showImageDialog(
                          '${AppConstants.BASE_URL}/${post.media[2]}');
                    },
                    child: Container(
                      height: isMobileView ? 200 : Dimensions.widthRatio(250),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              '${AppConstants.BASE_URL}/${post.media[2]}'),
                        ),
                      ),
                    ),
                  )
                : isVideo(media[2])
                    ? GestureDetector(
                        onTap: () {
                          _playVideo(
                              '${AppConstants.BASE_URL}/${post.media[2]}');
                        },
                        child: Container(
                          height:
                              isMobileView ? 200 : Dimensions.widthRatio(250),
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
                        height: isMobileView ? 200 : Dimensions.widthRatio(250),
                        color: Colors.white,
                      ),
            // 4th
            isImage(media[3])
                ? GestureDetector(
                    onTap: () {
                      _showImageDialog(
                          '${AppConstants.BASE_URL}/${post.media[3]}');
                    },
                    child: Container(
                      height: isMobileView ? 200 : Dimensions.widthRatio(250),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              '${AppConstants.BASE_URL}/${post.media[3]}'),
                        ),
                      ),
                    ),
                  )
                : isVideo(media[3])
                    ? GestureDetector(
                        onTap: () {
                          _playVideo(
                              '${AppConstants.BASE_URL}/${post.media[3]}');
                        },
                        child: Container(
                          height:
                              isMobileView ? 200 : Dimensions.widthRatio(250),
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
                        height: isMobileView ? 200 : Dimensions.widthRatio(250),
                        color: Colors.white,
                      ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
