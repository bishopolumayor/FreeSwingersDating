import 'package:flutter/material.dart';
import 'package:free_swingers_dating/controllers/auth_controller.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/menu_item.dart';
import 'package:get/get.dart';

class HotPicturesSideBar extends StatefulWidget {
  final Function(int) changePage;

  const HotPicturesSideBar({
    super.key,
    required this.changePage,
  });

  @override
  State<HotPicturesSideBar> createState() => _HotPicturesSideBarState();
}

class _HotPicturesSideBarState extends State<HotPicturesSideBar> {
  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobileView ? Dimensions.screenWidth / (430 / 350) : 300,
      height: isMobileView ? double.maxFinite : Dimensions.heightRatio(845),
      // 700 ,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // menu
          Container(
            height: 70,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: AppColors.mainColor,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: isMobileView ? 50 : 50,
                ),
                Text(
                  'MENU',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: 'Poppins',
                    fontSize: isMobileView ? 18 : 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.changePage(1);
                    },
                    child: Container(
                      height: 60,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        color: AppColors.mainColorLight,
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: AppColors.greyColor1,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: isMobileView ? 50 : 50,
                            ),
                            Text(
                              'Latest Photos',
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
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.changePage(2);
                    },
                    child: Container(
                      height: 60,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        color: AppColors.mainColorLight,
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: AppColors.greyColor1,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: isMobileView ? 50 : 50,
                            ),
                            Text(
                              'Videos',
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
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.changePage(3);
                    },
                    child: Container(
                      height: 60,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        color: AppColors.mainColorLight,
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: AppColors.greyColor1,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: isMobileView ? 50 : 50,
                            ),
                            Text(
                              'Top Photos',
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
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.changePage(4);
                    },
                    child: Container(
                      height: 60,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        color: AppColors.mainColorLight,
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: AppColors.greyColor1,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: isMobileView ? 50 : 50,
                            ),
                            Text(
                              'Top Videos',
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
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.changePage(5);
                    },
                    child: Container(
                      height: 60,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        color: AppColors.mainColorLight,
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: AppColors.greyColor1,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: isMobileView ? 50 : 50,
                            ),
                            Text(
                              'Top Photos of 2024',
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
