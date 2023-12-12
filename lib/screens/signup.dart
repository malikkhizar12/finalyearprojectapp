import 'package:course_guide/core/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/firebase_auth_controller.dart';
import '../core/functions.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FirebaseAuthController>();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFBF3EF),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/images/welcomelogo.png"),
                  width: size.width * 0.9,
                  height: size.height * 0.16,
                ),
                SizedBox(height: 0),
                Text(
                  " Create Your Account".toUpperCase(),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 17),
                Form(
                  key: controller.signupFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 56,
                        child: TextFormField(
                          controller: controller.nameController,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(height: 0.1, fontSize: 8),
                            errorMaxLines: 2,
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            labelText: "Name",
                            hintText: "Enter Your Full name",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              height: 3,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          validator: nameValidator,
                        ),
                      ),
                      SizedBox(height: 17),
                      Container(
                        height: 56,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: controller.emailController,
                          style: TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                            constraints: BoxConstraints(),
                            errorStyle: TextStyle(height: 0.1, fontSize: 8),
                            errorMaxLines: 2,
                            prefixIcon: Icon(Icons.mail_outline_outlined),
                            labelText: "Email",
                            hintText: "Enter Your Email",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              height: 3,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          validator: emailValidator,
                        ),
                      ),
                      SizedBox(height: 17),
                      Container(
                        height: 56,
                        child: TextFormField(
                          controller: controller.phoneController,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(height: 0.1, fontSize: 8),
                            errorMaxLines: 2,
                            prefixIcon: Icon(Icons.phone_android_outlined),
                            labelText: "Phone Num",
                            hintText: "Enter Your Phone Num",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              height: 3,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          validator: phoneValidator,
                        ),
                      ),
                      SizedBox(height: 17),
                      Container(
                        height: 56,
                        child: DropdownButtonFormField<String>(
                          onChanged: (String? newValue) {
                            controller.selectedEducationStatus.value = newValue ?? '';
                          },
                          value: controller.selectedEducationStatus.value.isEmpty ? null : controller.selectedEducationStatus.value,

                          validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an education status';
                          }
                          return null;
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'Intermediate',
                            child: Text('Intermediate'),
                          ),
                          DropdownMenuItem(
                            value: 'Secondary',
                            child: Text('Secondary'),
                          ),
                          DropdownMenuItem(
                            value: 'Undergraduate',
                            child: Text('Undergraduate'),
                          ),
                          DropdownMenuItem(
                            value: 'Graduated',
                            child: Text('Graduated'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Education Status',
                          prefixIcon: Icon(Icons.school_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),

                ),
                      SizedBox(height: 17),
                      Container(
                        height: 56,
                        child: TextFormField(
                          controller: controller.passwordController,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(height: 0.1, fontSize: 8),
                            errorMaxLines: 2,
                            prefixIcon: Icon(Icons.fingerprint_rounded),
                            labelText: "Password",
                            hintText: "Choose Password",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              height: 3,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          validator: passwordValidator,
                        ),
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.signupWithEmailPassword(context);
                          },
                          child: Text("Sign Up".toUpperCase(),
                              style: TextStyle(color: Colors.white,fontSize: 16,
                              fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.7),
                            shape: RoundedRectangleBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30, child: Text("OR")),
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
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Get.offAllNamed('/login');
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Already Have Account? ',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Login',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
