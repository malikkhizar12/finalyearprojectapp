import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_guide/controllers/drawer_controller.dart';
import 'package:course_guide/controllers/edit_profile_controller.dart';
import 'package:course_guide/core/collections.dart';
import 'package:course_guide/core/colors.dart';
import 'package:course_guide/core/exceptions.dart';
import 'package:course_guide/core/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends GetView<EditProfileController> {
  EditProfile({Key? key}) : super(key: key);

  final CustomDrawerController drawerController = Get.put(CustomDrawerController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button behavior here
        Get.offNamed('/dashBoard');

        return false; // Return true to allow back button press, false to prevent it
      },
      child: Scaffold(
        key: controller.scaffoldKey,

        body:
        Stack(
          children: [
            Image.asset(
              'assets/images/edit_profile_background.webp',// Replace with the path to your background image
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
           SingleChildScrollView(

            child: Center(

              child: Column(
                children: [
                  Container(

                    margin: EdgeInsets.only(top: 40),
                    child: StreamBuilder(
                        stream: usersCollection.doc(firebaseUserId()).snapshots(),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData) return SizedBox();
                            var data = snapshot.data!;
                            String photoUrl = data['photoUrl'];
                            print(photoUrl);
                            return  Stack(

                                children: [

                                  ClipRRect(

                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      progressIndicatorBuilder: (v, c, b) => showLoader(),
                                      imageUrl : photoUrl,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) => Container(

                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: -5,
                                    child: IconButton(

                                      icon: const Icon(
                                        size:40,
                                        Icons.camera_alt,
                                        color: kSecondaryColor,

                                      ),
                                      onPressed: () async {
                                        await drawerController.pickAndUploadImage(context);
                                      },
                                    ),
                                  )

                                ],

                              );

                          }

                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Container(

                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey, // Set your desired border color here
                                width: 1.0, // Set the border width
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: controller.nameController,
                            decoration: InputDecoration(
                              labelText: "Name",
                              border: InputBorder.none, // Remove the default border of the TextFormField
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(

                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey, // Set your desired border color here
                                width: 1.0, // Set the border width
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: InputBorder.none, // Remove the default border of the TextFormField
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(

                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey, // Set your desired border color here
                                width: 1.0, // Set the border width
                              ),
                            ),
                          ),
                          child: TextFormField(
                            readOnly: true,
                            controller: controller.phoneNumberController,
                            decoration: InputDecoration(
                              labelText: "PhoneNumber",
                              border: InputBorder.none, // Remove the default border of the TextFormField
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(

                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey, // Set your desired border color here
                                width: 1.0, // Set the border width
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: controller.educationStatusController,
                            decoration: InputDecoration(
                              labelText: "Education Status",
                              border: InputBorder.none, // Remove the default border of the TextFormField
                            ),
                          ),
                        ),
                        SizedBox(height: 70,),
                        SizedBox(width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: ()  async {
                              String newName = controller.nameController.text;
                              String newEmail = controller.emailController.text;
                              String newPhoneNumber = controller.phoneNumberController.text;
                              String newEducationStatus = controller.educationStatusController.text;

                              try {
                                await controller.updateUserProfile(newName,newEmail,newPhoneNumber,newEducationStatus);
                                showToast("Success", "Profile updated successfully");
                              } catch (e) {
                                String errorMessage = handleExceptionError(e);
                                showToast('Error', errorMessage);
                              }

                            },
                            child: Text("Update".toUpperCase()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.7),
                              shape: const RoundedRectangleBorder(),
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
          ]
        ),

      ),
    );
  }
}

