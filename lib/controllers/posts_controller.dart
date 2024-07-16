import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/data/repo/posts_repo.dart';
import 'package:free_swingers_dating/models/hot_pictures_model.dart';
import 'package:free_swingers_dating/models/post_model.dart';
import 'package:free_swingers_dating/models/story_model.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class PostsController extends GetxController {
  final PostsRepo postsRepo;

  PostsController({
    required this.postsRepo,
  });

  var stories = <StoryModel>[].obs;
  var posts = <PostModel>[].obs;
  var hotPictures = <HotPicturesModel>[].obs;

  UserController userController = Get.find<UserController>();
  SocketController socketController = Get.find<SocketController>();

  Future<void> fetchStories() async {
    try {
      Response response = await postsRepo.getStories();

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> storiesData = result['data']['stories'];

          stories.assignAll(
              storiesData.map((e) => StoryModel.fromJson(e)).toList());
          update();
        } else {
          Get.snackbar(
            'Failed',
            result['message'],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Failed',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('fetch stories exception $e');
      }
    }
  }

  Future<void> fetchPosts() async {
    try {
      Response response = await postsRepo.getPosts();

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> postsData = result['data']['posts'];

          posts.assignAll(postsData.map((e) => PostModel.fromJson(e)).toList());
          update();
        } else {
          Get.snackbar(
            'Failed',
            result['message'],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Failed',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('fetch posts exception $e');
      }
    }
  }

  Future<void> fetchHotPictures() async {
    try {
      Response response = await postsRepo.getHotPictures();

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> hotPicturesData = result['data']['hotPictures'];

          hotPictures.assignAll(hotPicturesData.map((e) => HotPicturesModel.fromJson(e)).toList());
          update();
        } else {
          Get.snackbar(
            'Failed',
            result['message'],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Failed',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('fetch hot pictures exception $e');
      }
    }
  }

  Future<bool> uploadStory({
    required String caption,
    XFile? media,
  }) async {
    String userId = userController.user.value!.userId;
    try {
      var formData = FormData({});

      formData.fields.add(MapEntry('user_id', userId));
      formData.fields.add(MapEntry('caption', caption));

      if (media != null) {
        Uint8List mediaBytes = await media.readAsBytes();
        formData.files.add(MapEntry(
          'media',
          MultipartFile(
            mediaBytes,
            filename: media.name,
          ),
        ));
      }

      final response = await postsRepo.uploadStory(formData);
      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          Get.snackbar(
            'Uploaded',
            result['message'],
            backgroundColor: AppColors.mainColor,
            colorText: AppColors.whiteColor,
          );

          await fetchStories();
          return true;
        } else {
          Get.snackbar(
            'Failed',
            result['message'],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        Get.snackbar(
          'Failed',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('upload story exception $e');
      }
      return false;
    }
  }

  Future<bool> uploadPost({
    required String caption,
    List<XFile>? mediaFiles,
  }) async {
    String userId = userController.user.value!.userId;
    try {
      var formData = FormData({});

      formData.fields.add(MapEntry('user_id', userId));
      formData.fields.add(MapEntry('caption', caption));

      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (var file in mediaFiles) {
          Uint8List fileBytes = await file.readAsBytes();
          formData.files.add(MapEntry(
            'media',
            MultipartFile(
              fileBytes,
              filename: file.name,
            ),
          ));
        }
      }

      final response = await postsRepo.uploadPost(formData);
      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          Get.snackbar(
            'Uploaded',
            result['message'],
            backgroundColor: AppColors.mainColor,
            colorText: AppColors.whiteColor,
          );

          await fetchPosts();
          return true;
        } else {
          Get.snackbar(
            'Failed',
            result['message'],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        Get.snackbar(
          'Failed',
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Upload post exception: $e');
      }
      return false;
    }
  }

  void toggleLike(String postId) {
    socketController.emitSocket('toggleLike', {'postId': postId});
  }

}
