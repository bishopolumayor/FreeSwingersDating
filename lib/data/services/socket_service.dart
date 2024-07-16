import 'package:flutter/foundation.dart';
import 'package:free_swingers_dating/controllers/conversations_controller.dart';
import 'package:free_swingers_dating/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  IO.Socket? _socket;
  final String appBaseUrl = AppConstants.BASE_URL;

  final RxBool isConnected = false.obs;

  Future<void> socketConnect(String userId) async {
    if (_socket != null && _socket!.connected) {
      _socket!.disconnect();
      await Future.delayed( const Duration(milliseconds: 500));
      _socket = null;
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(AppConstants.TOKEN);

    String connectionUrl = "$appBaseUrl?token=$token";

    /*_socket = IO.io(
        connectionUrl, IO.OptionBuilder().setTransports(['websocket']).build());*/

    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };

    _socket = IO.io(connectionUrl, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': headers,
      'forceNew': true,
    });

    print(connectionUrl);
    print(_socket!.connected);

    setupListeners();
    _socket!.connect();
    print(_socket!.connected);
  }

  void setupListeners() {
    _socket!.onConnect((_) {
      isConnected.value = true;
      if (kDebugMode) {
        print(_socket!.io.uri);
        print('Connected to Socket.IO server');
      }
    });

    _socket!.onConnectError((data) {
      if (kDebugMode) {
        print('Connection error: $data');
      }
      isConnected.value = false;
    });

    _socket!.on('error', (errorMessage) {
      if (kDebugMode) {
        print("Error received from server: $errorMessage");
      }
    });

    _socket!.onDisconnect((_) {
      isConnected.value = false;
      if (kDebugMode) {
        print('Disconnected from Socket.IO server');
      }
    });

    _socket!.on('conversationsFetched', (data) {
      if (kDebugMode) {
        print('Conversations fetched: $data');
      }

      ConversationsController conversationsController = Get.find<ConversationsController>();
      List<dynamic> conversationsData = data;
      conversationsController.setConversations(conversationsData);
    });

    _socket!.on('errorFetchingConversations', (message) {
      if (kDebugMode) {
        print('Error fetching conversations: $message');
      }
    });

    _socket!.on('messagesFetched', (data) {
      if (kDebugMode) {
        print('messages fetched: $data');
      }

      ConversationsController conversationsController = Get.find<ConversationsController>();
      List<dynamic> messagesData = data;
      conversationsController.setCurrentMessages(messagesData);
    });
  }

  Future<void> emit(String event, [dynamic data]) async {
    _socket!.emit(event, data);
  }

  void disconnect() {
    if (_socket != null && _socket!.connected) {
      _socket!.emit(
        'disconnect_profile',
        {'disconnect': true},
      );
      _socket!.clearListeners();
      _socket!.destroy();
      _socket!.dispose();
      _socket!.disconnect();
      _socket!.io.disconnect();
      _socket!.io.close();
      _socket!.io.destroy(_socket);
      _socket = null;
    }
  }
}
