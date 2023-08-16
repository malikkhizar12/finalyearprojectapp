

import 'package:course_guide/controllers/firebase_auth_controller.dart';
import 'package:course_guide/controllers/setting_drawer_controller.dart';
import 'package:course_guide/core/exceptions.dart';
import 'package:course_guide/core/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SettingsDrawer extends GetView<SettingDrawerController> {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("DashBoard"),
            onTap: () {
              Get.offNamed('/dashBoard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_attributes),
            title: const Text("Edit Profile"),
            onTap: () async {
              Get.offNamed('/editProfilePage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text("Feed Back"),
            onTap: () {
              // Handle onTap action
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Logout"),
            onTap: () async {
              try {
                final firebaseController = Get
                    .put(FirebaseAuthController());
                await firebaseController.signOut();
                showToast("Success", "Logged out successfully");
                Get.delete<FirebaseAuthController>();
                Get.offAllNamed('/');
              } catch (e) {
                String errorMessage = handleExceptionError(e);
                showToast('Error', errorMessage);
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }
}
