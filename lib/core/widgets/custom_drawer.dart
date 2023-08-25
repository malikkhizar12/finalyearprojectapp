import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/drawer_controller.dart';
import '../../controllers/firebase_auth_controller.dart';
import '../collections.dart';
import '../colors.dart';
import '../exceptions.dart';
import '../functions.dart';
import 'customProgressIndicator.dart';

class CustomDrawer extends StatelessWidget {
  final CustomDrawerController drawerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          StreamBuilder(
            stream: usersCollection.doc(firebaseUserId()).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const UserAccountsDrawerHeader(
                  accountName: Text('Username'),
                  accountEmail: Text('user@example.com'),
                );
              } else {
                var data = snapshot.data!;
                String photoUrl = data['photoUrl'];
                print(photoUrl);
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.pink.shade200,
                            Colors.purple.shade200,
                          ],
                        ),
                      ),
                    ),
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      accountName: Text(
                        data['displayName'] ?? 'Username',
                        style: TextStyle(color: Colors.black),
                      ),
                      accountEmail: Text(
                        data['email'] ?? 'user@example.com',
                        style: TextStyle(color: Colors.black),
                      ),
                      currentAccountPicture: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          imageUrl: photoUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Dashboard"),
            onTap: () {
              Get.offNamed('/dashBoard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_attributes),
            title: const Text("Edit Profile"),
            onTap: () async {
              Get.offNamed('/editProfilePage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_attributes),
            title: const Text("Preferences"),
            onTap: () async {
              Get.offNamed('/preferences');
            },
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text("Feedback"),
            onTap: () {
              // Handle onTap action
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Logout"),
            onTap: () async {
              try {
                final firebaseController = Get.put(FirebaseAuthController());
                await firebaseController.signOut();
                showToast("Success", "Logged out successfully");
                Get.delete<FirebaseAuthController>();
                Get.offAllNamed('/');
              } catch (e) {
                String errorMessage = handleExceptionError(e);
                showToast('Error', errorMessage);
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }
}
