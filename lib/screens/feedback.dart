import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/firebase_auth_controller.dart';

class FeedbackPage extends StatelessWidget {
  final TextEditingController feedbackController1 = TextEditingController();
  final TextEditingController feedbackController2 = TextEditingController();
  final TextEditingController feedbackController3 = TextEditingController();

  FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FirebaseAuthController>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: Center(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(


              children: [

                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Course Guide ".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 35,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                   const Text(
                    'Feedback',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 20),
                FeedbackTextField(
                  controller: feedbackController1,
                  label: '1. Is the app easier to use?',
                ),
                FeedbackTextField(
                  controller: feedbackController2,
                  label: '2. How helpful was our app in finding your required courses?',
                ),
                FeedbackTextField(
                  controller: feedbackController3,
                  label: '3. What improvements can be made in the app?',
                ),
                SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red.withOpacity(0.7),
                minimumSize: Size(double.infinity, 50), // Make the button wide
              ),
              onPressed: () {
                final feedbackText1 = feedbackController1.text;
                final feedbackText2 = feedbackController2.text;
                final feedbackText3 = feedbackController3.text;

                if (feedbackText1.isNotEmpty && feedbackText2.isNotEmpty && feedbackText3.isNotEmpty) {
                  controller.storeFeedback(feedbackText1, feedbackText2, feedbackText3);
                } else {
                  showEmptyFeedbackPopup(context);
                }
              },
              child: const Text('Submit Feedback', style: TextStyle(fontSize: 18)),
            ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Function to show a styled popup for empty feedback
void showEmptyFeedbackPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.redAccent.withOpacity(0.8), // Change the background color to your preferred color
        title: Text(
          'Empty Feedback',
          style: TextStyle(
            color: Colors.white, // Text color
            fontSize: 20.0, // Text size
            fontWeight: FontWeight.bold, // Text weight
          ),
        ),
        content: Text(
          'Please provide input for all feedback fields.',
          style: TextStyle(
            color: Colors.white, // Text color
            fontSize: 16.0, // Text size
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 18.0, // Text size
              ),
            ),
          ),
        ],
      );
    },
  );
}

class FeedbackTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  FeedbackTextField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Enter your feedback here',
          filled: true,
          fillColor: Colors.grey[200],
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          contentPadding: const EdgeInsets.all(10),
          isDense: true,
        ),
        maxLines: 3,
      ),
    );
  }
}
