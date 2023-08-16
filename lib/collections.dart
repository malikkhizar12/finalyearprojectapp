import 'package:cloud_firestore/cloud_firestore.dart';

class Collections {
  static CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
}

