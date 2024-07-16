import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/socket_controller.dart';
import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/data/repo/conversations_repo.dart';
import 'package:free_swingers_dating/models/conversation_model.dart';
import 'package:free_swingers_dating/models/message_model.dart';
import 'package:get/get.dart';

class ConversationsController extends GetxController {
  final ConversationsRepo conversationsRepo;

  ConversationsController({
    required this.conversationsRepo,
  });

  var conversations = <ConversationModel>[].obs;
  var selectedMessages = <MessageModel>[].obs;

  UserController userController = Get.find<UserController>();
  SocketController socketController = Get.find<SocketController>();

  Future<void> fetchConversations() async {
    String userId = userController.user.value!.userId;
    try {
      Response response = await conversationsRepo.getConversations(userId);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> conversationsData = result['data'];
         setConversations(conversationsData);
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
        print('fetch conversations exception $e');
      }
    }
  }

  void setConversations (List<dynamic> conversationsData){
    conversations.assignAll(conversationsData
        .map((e) => ConversationModel.fromJson(e))
        .toList());
    update();
  }

  void setCurrentMessages(List<dynamic> messagesData){
    selectedMessages.clear();
    selectedMessages.assignAll(
        messagesData.map((e) => MessageModel.fromJson(e)).toList());
    update();
  }

  Future<void> fetchMessageByConversation(String conversationId) async {
    try {
      Response response =
          await conversationsRepo.getMessagesByConversation(conversationId);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          List<dynamic> messagesData = result['data'];
          setCurrentMessages(messagesData);
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
        print('fetch messages exception $e');
      }
    }
  }

  Future<void> createConversation(String recipientId) async {
    String userId = userController.user.value!.userId;
    try {
      var data = {
        "participantA": userId,
        "participantB": recipientId,
      };

      Response response = await conversationsRepo.createConversation(data);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          await fetchConversations();
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
        print('create conversation exception $e');
      }
    }
  }

  Future<bool> createConversationBool(String recipientId) async {
    String userId = userController.user.value!.userId;
    try {
      var data = {
        "participantA": userId,
        "participantB": recipientId,
      };

      Response response = await conversationsRepo.createConversation(data);

      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          await fetchConversations();
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
        print('create conversation exception $e');
      }
      return false;
    }
  }

  Future<void> sendMessage(String conversationId, String text) async {
    try{
      String userId = userController.user.value!.userId;
      var data = {
        "conversationId": conversationId,
        "senderId": userId,
        "text": text,
      };

      Response response = await conversationsRepo.createMessage(data);
      var result = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == 200 || result['status'] == 201) {
          await fetchConversations();
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

    }catch (e) {
      if (kDebugMode) {
        print('create conversation exception $e');
      }
    }

  }

  Future<void> fetchConversationsWithSocket() async {
    String userId = userController.user.value!.userId;
    socketController.emitSocket('fetchConversations', userId);
  }

  Future<void> getMessagesWithSocket(String conversationId) async {
    selectedMessages.clear();
    socketController.emitSocket('getMessages', conversationId);
  }

  Future<void> sendMessageWithSocket(String conversationId, String text) async {
    var data = {
      'conversationId' : conversationId,
      'text' : text,
    };
    socketController.emitSocket('sendMessage', data);
    fetchConversationsWithSocket();

    // getMessagesWithSocket(conversationId);
  }

}
