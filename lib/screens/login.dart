import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/firebase_auth_controller.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FirebaseAuthController>();
    final size = MediaQuery.of(context).size;
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          onPressed: () {},
                          child: const Text("Forgot Password?"),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.signInWithEmailPassword(context);
                          },
                          child: Text("Login".toUpperCase()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.7),
                            shape: const RoundedRectangleBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 06),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed('/signup');
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
