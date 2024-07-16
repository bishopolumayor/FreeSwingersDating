import 'package:flutter/material.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';

class Header extends StatefulWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const Header({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // space
        SizedBox(
          width: isMobileView ? 6 :  Dimensions.widthRatio(23),
        ),
        // logo
        Container(
          height: isMobileView ? 60 : 73,
          width: isMobileView
              ? Dimensions.widthRatio(60)
              : Dimensions.widthRatio(73),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/free_swingers.png',
              ),
            ),
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 : Dimensions.widthRatio(38),
        ),
        // home
        GestureDetector(
          onTap: () => widget.onTabChanged(0),
          child: Column(
            children: [
              // space
               SizedBox(
                height: isMobileView ? 5 : 15,
              ),
              // home
               Text(
                'Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.selectedTab == 0 ? AppColors.mainColor :  Colors.black,
                  fontSize: isMobileView ? 8 : 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // space
              const SizedBox(
                height: 5,
              ),
              // under line
              Container(
                width: isMobileView
                    ? Dimensions.widthRatio(60)
                    : Dimensions.widthRatio(20),
                height: 2,
                decoration: ShapeDecoration(
                  color: widget.selectedTab == 0 ? AppColors.mainColor : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 : Dimensions.widthRatio(25),
        ),
        // my accounts
        GestureDetector(
          onTap: () => widget.onTabChanged(1),
          child: Column(
            children: [
              // space
               SizedBox(
                height: isMobileView ? 5 : 15,
              ),
              // my accounts
               Text(
                 isMobileView ? 'My Account' :'My Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:  widget.selectedTab == 1 ? AppColors.mainColor : Colors.black,
                   fontSize: isMobileView ? 8 : 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // space
              const SizedBox(
                height: 5,
              ),
              // under line
              Container(
                width: isMobileView
                    ? Dimensions.widthRatio(60)
                    : Dimensions.widthRatio(20),
                height: 2,
                decoration: ShapeDecoration(
                  color: widget.selectedTab == 1 ? AppColors.mainColor : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 : Dimensions.widthRatio(25),
        ),
        // hot pictures
        GestureDetector(
          onTap: () => widget.onTabChanged(2),
          child: Column(
            children: [
              // space
              SizedBox(
                height: isMobileView ? 5 :15,
              ),
              // hot pictures
               Text(
                 isMobileView ? 'Hot Pictures' :'Hot Pictures',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.selectedTab == 2 ? AppColors.mainColor : Colors.black,
                  fontSize: isMobileView ? 8 : 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // space
              const SizedBox(
                height: 5,
              ),
              // under line
              Container(
                width: isMobileView
                    ? Dimensions.widthRatio(60)
                    : Dimensions.widthRatio(20),
                height: 2,
                decoration: ShapeDecoration(
                  color: widget.selectedTab == 2 ? AppColors.mainColor : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 : Dimensions.widthRatio(25),
        ),
        // events
        GestureDetector(
          onTap: () => widget.onTabChanged(3),
          child: Column(
            children: [
              // space
               SizedBox(
                height: isMobileView ? 5 : 15,
              ),
              // events
               Text(
                'Events',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.selectedTab == 3 ? AppColors.mainColor : Colors.black,
                  fontSize: isMobileView ? 8 : 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // space
              const SizedBox(
                height: 5,
              ),
              // under line
              Container(
                width: isMobileView
                    ? Dimensions.widthRatio(60)
                    : Dimensions.widthRatio(20),
                height: 2,
                decoration: ShapeDecoration(
                  color: widget.selectedTab == 3 ? AppColors.mainColor :Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 : Dimensions.widthRatio(25),
        ),
        // clubs
        GestureDetector(
          onTap: () => widget.onTabChanged(4),
          child: Column(
            children: [
              // space
               SizedBox(
                height: isMobileView ? 5 : 15,
              ),
              // clubs
               Text(
                'Clubs',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.selectedTab == 4 ? AppColors.mainColor : Colors.black,
                  fontSize: isMobileView ? 8 : 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // space
              const SizedBox(
                height: 5,
              ),
              // under line
              Container(
                width: isMobileView
                    ? Dimensions.widthRatio(60)
                    : Dimensions.widthRatio(20),
                height: 2,
                decoration: ShapeDecoration(
                  color: widget.selectedTab == 4 ? AppColors.mainColor : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 : Dimensions.widthRatio(25),
        ),
        // forum
        GestureDetector(
          onTap: () => widget.onTabChanged(5),
          child: Column(
            children: [
              // space
               SizedBox(
                height: isMobileView ? 5 : 15,
              ),
              // forum
               Text(
                'Forum',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.selectedTab == 5 ? AppColors.mainColor : Colors.black,
                  fontSize: isMobileView ? 8 : 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // space
              const SizedBox(
                height: 5,
              ),
              // under line
              Container(
                width: isMobileView
                    ? Dimensions.widthRatio(60)
                    : Dimensions.widthRatio(20),
                height: 2,
                decoration: ShapeDecoration(
                  color: widget.selectedTab == 5 ? AppColors.mainColor : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 :Dimensions.widthRatio(25),
        ),
        // chat
        GestureDetector(
          onTap: () => widget.onTabChanged(6),
          child: Column(
            children: [
              // space
               SizedBox(
                height: isMobileView ? 5 : 15,
              ),
              // chat
               Text(
                'Chat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.selectedTab == 6 ? AppColors.mainColor : Colors.black,
                  fontSize: isMobileView ? 8 : 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // space
              const SizedBox(
                height: 5,
              ),
              // under line
              Container(
                width: isMobileView
                    ? Dimensions.widthRatio(60)
                    : Dimensions.widthRatio(20),
                height: 2,
                decoration: ShapeDecoration(
                  color: widget.selectedTab == 6 ? AppColors.mainColor : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 : Dimensions.widthRatio(25),
        ),
        // search
        GestureDetector(
          onTap: () => widget.onTabChanged(7),
          child: Column(
            children: [
              // space
               SizedBox(
                height: isMobileView ? 5 : 15,
              ),
              // search
               Text(
                'Search',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.selectedTab == 7 ? AppColors.mainColor : Colors.black,
                  fontSize: isMobileView ? 8 : 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // space
              const SizedBox(
                height: 5,
              ),
              // under line
              Container(
                width: isMobileView
                    ? Dimensions.widthRatio(60)
                    : Dimensions.widthRatio(20),
                height: 2,
                decoration: ShapeDecoration(
                  color: widget.selectedTab == 7 ? AppColors.mainColor : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 :Dimensions.widthRatio(25),
        ),
        // meet
        GestureDetector(
          onTap: () => widget.onTabChanged(8),
          child: Column(
            children: [
              // space
               SizedBox(
                height: isMobileView ? 5 : 15,
              ),
              // meet
               Text(
                'Meet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.selectedTab == 8 ? AppColors.mainColor : Colors.black,
                  fontSize: isMobileView ? 8 : 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              // space
              const SizedBox(
                height: 5,
              ),
              // under line
              Container(
                width: isMobileView
                    ? Dimensions.widthRatio(60)
                    : Dimensions.widthRatio(20),
                height: 2,
                decoration: ShapeDecoration(
                  color: widget.selectedTab == 8 ? AppColors.mainColor : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        // space
        SizedBox(
          width: isMobileView ? 10 : Dimensions.widthRatio(25),
        ),
      ],
    );
  }
}
