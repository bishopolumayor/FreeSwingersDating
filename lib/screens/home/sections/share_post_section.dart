import 'dart:html' as html;
import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/posts_controller.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/bar_loading_animation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SharePostSection extends StatefulWidget {
  const SharePostSection({super.key});

  @override
  State<SharePostSection> createState() => _SharePostSectionState();
}

enum PostMode { post, story }

class MediaFile {
  final XFile file;
  final String mimeType;
  String? thumbnail;

  MediaFile(this.file, this.mimeType, {this.thumbnail});

  bool get isVideo => mimeType.startsWith('video/');

  bool get isImage => mimeType.startsWith('image/');
}

class _SharePostSectionState extends State<SharePostSection> {
  PostsController postsController = Get.find<PostsController>();

  PostMode _currentMode = PostMode.story;

  List<MediaFile> _selectedMedia = [];

  VideoPlayerController? _videoPlayerController;

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  var captionsController = TextEditingController();

  bool _isLoading = false;

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    List<XFile> filesToAdd = pickedFiles;
    bool isStory = _currentMode == PostMode.story;
    if (!isStory && pickedFiles.length > 4) {
      filesToAdd = pickedFiles.sublist(0, 4);
      Get.snackbar(
        "Sorry",
        "You can upload more than 4 media files.",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
    }

    List<MediaFile> validMediaFiles = [];

    for (var file in filesToAdd) {
      final mimeType = await _getMimeType(file);
      final fileSize = await file.length();
      int maxFileSize = isStory ? 26214400 : 52428800;

      if (fileSize > maxFileSize) {
        Get.snackbar(
          "Too large",
          isStory
              ? "Upload a content that is not above 25MB."
              : "Upload a content that is not above 50MB.",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
        );
      } else if (mimeType!.startsWith('video/')) {
        final blobUrl = html.Url.createObjectUrlFromBlob(
            html.Blob([await file.readAsBytes()]));

        VideoPlayerController controller =
            VideoPlayerController.network(blobUrl);
        await controller.initialize();
        Duration? videoDuration = controller.value.duration;

        if (isStory && videoDuration != null && videoDuration.inSeconds > 30) {
          Get.snackbar(
            "Sorry",
            "You cannot upload more than 30 seconds of video on Story.",
            backgroundColor: AppColors.mainColor,
            colorText: Colors.white,
          );
        } else {
          validMediaFiles.add(MediaFile(file, mimeType));
        }

        await controller.dispose();
        html.Url.revokeObjectUrl(blobUrl);
      } else {
        validMediaFiles.add(MediaFile(file, mimeType));
      }
    }

    setState(() {
      if (isStory) {
        if (validMediaFiles.isNotEmpty) {
          _selectedMedia.clear();
          _selectedMedia.add(validMediaFiles.first);
        }
        if (validMediaFiles.length > 1) {
          Get.snackbar(
            "Sorry",
            "Only one media is allowed in Story mode.",
            backgroundColor: AppColors.mainColor,
            colorText: Colors.white,
          );
        }
      } else {
        int spaceAvailable = 4 - _selectedMedia.length;
        List<MediaFile> filesToAdd = validMediaFiles;
        if (validMediaFiles.length > spaceAvailable) {
          filesToAdd = validMediaFiles.sublist(0, spaceAvailable);
          Get.snackbar(
            "Sorry",
            "You can only upload 4 media files.",
            backgroundColor: AppColors.mainColor,
            colorText: Colors.white,
          );
        }
        _selectedMedia.addAll(filesToAdd);

        if (_selectedMedia.length > 4) {
          _selectedMedia = _selectedMedia.sublist(0, 4);
          Get.snackbar(
            "Error",
            "You can only select up to 4 media in Post mode.",
            backgroundColor: AppColors.mainColor,
            colorText: Colors.white,
          );
        }
      }
    });
  }

