import 'package:course_guide/core/collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
      GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
      TextEditingController nameController = TextEditingController();
      TextEditingController emailController = TextEditingController();
      TextEditingController phoneNumberController = TextEditingController();
      TextEditingController educationStatusController = TextEditingController();

  Future<void> updateUserProfile(String newName, String newEmail,
      String newPhoneNumber, String newEducationStatus) async {
    try {
      String userId = firebaseUserId();
      await usersCollection.doc(userId).update({
        'displayName': newName,
        'email':newEmail,
        'phone': newPhoneNumber,
        'educationStatus': newEducationStatus,
      });
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }
  Future<void> fetchData() async {
    print(firebaseUserId());
    print('HI');
        var data = await usersCollection.doc(firebaseUserId()).get();
        String name = data['displayName'];
        nameController.text = name;
    String email = data['email'];
    emailController.text = email;
        String phoneNumber = data['phone'];
        phoneNumberController.text = phoneNumber;
        String educationStatus= data['educationStatus'];
        educationStatusController.text= educationStatus;


        update();
  }
  @override
  void onInit() {
    // TODO: implement onInit
        fetchData();

    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
        nameController.dispose();
    super.dispose();
  }
}
