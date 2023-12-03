import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart';
import 'fonts.dart';

showToast(String title, String msg, {bool err = false}) {
  Get.snackbar(title, msg,
      colorText: err ? kRedColor : kWhiteColor,
      backgroundColor: kBlackColor.withOpacity(0.8),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
      borderColor: kPrimaryColor,
      borderWidth: 1);
}

showLoader({double height = 50, double width = 50}) {
  return Center(
    child: SizedBox(
      height: height,
      width: width,
      child: const CircularProgressIndicator(
        color: kSecondaryColor,
      ),
    ),
  );
}

showGeneratingLoader(
    {double height = 100, double width = 100, String title = ''}) {
  return Center(
      child: Material(
    color: Colors.transparent,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: height,
            width: width,
            child: const CircularProgressIndicator(
              strokeWidth: 8,
              color: kSecondaryColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: fontUrbanist(
                  color: kWhiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              )
            ],
          ),
        )
      ],
    ),
  ));
}
