import 'package:flutter/material.dart';
import 'package:free_swingers_dating/routes/routes.dart';
import 'package:free_swingers_dating/screens/home/sections/home_feed.dart';
import 'package:free_swingers_dating/utils/colors.dart';
import 'package:free_swingers_dating/utils/dimensions.dart';
import 'package:free_swingers_dating/widgets/conversation_container.dart';
import 'package:free_swingers_dating/widgets/footer.dart';
import 'package:free_swingers_dating/widgets/header.dart';
import 'package:free_swingers_dating/widgets/home_main_container.dart';
import 'package:free_swingers_dating/widgets/home_side_bar.dart';
import 'package:free_swingers_dating/widgets/mobile_side_bar.dart';
import 'package:free_swingers_dating/widgets/side_bar.dart';
import 'package:get/get.dart';

class MessageTextField extends StatefulWidget {
  final Function(String) onMessageSent;
  final TextEditingController textController;

  const MessageTextField({
    super.key,
    required this.textController,
    required this.onMessageSent,
  });

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  bool get isNotWidest => Dimensions.isNotWidest();

  bool get isMobileView => Dimensions.isMobileView();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isMobileView ? Dimensions.screenHeight / (932 / 8) : 10,
          horizontal: isMobileView ? Dimensions.screenWidth / (439 / 15) : 20,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isMobileView?5:8),
          ),
          child: Row(
            children: [
              // space
              SizedBox(
                width: isMobileView ?  Dimensions.screenWidth / (430 / 7) : 10,
              ),
              // text field
              Expanded(
                child: TextField(
                  controller: widget.textController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical:isMobileView? Dimensions.screenHeight / (932 / 8) : 10,
                      horizontal:isMobileView? Dimensions.screenWidth / (430 / 16) : 20,
                    ),
                   border: const OutlineInputBorder(
                     borderSide: BorderSide.none,
                   ),
                   /* border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          isMobileView ?  Dimensions.screenHeight / (932 / 10) : 12),
                      borderSide: BorderSide(color: Colors.grey.shade500),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          isMobileView ?  Dimensions.screenHeight / (932 / 10) : 12),
                      borderSide: BorderSide(color: Colors.grey.shade500),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          isMobileView ?  Dimensions.screenHeight / (932 / 10) : 12),
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),*/
                    hintText: 'Type your Message...',
                    filled: true,
                    fillColor: AppColors.whiteColor,
                  ),
                  cursorColor: AppColors.mainColor,
                ),
              ),
              // space
              SizedBox(
                width: isMobileView ?  Dimensions.screenWidth / (430 / 15) : 20,
              ),
              // send
              GestureDetector(
                onTap: () {
                  widget.onMessageSent(widget.textController.text);
                  widget.textController.clear();
                },
                child: Container(
                  height: isMobileView ?  Dimensions.screenHeight / (932 / 25) : 40,
                  width: isMobileView ?   Dimensions.screenWidth / (430 / 25) : 40,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/send.png'),
                    ),
                  ),
                ),
              ),
              // space
              SizedBox(
                width: isMobileView ?  Dimensions.screenWidth / (430 / 10) : 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}