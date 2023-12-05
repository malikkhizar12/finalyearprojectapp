
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../controllers/firebase_auth_controller.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FirebaseAuthController>();
    return Scaffold(
      backgroundColor: const Color(0xffFBF3EF),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("assets/images/welcomelogo.png")),
           /* Text(
              "Course Guide",
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),*/
            const SizedBox(height: 0.0),
            const Text(
              "Find the Best Suitable Course for you, Find courses on a single search",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 99.0),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton.icon(
                icon: const Image(image: AssetImage('assets/images/google_icon.png'), width: 24,),
                label: const Text("Continue with Google",
                  style: TextStyle(
                      color: Colors.black,
                    fontSize: 15
                  ),) ,
                onPressed: () async => await controller.authenticateWithGoogle(context),
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                    side: const BorderSide(width: 0.4,color: Colors.black)
                ),
              ),
            ),
            const SizedBox(height: 15,),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton.icon(
                icon: const Image(image: AssetImage('assets/images/facebook_icon.png'), width: 30,),
                label: const Text("Continue with Facebook",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15
                  ),) ,
                onPressed: (){},
                style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    side: const BorderSide(width: 0.4,color: Colors.black)
                ),
              ),
            ),


            const SizedBox(height: 20),
                    const Text("OR"),
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

                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.red.withOpacity(0.7),
                        foregroundColor: Colors.white,

                      ),

                  ),
                   ),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.offAllNamed('/signup');
                },
                child: Text(
                  "dont't have an account? Sign up",
                  style: TextStyle(
                    color: Colors.redAccent.withOpacity(0.6),
                  ),
                ),
              ),
            ),
                const SizedBox(height: 60,),
                const Text("By creating an account, You accept CourseGuide's",
                style: TextStyle(fontSize: 12),),

               Center(
                 child: TextButton(onPressed:(){

                  },
                      child: Text("Terms of Services and Policies",
                 style: TextStyle(
                   fontWeight: FontWeight.bold,
                     color: Colors.black.withOpacity(0.6),
                     height: -0.5,
                 )
                      ),
                 ),
               )
              ],


        ),
      ),





    );

  }
}
