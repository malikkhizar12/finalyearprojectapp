import 'dart:convert';import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../controllers/preferences_controller.dart';
import '../controllers/drawer_controller.dart';
import '../core/widgets/custom_drawer.dart';


class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
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
  final TextEditingController levelController = TextEditingController(text: 'Easy');
  final TextEditingController costController = TextEditingController(text: 'Free');
  final TextEditingController customFieldController = TextEditingController();

  final PreferencesController preferencesController = PreferencesController();
  final CustomDrawerController drawerController = Get.put(CustomDrawerController());

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> recommendedCourseTitles = [];
  List<String> recommendedCourseSummary = [];
  List<String> recommendedCourseCost = [];
  List<String> recommendedCourseDuration = [];
  List<String> recommendedcourseUrl = [];
  List<String> recommendedCoursePlatform = [];

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
            content: Text('Sorry, no courses were found related to your search criteria.'),
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
    // const apiUrl = 'http://127.0.0.1:5000/recommend';
    const apiUrl = 'http://192.168.139.159:5050/recommend';
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
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    setState(() {
      isFetchingRecommendations = false;
    });

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> courses = List<Map<String, dynamic>>.from(json.decode(response.body));

      if (courses.isEmpty) {
        // Show the "No courses found" dialog here
        showNoCoursesDialog(context);
      } else {
        setState(() {
          recommendedCourseTitles = courses.map((course) => course['Course Name'].toString()).toList();
          recommendedCourseSummary = courses.map((course) => course['Course Description'].toString()).toList();
          recommendedCourseCost = courses.map((course) => course['cost'].toString()).toList();
          recommendedCourseDuration = courses.map((course) => course['course_duration'].toString()).toList();
          recommendedcourseUrl = courses.map((course) => course['Course URL'].toString()).toList();
          recommendedCoursePlatform = courses.map((course) => course['University'].toString()).toList();
        });
      }
    } else {
      // Handle API errors here
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
              scale: 0.7,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    Get.toNamed('/settings');
                  },
                  iconSize: 40,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                "Preferences ".toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.attach_money_rounded),
                        labelText: "Cost",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: customFieldController,
                      decoration: InputDecoration(
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
                        onPressed: isFetchingRecommendations ? null : fetchRecommendedCourses,
                        child: isFetchingRecommendations
                            ? CircularProgressIndicator()
                            : Text('Search Courses'.toUpperCase()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.7),
                          shape: RoundedRectangleBorder(),
                        ),
                      ),
                    ),

                    if (recommendedCourseTitles.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Best Recommended Courses:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 15),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                            ),
                            itemCount: recommendedCourseTitles.length,
                            itemBuilder: (context, index) {
                              // Get the course title and split it by space
                              final courseTitle = recommendedCourseTitles[index];
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
                              final displayedTitle = '$firstWord $secondWord...';

                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    '/CourseDetailsPage',
                                    arguments: {
                                      'courseTitle': recommendedCourseTitles[index],
                                      'courseSummary': recommendedCourseSummary[index],
                                      'courseCost': recommendedCourseCost[index],
                                      'courseDuration': recommendedCourseDuration[index],
                                      'courseUrl': recommendedcourseUrl[index],
                                      'coursePlatform': recommendedCoursePlatform[index],
                                      'isSavedCourse': false,
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFFE0E6F8), Color(0xFFF0F0F0)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayedTitle,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color(0xFF37474F),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        recommendedCourseSummary[index],
                                        maxLines: 2, // Adjust this value to limit the number of lines for summary
                                        overflow: TextOverflow.ellipsis, // Use ellipsis (...) for overflow
                                        style: TextStyle(
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
    );
  }
}