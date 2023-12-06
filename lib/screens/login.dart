import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/firebase_auth_controller.dart';
import 'Ratings.dart';




class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    List<String> recommendedCourseTitles = [];
    List<String> recommendedCourseSummary = [];
    List<String> recommendedCourseCost = [];
    List<String> recommendedCourseDuration = [];
    List<String> recommendedCourseURL = [];
    List<String> recommendedCoursePlatform = [];
    final controller = Get.find<FirebaseAuthController>();
    final RatingsPage ratingsPage = RatingsPage();

    final size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> suggestedCourses = [];
    Future<void> sendSearchWordsToBackend(List<String> searchWords) async {
      final apiUrl = 'http://192.168.18.85:5000/suggestions';
      // Replace with your actual API endpoint

      try {
        // Make a POST request to the API with search words in the request body
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'search_words': searchWords}),
        );

        if (response.statusCode == 200) {
          List<Map<String, dynamic>> courses = List<Map<String, dynamic>>.from(
            json.decode(response.body).map((x) => Map<String, dynamic>.from(x)),
          );

          // Save courses to the recommendedCourseTitles, recommendedCourseSummary, etc.
          setState(() {
            recommendedCourseTitles = courses
                .map((course) => course['Course Name'].toString())
                .toList();
            recommendedCourseSummary = courses
                .map((course) => course['Course Description'].toString())
                .toList();
            recommendedCourseDuration = courses
                .map((course) => course['course_duration'].toString())
                .toList();
            recommendedCourseURL =
                courses.map((course) => course['Course URL'].toString()).toList();
            recommendedCoursePlatform =
                courses.map((course) => course['University'].toString()).toList();
          });

          suggestedCourses = courses;

          print('API Response/list: $suggestedCourses');
        }
        else {
          // Handle API errors here
          print('API Error: ${response.statusCode}, ${response.body}');
        }
      } catch (e) {
        // Handle network or other errors here
        print('Error sending search words: $e');
      }
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFBF3EF),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Image(
                  image: const AssetImage("assets/images/welcomelogo.png"),
                  width: size.width * 0.9,
                  height: size.height * 0.16,
                ),
                const SizedBox(height: 10,),
                Text(
                  "Welcome Back ".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50,),
                Form(
                  key: controller.signInWithEmailFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: controller.loginEmailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_rounded),
                          labelText: "Email",
                          hintText: "Enter Your Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      PasswordTextField(
                        controller: controller.loginPasswordController,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {Get.toNamed('/ForgotPassword');},
                          child: const Text("Forgot Password?"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          List<String> searchWords = await controller.fetchSavedSearchWords();
                          await sendSearchWordsToBackend(searchWords);
                          // Perform sign-in
                          await controller.signInWithEmailPassword(context);

                        },
                        child: Text(
                          "Login".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.7),
                          shape: const RoundedRectangleBorder(),
                        ),
                      ),

                      const SizedBox(height: 06),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Get.offAllNamed('/signup');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't Have An Account? ",
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'SignUp',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordTextField({required this.controller});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.fingerprint_rounded),
        labelText: "Password",
        hintText: "Enter Password",
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
