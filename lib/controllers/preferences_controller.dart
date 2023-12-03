import 'package:cloud_firestore/cloud_firestore.dart';

class PreferencesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePreferences(String selectedCategory, String selectedLevel) async {
    try {
      // Save preferences to Firestore
      await _firestore.collection('preferences').doc().set({
        'category': selectedCategory,
        'level': selectedLevel,
      });
    } catch (e) {
      print('Failed to save preferences: $e');
      throw e;
    }
  }
}