import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/bar_loading_animation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeMainContainer extends StatefulWidget {
  final bool isLoginMode;
  final Function(bool) onToggle;
  final Function openDrawer;

  const HomeMainContainer({
    super.key,
    required this.isLoginMode,
    required this.onToggle,
    required this.openDrawer,
  });

  @override
  State<HomeMainContainer> createState() => _HomeMainContainerState();
}

class _HomeMainContainerState extends State<HomeMainContainer> {
  AuthController authController = Get.find<AuthController>();

  void toggleLoginMode(bool mode) {
    widget.onToggle(mode);
  }

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  String? _selectedIdentity;

  DateTime? _selectedDate;

  bool _is18plus = false;
  bool _rememberMe = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select your date of birth',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool _isLoading = false;
  bool _isLoading2 = false;
  int? totalNumberOfUsers;

  @override
  void initState() {
    super.initState();
    initializeWebsiteData();
  }

  void initializeWebsiteData() async {
    setState(() {
      _isLoading2 = true;
    });
    int? totalNumberOfUsersData = await authController.getTotalUsers();
    setState(() {
      totalNumberOfUsers = totalNumberOfUsersData;
      _isLoading2 = false;
    });
  }

  bool validateInputs() {
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Incomplete Inputs',
        'Fill out all your information',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Invalid Email',
        'Enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+$',
    );

