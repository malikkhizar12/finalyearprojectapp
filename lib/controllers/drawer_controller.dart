import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_guide/core/collections.dart';
import 'package:course_guide/core/functions.dart';
import 'package:course_guide/core/widgets/customProgressIndicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomDrawerController extends GetxController {
  RxBool isDrawerOpen = false.obs;

  void toggleDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
      scaffoldKey.currentState?.openDrawer();
    isDrawerOpen.value = !isDrawerOpen.value;
  }
  Future<void> pickAndUploadImage(BuildContext context) async {
    String userId = firebaseUserId();

    final picker = ImagePicker();
    final pickedImage = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Choose an image"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await picker.pickImage(source: ImageSource.gallery));
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await picker.pickImage(source: ImageSource.camera));
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (pickedImage != null) {
      startLoading();
      final storageReference =
      FirebaseStorage.instance.ref().child('images/$userId.jpg');
      final file = File(pickedImage.path);
      final uploadTask = storageReference.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Store the image URL in the user's collection
      final userReference =
      FirebaseFirestore.instance.collection('users').doc(userId);
      await userReference.update({'photoUrl': imageUrl});
      Get.back();
      showToast('Success', 'Image Uploaded');
    }
  }

}