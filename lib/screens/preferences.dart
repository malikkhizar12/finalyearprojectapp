import 'package:course_guide/controllers/drawer_controller.dart';
import 'package:course_guide/controllers/preferences_controller.dart';
import 'package:course_guide/core/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:course_guide/controllers/preferences_controller.dart';

import '../controllers/firebase_auth_controller.dart';

class PreferencesPage extends StatelessWidget {
  final List<String> courseCategories = ['AI', 'Web', 'Mobile App'];
  final List<String> courseLevels = ['Easy', 'Intermediate', 'Hard'];

  final TextEditingController categoryController =
  TextEditingController(text: 'AI');
  final TextEditingController levelController =
  TextEditingController(text: 'Easy');
  final PreferencesController preferencesController =
  PreferencesController();
  final CustomDrawerController drawerController =
  Get.put(CustomDrawerController());
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void savePreferences() {
    String selectedCategory = categoryController.text;
    String selectedLevel = levelController.text;

    preferencesController
        .savePreferences(selectedCategory, selectedLevel)
        .then((_) {
      // Display a success message
      Get.snackbar('Success', 'Preferences saved!');

      // Navigate to the dashboard
      Get.offAndToNamed('/dashBoard');
    }).catchError((error) {
      // Display an error message
      Get.snackbar('Error', 'Failed to save preferences');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // Add the key to the Scaffold widget
      appBar: AppBar(
        title: const Text(
          "CourseGuide",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 3,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            drawerController.toggleDrawer(scaffoldKey);
          },
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Transform.scale(
              scale: 0.7, // Set the desired scale value for the size increase
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    Get.toNamed('/settings');
                    // settingDrawerController.openDrawer(scaffoldKey);
                  },
                  iconSize: 40, // Set the original size of the icon
                  icon: const Icon(
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              "Preferences ".toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: categoryController.text,
                    items: courseCategories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      categoryController.text = newValue!;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      labelText: "Course Category",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: levelController.text,
                    items: courseLevels.map((level) {
                      return DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      levelController.text = newValue!;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint_rounded),
                      labelText: "Course Level",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: savePreferences,
                      child: Text('Save Preferences'.toUpperCase()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.7),
                        shape: const RoundedRectangleBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
