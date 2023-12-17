import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/firebase_auth_controller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controller = Get.find<FirebaseAuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<String> recommendedCourseTitles = [];
    List<String> recommendedCourseSummary = [];
    List<String> recommendedCourseCost = [];
    List<String> recommendedCourseDuration = [];
    List<String> recommendedCourseURL = [];
    List<String> recommendedCoursePlatform = [];
    List<Map<String, dynamic>> suggestedCourses = [];

    Future<void> sendSearchWordsToBackend(List<String> searchWords) async {
      final apiUrl = 'http://192.168.139.159:5050/suggestions';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'search_words': searchWords}),
        );

        if (response.statusCode == 200) {
          List<Map<String, dynamic>> courses = List<Map<String, dynamic>>.from(
            json.decode(response.body).map((x) => Map<String, dynamic>.from(x)),
          );

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

        } else {
          print('API Error: ${response.statusCode}, ${response.body}');
        }
      } catch (e) {
        print('Error sending search words: $e');
      }
    }

    return SafeArea(
      child: Scaffold(
        body:


               SingleChildScrollView(
                 child: Container(
                   height: MediaQuery.of(context).size.height,
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
                                onPressed: () {
                                  Get.toNamed('/ForgotPassword');
                                },
                                child: const Text("Forgot Password?"),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
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
                                  text: const TextSpan(
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
        prefixIcon: const Icon(Icons.fingerprint_rounded),
        labelText: "Password",
        hintText: "Enter Password",
        border: const OutlineInputBorder(),
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