  Future<String?> _getMimeType(XFile file) async {
    return file.mimeType;
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

  bool validatePost() {
    if (_currentMode == PostMode.story) {
      if (_selectedMedia.isEmpty && captionsController.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please add a caption or media for your story.",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
        );
        return false;
      }
      if (_selectedMedia.length > 1) {
        Get.snackbar(
          "Error",
          "Only one media file is allowed in Story mode.",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
        );
        return false;
      }
    } else {
      if (_selectedMedia.isEmpty && captionsController.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Please add a caption or media for your post.",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
        );
        return false;
      }
      if (_selectedMedia.length > 4) {
        Get.snackbar(
          "Error",
          "You can only upload up to 4 media files in Post mode.",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
        );
        return false;
      }
    }
    return true;
  }

  void upload() async {
    if (validatePost()) {
      if (_currentMode == PostMode.post) {
        setState(() {
          _isLoading = true;
        });
        List<XFile> files = getFilesFromMediaFiles(_selectedMedia);
        bool success = await postsController.uploadPost(
          caption: captionsController.text,
          mediaFiles: files.isNotEmpty ? files : null,
        );
        if (success) {
          captionsController.clear();
          _selectedMedia = [];
        }
        setState(() {
          _isLoading = false;
        });
      } else if (_currentMode == PostMode.story) {
        setState(() {
          _isLoading = true;
        });
        bool success = await postsController.uploadStory(
          caption: captionsController.text,
          media: _selectedMedia.isEmpty ? null : _selectedMedia.first.file,
        );
        if (success) {
          captionsController.clear();
          _selectedMedia = [];
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<XFile> getFilesFromMediaFiles(List<MediaFile> mediaFiles) {
    return mediaFiles.map((mediaFile) => mediaFile.file).toList();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobileView ? 15 : 20,
        vertical: isMobileView ? 10 : 15,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // status / post feed,  photos , videos
              Row(
                children: [
                  // status / post
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentMode = _currentMode == PostMode.story
                            ? PostMode.post
                            : PostMode.story;
                        _selectedMedia = [];
                      });
                    },
                    child: Text(
                      _currentMode == PostMode.post ? "Post" : "Story",
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: isMobileView ? 12 : 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // space
                  SizedBox(
                    width: isMobileView ? 20 : 30,
                  ),
                  // photos
                  GestureDetector(
                    onTap: _pickMedia,
                    child: Row(
                      children: [
                        // photos icon
                        Container(
                          height: isMobileView ? 18 : 25,
                          width: isMobileView ? 18 : 25,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/p1.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                        SizedBox(
                          width: isMobileView ? 5 : 8,
                        ),
                        // photos
                        Text(
                          'Photos',
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: isMobileView ? 12 : 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // space
                  SizedBox(
                    width: isMobileView ? 15 : 25,
                  ),
                  // videos
                  GestureDetector(
                    onTap: _pickMedia,
                    child: Row(
                      children: [
                        // video icon
                        Container(
                          height: isMobileView ? 18 : 25,
                          width: isMobileView ? 20 : 28,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/v1.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                        SizedBox(
                          width: isMobileView ? 5 : 8,
                        ),
                        // videos
                        Text(
                          'Videos',
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: isMobileView ? 12 : 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // space
              SizedBox(
                height: isMobileView ? 7 : 12,
              ),
              // share your thoughts
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickMedia,
                    child: Container(
                      height: isMobileView ? 35 : 50,
                      width: isMobileView ? 35 : 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade400,
                      ),
                      child: Center(
                        child: Container(
                          height: isMobileView ? 18 : 25,
                          width: isMobileView ? 18 : 25,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/img_icon.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // space
                  SizedBox(
                    width: isMobileView ? 15 : 25,
                  ),
                  // share your thoughts
                  Expanded(
                    child: TextField(
                      controller: captionsController,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Share your thoughts',
                        hintStyle: TextStyle(
                          fontSize: isMobileView ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // space
              SizedBox(
                height: isMobileView ? 7 : 12,
              ),
              // display the selected images / videos here
              Wrap(
                children: _selectedMedia.map((mediaFile) {
                  Widget mediaWidget;
                  if (mediaFile.isVideo) {
                    mediaWidget = Stack(
                      alignment: Alignment.center,
                      children: [
                        mediaFile.thumbnail != null
                            ? Image.network(
                                mediaFile.thumbnail!,
                                width: isMobileView ? 120 : 120,
                                height: isMobileView ? 120 : 120,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: isMobileView ? 120 : 120,
                                height: isMobileView ? 120 : 120,
                                color: Colors.black,
                                child: const Icon(
                                  Icons.video_library,
                                  color: Colors.white,
                                ),
                              ),
                        const Icon(
                          Icons.play_circle_outline,
                          size: 50,
                          color: Colors.white,
                        ),
                      ],
                    );
                  } else {
                    mediaWidget = kIsWeb
                        ? Image.network(
                            mediaFile.file.path,
                            width: isMobileView ? 120 : 120,
                            height: isMobileView ? 120 : 120,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            io.File(mediaFile.file.path),
                            width: isMobileView ? 120 : 120,
                            height: isMobileView ? 120 : 120,
                            fit: BoxFit.cover,
                          );
                  }

                  return GestureDetector(
                    onTap: () => mediaFile.isVideo
                        ? _playVideo(mediaFile.file.path)
                        : _showImageDialog(mediaFile.file.path),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          mediaWidget,
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              setState(() {
                                _selectedMedia.remove(mediaFile);
                                if (mediaFile.isVideo) {
                                  _videoPlayerController?.dispose();
                                  _videoPlayerController = null;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              // ... and share
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      upload();
                    },
                    child: Container(
                      height: isMobileView ? 25 : 30,
                      width: isMobileView ? 65 : 90,
                      decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                      ),
                      child: Center(
                        child: Text(
                          'Share',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: 'Poppins',
                            fontSize: isMobileView ? 14 : 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: BarLoadingAnimation(),
            ),
        ],
      ),
    );
  }
}