    if (!passwordRegExp.hasMatch(passwordController.text)) {
      Get.snackbar(
        'Invalid Password',
        'Password must include a lowercase letter, an uppercase letter, a number, and a special character',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (_selectedIdentity == null) {
      Get.snackbar(
        'Incomplete Inputs',
        'select your sexuality',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (_selectedDate == null) {
      Get.snackbar(
        'Incomplete Inputs',
        'Select your date of birth',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!_is18plus) {
      Get.snackbar(
        'Can\'t proceed',
        'You have to be 18+ and accept to our terms and conditions to use our platform.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  void clearFields() {
    setState(() {
      _is18plus = false;
      _rememberMe = false;
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      _selectedIdentity = null;
      _selectedDate = null;
    });
  }

  Future<void> signUp() async {
    if(validateInputs()){
      setState(() {
        _isLoading = true;
      });
      await authController.signUp(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        identity: _selectedIdentity!,
        dateOfBirth: _selectedDate!.toString(),
      );
      clearFields();
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
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.widthRatio(67),
          ),
          child: widget.isLoginMode
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (_isLoading2)
                      Container(
                        height: isMobileView ? 10 : 15,
                        width: isMobileView ? Dimensions.screenWidth / (430 / 400) : isNotWidest ? Dimensions.screenWidth - Dimensions.widthRatio(500) - 50 : Dimensions.screenWidth - Dimensions.widthRatio(360) - 50,
                        child: const LinearProgressIndicator(
                          color: AppColors.mainColor,
                          backgroundColor: AppColors.mainColorLight,
                        ),
                      ),
                    // space
                    SizedBox(
                      height: isMobileView ? 20 : 120,
                    ),
                    // free swingers
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Free',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isMobileView ? 34 : 64,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobileView ? 34 : 64,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: 'Swingers',
                            style: TextStyle(
                              color: const Color(0xFF0000FF),
                              fontSize: isMobileView ? 34 : 64,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // welcome
                    Text(
                      '"Welcome to FreeSwinger,  Fun Fair & Free”',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isMobileView ? 14 : 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 15 : 40,
                    ),
                    // join us...
                    Text(
                      'Join us for free, today',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF0000FF),
                        fontSize: isMobileView ? 20 : 48,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 20,
                    ),
                    // members online
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Members Online:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isMobileView ? 20 : 34,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobileView ? 18 : 32,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: totalNumberOfUsers != null ? '$totalNumberOfUsers' : 'getting...',
                            style: TextStyle(
                              color: const Color(0xFF0000FF),
                              fontSize: isMobileView ? 20 : 32,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 15 : 32,
                    ),
                    // trusted
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // icon
                        Container(
                          width: Dimensions.widthRatio(35),
                          height: Dimensions.widthRatio(35),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/padlock.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                        SizedBox(
                          width: Dimensions.widthRatio(25),
                        ),
                        // text
                        Text(
                          'Trusted by swingers for swinging',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 20 : 32,
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
                        // icon
                        Container(
                          width: Dimensions.widthRatio(35),
                          height: Dimensions.widthRatio(35),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                        SizedBox(
                          width: Dimensions.widthRatio(25),
                        ),
                        // text
                        Text(
                          isMobileView
                              ? 'Verification system to find real \npeople'
                              : 'Verification system to find real people',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 20 : 32,
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
                        // icon
                        Container(
                          width: Dimensions.widthRatio(35),
                          height: Dimensions.widthRatio(35),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                        SizedBox(
                          width: Dimensions.widthRatio(25),
                        ),
                        // text
                        Text(
                          'Local search and updates',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 20 : 32,
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
                        // icon
                        Container(
                          width: Dimensions.widthRatio(35),
                          height: Dimensions.widthRatio(35),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                        SizedBox(
                          width: Dimensions.widthRatio(25),
                        ),
                        // text
                        Text(
                          'Preferred for genuine connections',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 20 : 32,
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
                        // icon
                        Container(
                          width: Dimensions.widthRatio(35),
                          height: Dimensions.widthRatio(35),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                        SizedBox(
                          width: Dimensions.widthRatio(25),
                        ),
                        // text
                        Text(
                          isMobileView
                              ? 'Trustworthy environment with\nauthentication'
                              : 'Trustworthy environment with authentication',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 20 : 32,
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
                        // icon
                        Container(
                          width: Dimensions.widthRatio(35),
                          height: Dimensions.widthRatio(35),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/check.png',
                              ),
                            ),
                          ),
                        ),
                        // space
                        SizedBox(
                          width: Dimensions.widthRatio(25),
                        ),
                        // text
                        Text(
                          isMobileView
                              ? 'Reliable platform for like-minded\nconnections'
                              : 'Reliable platform for like-minded connections',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isMobileView ? 20 : 32,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 70 : 140,
                    ),
                    // genuine ...
                    GestureDetector(
                      onTap: () => toggleLoginMode(false),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Genuine Swingers, Welcome',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isMobileView ? 14 : 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobileView ? 14 : 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'Join now',
                              style: TextStyle(
                                color: const Color(0xFF0000FF),
                                fontSize: isMobileView ? 14 : 20,
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
                      height: isMobileView ? 14 : 24,
                    ),
                    // already ...
                    GestureDetector(
                      onTap: () {
                        if (isMobileView) {
                          widget.openDrawer();
                        }
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already Registered?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isMobileView ? 14 : 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobileView ? 14 : 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: const Color(0xFF0000FF),
                                fontSize: isMobileView ? 14 : 20,
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
                      height: isMobileView ? 20 : 47,
                    ),
                    // 18 and above
                    Text(
                      isMobileView
                          ? 'FreeSwingers is exclusively for individuals aged 18 \nyears or older.'
                          : 'FreeSwingers is exclusively for individuals aged 18 years or older.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isMobileView ? 14 : 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 100 : 420,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 30,
                    ),
                    // logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: isMobileView ? 100 : 240,
                          width: isMobileView ? 100 : 240,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/fs_logo.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 20 : 40,
                    ),
                    // text
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isMobileView ? 12 : 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                              text:
                                  'USE A NAME YOU WOULD LOVE TO BE ADDRESSED AS',
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: isMobileView ? 12 : 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              )),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isMobileView ? 12 : 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 10 : 30,
                    ),
                    // username
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: isMobileView ? 14 : 20,
                          ),
                        ),
                        SizedBox(
                          width: isMobileView ? 20 : 60,
                        ),
                        SizedBox(
                          width: isMobileView ? 250 : 500,
                          // height: isMobileView ? 50 : 60,
                          child: TextField(
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
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 15 : 40,
                    ),
                    // email address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: isMobileView ? 13 : 20,
                          ),
                        ),
                        SizedBox(
                          width: isMobileView ? 20 : 60,
                        ),
                        SizedBox(
                          width: isMobileView ? 270 : 500,
                          // height: isMobileView ? 50 : 60,
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
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
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 15 : 40,
                    ),
                    // password
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: isMobileView ? 14 : 20,
                          ),
                        ),
                        SizedBox(
                          width: isMobileView ? 20 : 60,
                        ),
                        SizedBox(
                          width: isMobileView ? 250 : 500,
                          // height: isMobileView ? 50 : 60,
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
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
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 15 : 40,
                    ),
                    // you identify as
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'You are identified as a...',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: isMobileView ? 14 : 20,
                          ),
                        ),
                        SizedBox(
                          width: isMobileView ? 10 : 40,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: isMobileView ? 200 : 400,
                              child: RadioListTile<String>(
                                title: const Text('Male'),
                                value: 'Male',
                                groupValue: _selectedIdentity,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedIdentity = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: isMobileView ? 200 : 400,
                              child: RadioListTile<String>(
                                title: const Text('Female'),
                                value: 'Female',
                                groupValue: _selectedIdentity,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedIdentity = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: isMobileView ? 200 : 400,
                              child: RadioListTile<String>(
                                title: const Text('Couple (MF)'),
                                value: 'Couple (MF)',
                                groupValue: _selectedIdentity,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedIdentity = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: isMobileView ? 200 : 400,
                              child: RadioListTile<String>(
                                title: const Text('Male Couple (MM)'),
                                value: 'Male Couple (MM)',
                                groupValue: _selectedIdentity,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedIdentity = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: isMobileView ? 200 : 400,
                              child: RadioListTile<String>(
                                title: const Text('Female Couple (FF)'),
                                value: 'Female Couple (FF)',
                                groupValue: _selectedIdentity,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedIdentity = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: isMobileView ? 200 : 400,
                              child: RadioListTile<String>(
                                title: const Text('TV/TS/CD'),
                                value: 'TV/TS/CD',
                                groupValue: _selectedIdentity,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedIdentity = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 15 : 40,
                    ),
                    // date
                    Row(
                      children: [
                        Text(
                          'Date of birth',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: isMobileView ? 14 : 20,
                          ),
                        ),
                        SizedBox(
                          width: isMobileView ? 20 : 60,
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            width: isMobileView ? 250 : 450,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _selectedDate == null
                                  ? 'Select date'
                                  : DateFormat.yMd().format(_selectedDate!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 25 : 50,
                    ),
                    // is 18 plus
                    Row(
                      children: [
                        Checkbox(
                          value: _is18plus,
                          onChanged: (bool? value) {
                            setState(() {
                              _is18plus = value!;
                            });
                          },
                          activeColor: AppColors.mainColor,
                        ),
                        SizedBox(
                          width: isMobileView ? 15 : 30,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I am 18+ and i agree to this site\'s ',
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  fontSize: isMobileView ? 14 : 18,
                                ),
                              ),
                              TextSpan(
                                text: isMobileView
                                    ? '\nterms and conditions'
                                    : 'terms and conditions',
                                style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Poppins',
                                  fontSize: isMobileView ? 14 : 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 7 : 20,
                    ),
                    // remember me
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                          activeColor: AppColors.mainColor,
                        ),
                        SizedBox(
                          width: isMobileView ? 15 : 30,
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            fontSize: isMobileView ? 14 : 18,
                          ),
                        ),
                        SizedBox(
                          width: isMobileView
                              ? Dimensions.screenWidth / (430 / 130)
                              : 360,
                        ),
                      ],
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 25 : 50,
                    ),
                    // create my account
                    GestureDetector(
                      onTap: () {
                       if(!_isLoading) {
                          signUp();
                        }
                      },
                      child: Container(
                        width: isMobileView ? 280 : 380,
                        height: isMobileView ? 46 : 56,
                        decoration: BoxDecoration(
                          color: _isLoading ? Colors.grey.shade800 :  AppColors.mainColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            _isLoading ? 'Please wait...' : 'Create my account',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontFamily: 'Poppins',
                              fontSize: isMobileView ? 16 : 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // space
                    SizedBox(
                      height: isMobileView ? 25 : 50,
                    ),
                    // already ...
                    GestureDetector(
                      onTap: () => toggleLoginMode(true),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already Registered?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isMobileView ? 14 : 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobileView ? 14 : 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: const Color(0xFF0000FF),
                                fontSize: isMobileView ? 14 : 20,
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
                      height: isMobileView ? 60 : 80,
                    ),
                  ],
                ),
        ),
        if (_isLoading)
           Center(
            child: SizedBox(
              width: isMobileView ? Dimensions.screenWidth : isNotWidest ? Dimensions.screenWidth - Dimensions.widthRatio(500) - 50 : Dimensions.screenWidth - Dimensions.widthRatio(360) - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: isMobileView ? 600 : 800,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BarLoadingAnimation(),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
