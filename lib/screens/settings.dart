import 'package:course_guide/controllers/drawer_controller.dart';
import 'package:course_guide/core/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:course_guide/controllers/setting_controllers.dart';

class SettingsPage extends GetView<SettingController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomDrawerController drawerController = Get.put(CustomDrawerController());
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 3,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            drawerController.toggleDrawer(controller.scaffoldKey);
          },
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Transform.scale(
              scale: 0.7,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    Get.toNamed('/settings');
                  },
                  iconSize: 40,
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: SettingsBody(),
    );
  }
}

class SettingsBody extends StatefulWidget {
  @override
  _SettingsBodyState createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              height: 56,
              child: SwitchListTile(
                activeColor: Colors.black,
                title: Text("Dark Theme"),
                value: isDarkTheme,
                onChanged: (value) {
                  setState(() {
                    isDarkTheme = value;
                  });
                },
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.1)),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Handle container tap action
              },
              child: Container(
                height: 56,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        // Handle button click
                      },
                    ),
                    Text("Terms & Conditions"),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
