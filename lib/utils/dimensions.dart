import 'package:get/get.dart';

class Dimensions {
  static double screenWidth = Get.context!.width;
  static double screenHeight = Get.context!.height;

  static double heightRatio(double divisor) {
    return screenHeight / (993 / divisor);
  }

  static double widthRatio(double divisor) {
    return screenWidth / (1512 / divisor);
  }

  static bool isNotWidest(){
    return screenWidth <= 1000;
  }

  static bool isMobileView(){
    return screenWidth <= 600;
  }

}