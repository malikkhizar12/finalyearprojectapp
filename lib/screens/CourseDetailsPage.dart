import 'package:course_guide/controllers/firebase_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

class CourseDetailPage extends StatelessWidget {
  CourseDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    if (arguments != null) {
      final courseTitle = arguments['courseTitle'];
      final courseSummary = arguments['courseSummary'];

      final courseDuration = arguments['courseDuration'];
      final courseURL = arguments['courseURL'];
      final coursePlatform = arguments['coursePlatform'];
      final firebaseAuthController = Get.put(FirebaseAuthController());
      RxBool isSavingCourse = false.obs;
      bool isSavedCourse = Get.arguments?['isSavedCourse'] ?? false;
      return Scaffold(
        appBar: null,
        body: Stack(
          children:[
            Image.asset(
              'assets/images/edit_profile_background.webp',// Replace with the path to your background image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: ListView(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    courseTitle.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),



                SizedBox(height: 25),

                Text(
                  'Summary:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF37474F),
                  ),
                ),
                Text(
                  courseSummary,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF607D8B),
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Platform',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF37474F),
                  ),
                ),
                Text(
                  
                  coursePlatform,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF607D8B),
                  ),
                ),

                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent.withOpacity(0.7),
                            shape: const RoundedRectangleBorder(),
                            textStyle: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            if (await canLaunch(courseURL)) {
                              await launch(courseURL);
                            } else {
                              print('Could not launch $courseURL');
                            }
                          },
                          child: Text('Enroll Course'),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Obx(() {
                        return Visibility(
                          visible: !isSavingCourse.value,
                          child: Container(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                isSavingCourse.value = true;
                                if (isSavedCourse) {
                                  // Delete the course from the dashboard (not Firebase)
                                  Get.back();
                                  await firebaseAuthController.deleteCourse(courseTitle);

                                } else {
                                  // Save the course logic here
                                  await firebaseAuthController.saveCourse(
                                    courseTitle,
                                    courseSummary,
                                    courseDuration,
                                    courseURL,
                                    coursePlatform
                                  );
                                }
                                isSavingCourse.value = false;
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red.withOpacity(0.7), // Set the same red color for both buttons
                                shape: const RoundedRectangleBorder(),
                                textStyle: TextStyle(color: Colors.white),
                              ),

                              child: Text(isSavedCourse ? 'Delete Course' : 'Save Course'),
                            ),
                          ),
                        );
                      }),
                    ),


                  ],
                ),
              ],
            ),
          ),
          ],
        ),
      );
    } else {

      return Stack(
        children: [
          Image.asset(
            'assets/images/edit_profile_background.webp',// Replace with the path to your background image
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
         Scaffold(
          appBar: AppBar(
            title: Text('Course Details'),
          ),
          body: Center(
            child: Text('Course details are missing.'),
          ),
        ),
        ],
      );
    }
  }
}

