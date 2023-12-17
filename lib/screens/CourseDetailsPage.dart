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
      print('NEXT PAGE GETTING ARGUMENTS');
      print(arguments);
      Map<String, dynamic> course = Map<String, dynamic>.from(arguments['course']);
      print(course);
      bool isSavedCourse = arguments['isSavedCourse'] ?? false;
      final courseTitle = course['courseName'];
      final courseSummary = course['courseDescription'];
      final courseUrl = course['courseUrl'];
      final coursePlatform = course['coursePlatform'];
      final courseLevel = course['courseLevel'];
      final courseRating = course['courseRating'];
      final courseInstructor = course['courseInstructor'];
      final firebaseAuthController = Get.put(FirebaseAuthController());
      RxBool isSavingCourse = false.obs;
      return Scaffold(
        appBar: null,
        body: Stack(
          children: [
            Image.asset(
              'assets/images/edit_profile_background.webp', // Replace with the path to your background image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      courseTitle.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Summary:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  Text(
                    courseSummary,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF607D8B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Platform',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  Text(
                    coursePlatform,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF607D8B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Instructor/University',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  Text(
                    courseInstructor,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF607D8B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Level',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  Text(
                    courseLevel,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF607D8B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ratings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  Text(
                    courseRating,
                    style: const TextStyle(
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
                              backgroundColor: Colors.black.withOpacity(0.6),
                              shape: const RoundedRectangleBorder(),
                            ),
                            onPressed: () async {
                              print('courseUrl : $courseUrl');
                              if (await canLaunchUrl(Uri.parse(courseUrl))) {
                                await launchUrl(Uri.parse(courseUrl));
                              } else {
                                print('Could not launch $courseUrl');
                              }
                            },
                            child: const Text(
                              'Enroll Course',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
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
                                    await firebaseAuthController
                                        .deleteCourse(courseTitle);
                                  } else {
                                    // Save the course logic here
                                    print('in course Details Page ');
                                    print(course.runtimeType);
                                    await firebaseAuthController.saveCourse(
                                      course : course
                                    );
                                  }
                                  isSavingCourse.value = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red.withOpacity(
                                      0.7), // Set the same red color for both buttons
                                  shape: const RoundedRectangleBorder(),
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                child: Text(
                                  isSavedCourse
                                      ? 'Delete Course'
                                      : 'Save Course',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
            'assets/images/edit_profile_background.webp', // Replace with the path to your background image
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Scaffold(
            appBar: AppBar(
              title: const Text('Course Details'),
            ),
            body: const Center(
              child: Text('Course details are missing.'),
            ),
          ),
        ],
      );
    }
  }
}
