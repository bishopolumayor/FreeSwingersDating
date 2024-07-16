import 'package:free_swingers_dating/controllers/user_controller.dart';
import 'package:free_swingers_dating/data/services/socket_service.dart';
import 'package:get/get.dart';

class SocketController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();

  RxBool get isConnected => socketService.isConnected;

  void connectSocket() async {
    UserController userController = Get.find<UserController>();
    String userId = userController.user.value!.userId;
    await socketService.socketConnect(userId);
  }

  Future<void> emitSocket(String event, [dynamic data]) async {
    await socketService.emit(event, data);
  }

  void disconnectSocket() {
    socketService.disconnect();
  }

  @override
  void onClose() {
    socketService.disconnect();
    super.onClose();
  }
}
