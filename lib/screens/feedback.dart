import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/firebase_auth_controller.dart';

class FeedbackPage extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();

  FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FirebaseAuthController>();
    return Scaffold(
      backgroundColor:const Color(0xffFBF3EF),
      extendBodyBehindAppBar: true,
      appBar: null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 60),
              Container(
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage("assets/images/welcomelogo.png"),
                ),
              ),
              SizedBox(height: 10,),


              const SizedBox(height: 20),
              FeedbackTextField(
                controller: feedbackController,
                label: 'Write Feedback',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red.withOpacity(0.7),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  final feedbackText = feedbackController.text;

                  if (feedbackText.isNotEmpty) {
                    controller.storeFeedback(feedbackText);
                  } else {
                    showEmptyFeedbackPopup(context);
                  }
                },
                child: const Text('Submit Feedback', style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold)),
              ),

            ],
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
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        title: Text(
          'Empty Feedback',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Please provide your feedback.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
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
                color: Colors.white,
                fontSize: 18.0,
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
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.only(top: 20, bottom: 20, left: 10),
          isDense: true,
          alignLabelWithHint: true,
        ),
        maxLines: 15,
      ),
    );
  }
}
