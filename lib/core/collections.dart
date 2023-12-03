import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

CollectionReference usersCollection =
    FirebaseFirestore.instance.collection("users");
CollectionReference profilePhotoCollection =
FirebaseFirestore.instance.collection("profilePhoto");
String firebaseUserId() => FirebaseAuth.instance.currentUser?.uid ?? '';
