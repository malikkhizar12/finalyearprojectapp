import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_guide/controllers/setting_drawer_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/firebase_auth_controller.dart';
import '../controllers/preferences_controller.dart';
import 'package:http/http.dart' as http;

import '../core/collections.dart';
import '../screens/login.dart';

final List<String> durationOptions = [
  'Less than 1 week',
  'Less than 1 month',
  'Less than 3 months',
  'Less than 4 months',
  'Less than 6 months',
];
String selectedDuration = 'Less than 6 months';
final List<String> courseLevels = ['Easy', 'Intermediate', 'Hard'];
final List<String> costOptions = ['Free', 'Nanodegree'];
bool isFetchingRecommendations = false;
final TextEditingController levelController =
    TextEditingController(text: 'Easy');
final TextEditingController costController =
    TextEditingController(text: 'Free');
final TextEditingController customFieldController = TextEditingController();
final PreferencesController preferencesController = PreferencesController();
final CustomDrawerController drawerController =
    Get.put(CustomDrawerController());
final SettingDrawerController settingDrawerController =
    Get.put(SettingDrawerController());
final FirebaseAuthController firebaseAuthController =
    Get.put(FirebaseAuthController());
FirebaseAuthController authController = FirebaseAuthController();
final controller = Get.find<FirebaseAuthController>();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
int numberOfCoursesToShow = 2;
bool showAllCourses = false;
List<String> recommendedCourseTitles = [];
List<String> recommendedCourseSummary = [];
List<String> recommendedCourseLevel = [];
List<String> recommendedCourseInstructor = [];
List<String> recommendedCourseURL = [];
List<String> recommendedCoursePlatform = [];
List<String> recommendedCourseRating= [];


String limitTitle(String text, int maxWords) {
  List<String> words = text.split(' ');
  if (words.length <= maxWords) {
    return text;
  }
  return words.take(maxWords).join(' ') +
      (words.length > maxWords ? ' ...' : '');
}

