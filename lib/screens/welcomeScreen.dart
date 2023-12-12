
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../controllers/firebase_auth_controller.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FirebaseAuthController>();
    return Scaffold(
      backgroundColor:const Color(0xffFBF3EF),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Upper Container with Images
          ClipPath(
            clipper: UpperContainerClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              color:Colors.blueAccent.withOpacity(0.4), // Set the color you desire
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage("assets/images/welcomelogo.png")),
                    const Text(
                      "Find the Best Suitable Course for you, Find courses on a single search",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Lower Container with Buttons
          Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Image(image: AssetImage("assets/images/welcome_screen_image.png"), height: 300, width: 300),
                SizedBox(height: 30,),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/signup');
                    },
                    child: Text("SignUp".toUpperCase()),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0), // Adjust the radius as needed
                      ),
                      backgroundColor: Colors.red.withOpacity(0.7),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    child: Text("Login with Email".toUpperCase()),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0), // Adjust the radius as needed
                      ),
                      backgroundColor: Colors.red.withOpacity(0.7),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton.icon(
                    icon: const Image(
                      image: AssetImage('assets/images/google_icon.png'),
                      width: 24,
                    ),
                    label: const Text(
                      "Continue with Google",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () async => await controller.authenticateWithGoogle(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0), // Adjust the radius as needed
                      ),
                      side: BorderSide(width: 0.4, color: Colors.black),
                    ),
                  ),
                ),

                // ... other widgets ...
              ],
            ),
          ),
        ],
      ),
    );







  }

}
class UpperContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50); // start from bottom-left
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50); // upper curve
    path.lineTo(size.width, 0); // end at top-right
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
