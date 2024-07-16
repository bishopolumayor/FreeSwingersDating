import 'package:flutter/material.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // space
        SizedBox(
          width: Dimensions.widthRatio(40),
        ),
        // terms
        const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.20,
          ),
        ),
        // space
        SizedBox(
          width: Dimensions.widthRatio(40),
        ),
        // privacy
        const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.20,
          ),
        ),
        // space
        SizedBox(
          width: Dimensions.widthRatio(40),
        ),
        // copy right ...
        const Text(
          'Copyright © 2024 freeswingers',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w400,
          ),
        ),
        // space
        SizedBox(
          width: Dimensions.widthRatio(40),
        ),
        // facebook
        Container(
          width: Dimensions.widthRatio(27),
          height: Dimensions.widthRatio(27),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/facebook.png',
              ),
            ),
          ),
        ),
        // space
        SizedBox(
          width: Dimensions.widthRatio(20),
        ),
        // twitter
        Container(
          width: Dimensions.widthRatio(27),
          height: Dimensions.widthRatio(27),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/twitter.png',
              ),
            ),
          ),
        ),
        // space
        SizedBox(
          width: Dimensions.widthRatio(20),
        ),
        // instagram
        Container(
          width: Dimensions.widthRatio(27),
          height: Dimensions.widthRatio(27),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/instagram.png',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
