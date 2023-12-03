import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingDrawerController extends GetxController
{
  RxBool isDrawerOpen = false.obs;
  void openDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState?.openDrawer();
    isDrawerOpen.value = !isDrawerOpen.value;
  }
}