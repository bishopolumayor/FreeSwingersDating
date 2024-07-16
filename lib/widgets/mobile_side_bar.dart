import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/bar_loading_animation.dart';
import 'package:get/get.dart';

class MobileSideBar extends StatefulWidget {
  final bool isLoginMode;

  const MobileSideBar({super.key, required this.isLoginMode});

  @override
  State<MobileSideBar> createState() => _MobileSideBarState();
}

class _MobileSideBarState extends State<MobileSideBar> {
  AuthController authController = Get.find<AuthController>();

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  bool keepLoggedIn = false;

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  bool _isLoading = false;

  bool validateInputs() {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Incomplete Inputs',
        'Enter your username and password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> login() async {
    if (validateInputs()) {
      setState(() {
        _isLoading = true;
      });
      await authController.login(
        identifier: usernameController.text,
        password: passwordController.text,
        rememberMe: keepLoggedIn,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: Dimensions.screenWidth / (430 / 350),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: Colors.black,
            ),
          ),
          child: widget.isLoginMode
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // login
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: Dimensions.widthRatio(22),
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                      ),
                      child: const Center(
                        child: Row(
                          children: [
                            // login
                            Text(
                              'LOGIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 35,
                    ),
                    // username
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthRatio(10),
                      ),
                      child: const Text(
                        'Username or Email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 5,
                    ),
                    // text field
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.75,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      cursorColor: AppColors.mainColor,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 30,
                    ),
                    // password
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthRatio(10),
                      ),
                      child: const Text(
                        'Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 5,
                    ),
                    // text field
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.75,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      cursorColor: AppColors.mainColor,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 16,
                    ),
                    // keep me logged in ...
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthRatio(20),
                      ),
                      child: Row(
                        children: [
                          // keep me logged in
                          const Text(
                            'Keep me logged in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // space
                          SizedBox(
                            width: Dimensions.widthRatio(13),
                          ),
                          // check box
                          Checkbox(
                            value: keepLoggedIn,
                            onChanged: (bool? value) {
                              setState(() {
                                keepLoggedIn = value!;
                              });
                            },
                            activeColor: AppColors.mainColor,
                            hoverColor: AppColors.mainColorLight,
                          ),
                        ],
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 15,
                    ),
                    // login
                    Row(
                      children: [
                        // login
                        GestureDetector(
                          onTap: login,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.widthRatio(22),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.widthRatio(35),
                              vertical: 9,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.mainColor,
                            ),
                            child: const Center(
                              child: Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.70,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // space
                        const Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                    // space
                    const SizedBox(
                      height: 16,
                    ),
                    // forgot password
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthRatio(22),
                      ),
                      child: const Text(
                        'Forgotten Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 42,
                    ),
                    // quick links
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: Dimensions.widthRatio(17),
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Quick Links',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 15,
                    ),
                    // new couples
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthRatio(26),
                      ),
                      child: const Text(
                        'New Couples',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 25,
                    ),
                    // new women
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthRatio(26),
                      ),
                      child: const Text(
                        'New Women',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 25,
                    ),
                    // new men
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthRatio(26),
                      ),
                      child: const Text(
                        'New Men',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 25,
                    ),
                    // couples online now
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthRatio(26),
                      ),
                      child: const Text(
                        'Couples Online Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // space
                    const SizedBox(
                      height: 25,
                    ),
                    // chatting now
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthRatio(26),
                      ),
                      child: const Text(
                        'Chatting Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    if (!isNotWidest)
                      // space
                      const SizedBox(
                        height: 952,
                      ),
                  ],
                )
              : Column(
                  children: [
                    // signup
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: Dimensions.widthRatio(22),
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                      ),
                      child: const Center(
                        child: Row(
                          children: [
                            // login
                            Text(
                              'SIGNUP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 50 : 32,
                    ),
                    // trusted
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        // icon
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/padlock.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // text
                        Text(
                          'Trusted by swingers for swinging',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 14 : 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 25 : 50,
                    ),
                    // verification ...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        // icon
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // text
                        Text(
                          isMobileView
                              ? 'Verification system to find real \npeople'
                              : 'Verification system to find real people',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 14 : 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 25 : 50,
                    ),
                    // local search ...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        // icon
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // text
                        Text(
                          'Local search and updates',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 14 : 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 25 : 50,
                    ),
                    // preferred ...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        // icon
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                         const SizedBox(
                          width: 10,
                        ),
                        // text
                        Text(
                          'Preferred for genuine connections',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 14 : 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 25 : 50,
                    ),
                    // trust worthy ...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        // icon
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                        const SizedBox(
                          width: 10,
                        ),
                        // text
                        Text(
                          isMobileView
                              ? 'Trustworthy environment with\nauthentication'
                              : 'Trustworthy environment with\nauthentication',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 14 : 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 25 : 50,
                    ),
                    // reliable ...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        // icon
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // text
                        Text(
                          isMobileView
                              ? 'Reliable platform for like-minded\nconnections'
                              : 'Reliable platform for like-minded\nconnections',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 14 : 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    if (!isNotWidest)
                      // space
                      const SizedBox(
                        height: 952,
                      ),
                  ],
                ),
        ),
        if (_isLoading)
          const Center(
            child: BarLoadingAnimation(),
          ),
      ],
    );
  }
}
