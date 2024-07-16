import 'package:flutter/material.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';

class MenuItem extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const MenuItem({
    super.key,
    required this.onPressed,
    required this.text,
  });

  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 50,
        width: double.maxFinite,
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: isMobileView ? 50 : 50,
              ),
              Text(
                text,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: isMobileView ? 16 : 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