enum PageState {
  State1,
  State2,
  State3,
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Initial state
  PageState _currentPageState = PageState.State2;
  void fetchRecommendedCourses() async {

    setState(() {
      isFetchingRecommendations = true;
    });

    void showNoCoursesDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Courses Found'),
            content: Text(
                'Sorry, no courses were found related to your search criteria.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }

    // const apiUrl = 'https://courseguide.cyclic.cloud/recommend';
    const apiUrl = 'http://192.168.139.159:5050/recommend';
    // const apiUrl = 'http://192.168.73.159:5000/recommend';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_input': customFieldController.text.toLowerCase(),
        'duration': selectedDuration.toLowerCase(),
        'cost': costController.text.toLowerCase(),
        'level': levelController.text.toLowerCase(),
      }),
    );
    // print('Response status code: ${response.statusCode}');
    // print('Response body: ${response.body}');

    setState(() {
      isFetchingRecommendations = false;
    });

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> courses =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      if (courses.isEmpty) {
        // Show the "No courses found" dialog here
        showNoCoursesDialog(context);
      } else {
        setState(() {
          recommendedCourseTitles = courses
              .map((course) => course['Course Name'].toString())
              .toList();
          recommendedCourseSummary = courses
              .map((course) => course['Description'].toString())
              .toList();

          recommendedCourseURL =
              courses.map((course) => course['Course Link'].toString()).toList();
          recommendedCoursePlatform =
              courses.map((course) => course['Platform'].toString()).toList();
          recommendedCourseInstructor =
              courses.map((course) => course['Instructor/Institution'].toString()).toList();
          recommendedCourseLevel =
              courses.map((course) => course['Level'].toString()).toList();
          recommendedCourseRating =
              courses.map((course) => course['Rating'].toString()).toList();
        });
        // print("summary");
        // print(recommendedCourseSummary);
        // print("Title");
        // print(recommendedCourseTitles);
        // print("links");
        // print(recommendedCourseURL);
        // print("level");
        // print(recommendedCourseLevel);
        // print("Ratings");
        // print(recommendedCourseRating);
        // print("Instructor");
        // print(recommendedCourseInstructor);


      }
    } else {
      // Handle API errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6FB1FF),
              Color(0xFFFF9AA2)
            ], // Blue to Red gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentPageState.index,
          onTap: (index) {
            // Update the state based on the selected bottom navigation bar item
            setState(() {
              _currentPageState = PageState.values[index];
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.screen_search_desktop_outlined,
                color: _getIconColor(PageState.State1),
              ),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard_outlined,
                color: _getIconColor(PageState.State2),
              ),
              label: 'DashBoard',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color: _getIconColor(PageState.State3),
              ),
              label: 'Profile',
            ),
          ],
          backgroundColor: Colors.transparent, // Set to transparent
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildBody() {
    Color backgroundColor;
    switch (_currentPageState) {
      case PageState.State1:
        return Stack(children: [
          Image.asset(
            'assets/images/edit_profile_background.webp', // Replace with the path to your background image
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),
                  Text(
                    "Course Guide ".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 29,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    "search for Best Courses ".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedDuration,
                          items: durationOptions.map((duration) {
                            return DropdownMenuItem<String>(
                              value: duration,
                              child: Text(duration),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedDuration = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.access_time),
                            labelText: "Duration",
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
                            labelText: "Level",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: costController.text,
                          items: costOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            costController.text = newValue!;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.attach_money_rounded),
                            labelText: "Cost",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: customFieldController,
                          decoration: const InputDecoration(
                            labelText: 'Course Name',
                            hintText: 'Course Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: isFetchingRecommendations
                                ? null
                                : () async {
                                    // Save the search term before triggering the search
                                    String searchWord =
                                        customFieldController.text;

                                    // Call the function to save the search word
                                    await authController
                                        .saveSearchWord(searchWord);

                                    // Optionally, you can save the searchWord in a list for future reference
                                    // savedSearchWords.add(searchWord);

                                    // Trigger the search
                                    fetchRecommendedCourses();
                                  },
                            child: isFetchingRecommendations
                                ? CircularProgressIndicator()
                                : Text(
                                    'Search Courses'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors
                                            .white, // Change the text color to white
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            16 // Change the font weight to bold
                                        ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.7),
                              shape: const RoundedRectangleBorder(),
                            ),
                          ),
                        ),
                        if (recommendedCourseTitles.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                'Best Recommended Courses:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 15),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                ),
                                itemCount: recommendedCourseTitles.length,
                                itemBuilder: (context, index) {
                                  // Get the course title and split it by space
                                  final courseTitle =
                                      recommendedCourseTitles[index];
                                  final titleWords = courseTitle.split(' ');

                                  // Ensure there are at least three words in the title
                                  if (titleWords.length < 3) {
                                    return Container(); // Skip this item if there are not enough words
                                  }

                                  // Take the first word of the title
                                  final firstWord = titleWords[0];

                                  // Take the second word of the title
                                  final secondWord = titleWords[1];

                                  // Create the final displayed title with ellipses after the second word
                                  final displayedTitle =
                                      '$firstWord $secondWord...';

                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                        '/CourseDetailsPage',
                                        arguments: {
                                          'courseTitle':
                                              recommendedCourseTitles[index],
                                          'courseSummary':
                                              recommendedCourseSummary[index],

                                          'courseURL':
                                              recommendedCourseURL[index],
                                          'coursePlatform':
                                              recommendedCoursePlatform[index],
                                          'courseLevel':
                                          recommendedCourseLevel[index],
                                          'courseRating':
                                          recommendedCourseRating[index],
                                          'courseInstructor':
                                          recommendedCourseInstructor[index],
                                          'isSavedCourse': false,
                                        },

                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            displayedTitle,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color(0xFF37474F),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            recommendedCourseSummary[index],
                                            maxLines:
                                                2, // Adjust this value to limit the number of lines for summary
                                            overflow: TextOverflow
                                                .ellipsis, // Use ellipsis (...) for overflow
                                            style: const TextStyle(
                                              color: Color(0xFF607D8B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);

      case PageState.State2:
        return Stack(children: [
          Image.asset(
            'assets/images/edit_profile_background.webp',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(29),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "DashBoard",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        suffixIcon:
                            Icon(Icons.search_rounded, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Saved Courses",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('savedCourses')
                        .where('userId',
                            isEqualTo:
                                FirebaseAuth.instance.currentUser?.uid ?? '')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        // If there are no saved courses, display a message
                        return Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.lightBlueAccent.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Your saved courses will be shown here.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFF37474F),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Start exploring and saving courses now!",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFF607D8B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        final savedCourses = snapshot.data!.docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .toList();
                        print("courses length");
                        print(savedCourses.length);
                        print(showAllCourses);
                        return Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                              ),
                              itemCount: showAllCourses
                                  ? savedCourses.length
                                  : savedCourses.length == 1 ? 1 : 2,
                              itemBuilder: (context, index) {
                                final courseData = savedCourses[index];
                                // Use the null-aware and null coalescing operators to safely access properties
                                String courseTitle =
                                    courseData['Course Name']?.toString() ??
                                        "Course Name";
                                String courseSummary =
                                    courseData['Description']?.toString() ??
                                        "Description";
                                String courseURL =
                                    courseData['Course Link']?.toString() ??
                                        "Course Link";
                                String courseLevel =
                                    courseData['Level']?.toString() ??
                                        "Level";
                                String coursePlatform =
                                    courseData['Platform']?.toString() ??
                                        "Platform";
                                String courseInstructor =
                                    courseData['Instructor/Institution']?.toString() ??
                                        "Instructor/Institution";
                                String courseRating =
                                    courseData['Rating']?.toString() ??
                                        "Rating";

                                print(courseTitle);
                                return GestureDetector(
                                  onTap: () {
                                    print("title from saved");
                                    print(courseTitle);
                                    print("course from saved");
                                    print(courseURL);
                                    Get.toNamed(
                                      '/CourseDetailsPage',
                                      arguments: {
                                        'Course Name': courseTitle,
                                        'courseSummary': courseSummary,
                                        'courseLevel' : courseLevel,
                                        'courseURL': courseURL,
                                        'courseInstructor' : courseInstructor,
                                        'coursePlatform': coursePlatform,
                                        'courseRating': courseRating,

                                        'isSavedCourse': true,
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:

                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          limitTitle(courseTitle,
                                              8), // Limit to 2 words
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Color(0xFF37474F),
                                          ),
                                          maxLines: 4, // Set max lines for the title
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if(savedCourses.length > 2)Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (showAllCourses) {
                                        numberOfCoursesToShow = 2;
                                      }
                                      showAllCourses = !showAllCourses;
                                    });
                                  },
                                  child: Text(
                                    showAllCourses ? "Hide" : "See All",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Related Courses",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  // ElevatedButton(onPressed: (){print("SUGGESTED COURSES ,$recommendedCourses");},
                  //     child:Text("Print Courses")),

      GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // Display three tiles per row
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      ),
      itemCount: controller.recommendedCourses.value.length,
      itemBuilder: (context, index) {
      final courseData = controller.recommendedCourses.value[index];
      String courseTitle = courseData['Course Name']?.toString() ?? "Course Title";
      String courseURL = courseData['Course URL']?.toString() ?? "Course URL";
      String coursePlatform = courseData['University']?.toString() ?? "Course Platform";

      return GestureDetector(
      onTap: () {
      Get.toNamed(
      '/suggestedCourses',
      arguments: {
      'courseTitle': courseTitle,
      'courseURL': courseURL,
      'coursePlatform': coursePlatform,
      'isSavedCourse': false,
      },
      );
      },
      child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
      color: Colors.lightBlueAccent.withOpacity(0.3),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
      BoxShadow(
      color: Colors.grey.withOpacity(0.3),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
      ),
      ],
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(

      limitTitle(courseTitle, 3),
      //   courseTitle ?? 'Default Title',
      style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10, // Lowered font size
      color: Color(0xFF37474F),
      ),
      maxLines: 2,  // Limit to 2 lines
      overflow: TextOverflow.ellipsis,
      ),
      ],
      ),
      ),
      );
      },
      ),


    ],
              ),
            ),
          ),
        ]);

      case PageState.State3:
        backgroundColor = Colors.orange;

        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;
        return Scaffold(
          body: Stack(
            children: [
              // First Row (30% of the page)
              Container(
                height: screenHeight * 0.28,
                child: Stack(
                  children: [
                    // Background Image
                    Image.asset(
                      'assets/images/profile_background.webp', // Replace with the actual path to your image asset
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Profile Text
                    Positioned(
                      top: 20, // Adjust the top position based on your design
                      width: screenWidth,
                      child: Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24, // Adjust the font size as needed
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Second Row (70% of the page)
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.28),
                height: screenHeight * 0.72,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the start
                      children: [
                        SizedBox(
                          height: 59,
                        ),
                        Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 29,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/editProfilePage');
                          },
                          child: Container(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons
                                      .edit), // Replace with your desired icon
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 29,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle click, navigate to feedback page
                            Get.toNamed('/FeedBackPage');
                          },
                          child: Container(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    'Feedback',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons
                                      .feedback), // Replace with your desired icon
                                  onPressed: () {
                                    // Handle icon click, e.g., open a feedback dialog

                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 29,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final email = 'malikkhizarhayyat78@gmail.com';
                            final subject = 'CourseGuide Customer Service';
                            final mailtoLink = Uri.parse('mailto:$email?subject=$subject');

                            if (await canLaunchUrl(mailtoLink)) {
                              await launchUrl(mailtoLink);
                            } else {
                              print('Could not launch email');
                            }
                          },
                          child: Container(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    'Contact Us',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.contact_support),
                                  onPressed: () {
                                    // Handle icon click, e.g., open a feedback dialog
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),



                        SizedBox(
                          height: 29,
                        )
                        ,
                        Container(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.9,
                          // Add your content for the new Container here
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent.withOpacity(
                                0.2), // Replace with your desired color
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          // Add child widgets for the new Container here
                        ),
                        SizedBox(
                          height: 29,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () async {
                              final controller = Get.find<FirebaseAuthController>();
                              await controller.signOut();
                              Get.offAllNamed('/');
                            },
                            child: Text(
                              "Logout".toUpperCase(),
                              style: TextStyle(
                                  color: Colors
                                      .white, // Change the text color to white
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16 // Change the font weight to bold
                                  ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 19,
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // New Container Overlapping Both Rows
              Stack(
                children: [
                  Positioned(
                    top: screenHeight *
                        0.2, // Adjust this value based on your design
                    left: screenWidth * 0.05,
                    child: Container(
                      height: screenHeight * 0.15,
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: StreamBuilder(
                        stream:
                            usersCollection.doc(firebaseUserId()).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Username',
                                      style: TextStyle(color: Colors.black)),
                                  Text('user@example.com',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            );
                          } else {
                            var data = snapshot.data!;
                            String photoUrl = data['photoUrl'];

                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      imageUrl: photoUrl,
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        15), // Add some space between the image and text
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (data['displayName'] ?? 'Username')
                                              .toUpperCase(), // Uppercase modification
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight
                                                .w700, // Bold modification
                                          ),
                                        ),
                                        Text(
                                          data['email'] ?? 'user@example.com',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.offNamed('/editProfilePage');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.redAccent.withOpacity(
                                            0.9), // Set your desired light color
                                      ),
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      default:
        backgroundColor = Colors.pink;
    }

    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          'Content for ${_currentPageState.toString()}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Color _getIconColor(PageState state) {
    return _currentPageState == state ? Colors.pink : Colors.black54;
  }
}
