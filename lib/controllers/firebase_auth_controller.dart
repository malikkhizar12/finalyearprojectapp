import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../core/collections.dart';
import '../core/exceptions.dart';
import '../core/functions.dart';
import '../core/widgets/customProgressIndicator.dart';

class FirebaseAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxString selectedEducationStatus = RxString('');
  String checkAuth() {
    return _auth.currentUser == null ? "" : _auth.currentUser!.uid;
  }

  final signupFormKey = GlobalKey<FormState>();
  final signInWithEmailFormKey = GlobalKey<FormState>();
  final _savedCoursesController = StreamController<List<Map<String, dynamic>>>.broadcast();
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController(),
      phoneController = TextEditingController(),
      EducationStatusController = TextEditingController(),


      repeatPasswordController = TextEditingController();

  final TextEditingController loginEmailController = TextEditingController(),
      loginPasswordController = TextEditingController();

  Rx<bool> hidePassword = true.obs;
  Rx<bool> hideRepeatPassword = true.obs;
  final box = GetStorage();


  saveEmailPassword({required bool rememberMe}) {
    if (rememberMe) {
      box.write('email', emailController.text);
      box.write('password', passwordController.text);
    }
  }
  void setSelectedEducationStatus(String? newValue) {
    selectedEducationStatus.value = newValue ?? '';
  }

  Future<void> authenticateAnonymously(BuildContext context) async {
    startLoading();
    await signInAnonymously().then((User? user) async {
      if (user != null) {
        await box.write('anonymousUid', user.uid);
        await performSignUpTask(user);
      } else {
        Navigator.pop(context);
      }
    });
  }
  Future<void> storeFeedback(String feedbackText1, String feedbackText2, String feedbackText3) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        showToast('Error', 'You need to be logged in to submit feedback', err: true);
        return;
      }

      // Create a reference to the feedback collection
      final feedbackCollection = _firestore.collection('feedback');

      // Create a new document with a unique ID (Firestore will generate one)
      final newFeedbackDocument = feedbackCollection.doc();

      // Create a data map with the feedback and other relevant information
      final feedbackData = {
        'userId': user.uid,
        'feedbackText1': feedbackText1,
        'feedbackText2': feedbackText2,
        'feedbackText3': feedbackText3,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Set the data for the new feedback document
      await newFeedbackDocument.set(feedbackData);

      showToast('Success', 'Feedback submitted successfully');
    } catch (e) {
      print('Error storing feedback: $e');
      showToast('Error', 'Failed to submit feedback', err: true);
    }
  }


  Future<List<String>> getSavedCourses() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        return [];
      }

      final snapshot = await _firestore
          .collection('savedCourses')
          .where('userId', isEqualTo: user.uid)
          .get();

      final savedCourses = snapshot.docs.map((doc) => doc['courseURL'] as String).toList();
      return savedCourses;
    } catch (e) {
      print('Error fetching saved courses: $e');
      return [];
    }
  }
  Future<void> saveCourse(String courseTitle, String courseSummary,String coursePlatform, String courseDuration, String courseURL) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        print('User not logged in');
        showToast('Error', 'You need to be logged in to save a course', err: true);
        return;
      }

      // Check if the course URL already exists in the saved courses list
      final savedCourses = await getSavedCourses();
      if (savedCourses.contains(courseURL)) {
        // Course already saved
        showToast('Info', 'Course already saved');
        return;
      }

      // Save the course to Firestore
      await _firestore.collection('savedCourses').add({
        'userId': user.uid,
        'courseTitle': courseTitle,
        'courseSummary': courseSummary,
        'coursePlatform': coursePlatform,
        'courseDuration': courseDuration,
        'courseURL': courseURL,
        'timestamp': FieldValue.serverTimestamp(),
      });


      showToast('Success', 'Course saved successfully');
    } catch (e) {
      print('Error saving course: $e');
      showToast('Error', 'Failed to save course', err: true);
    }
  }
  Future<void> deleteCourse(String courseTitle) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        print('User not logged in');
        showToast('Error', 'You need to be logged in to delete a course', err: true);
        return;
      }

      // Find the document reference for the course to delete
      final querySnapshot = await _firestore
          .collection('savedCourses')
          .where('userId', isEqualTo: user.uid)
          .where('courseTitle', isEqualTo: courseTitle)
          .get();

      final docToDelete = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null;

      if (docToDelete != null) {
        // Update the document to mark the course as deleted
        await docToDelete.reference.update({'isDeleted': true});
        print('Course marked as deleted in Firestore');
        showToast('Success', 'Course removed from your dashboard');
      } else {
        // Course not found
        showToast('Error', 'Course not found', err: true);
      }
    } catch (e) {
      print('Error deleting course: $e');
      showToast('Error', 'Failed to delete course', err: true);
    }
  }


  Stream<List<Map<String, dynamic>>> savedCoursesStream() {
    _updateSavedCourses(); // Fetch and update saved courses when the stream is requested
    return _savedCoursesController.stream;
  }

  void _updateSavedCourses() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        _savedCoursesController.add([]); // No user, emit empty list
        return;
      }

      final snapshot = await _firestore
          .collection('savedCourses')
          .where('userId', isEqualTo: user.uid)
          .get();

      final savedCourses = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      _savedCoursesController.add(savedCourses);
    } catch (e) {
      print('Error fetching saved courses: $e');
      _savedCoursesController.addError(e);
    }
  }
  // Future<List<Map<String, dynamic>>> showSavedCourses() async {
  //   try {
  //     final user = _auth.currentUser;
  //
  //     if (user == null) {
  //       return [];
  //     }
  //
  //     final snapshot = await _firestore
  //         .collection('savedCourses')
  //         .where('userId', isEqualTo: user.uid)
  //         .get();
  //
  //     final savedCourses = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  //
  //     return savedCourses;
  //   } catch (e) {
  //     print('Error fetching saved courses: $e');
  //     return [];
  //   }
  // }
  Future<void> saveSearchWord(String searchWord) async {
    // Reference to the Firestore collection where you want to store search words
    CollectionReference searchWordsCollection = FirebaseFirestore.instance.collection('searchWords');

    // Add the search word to Firestore
    await searchWordsCollection.add({
      'word': searchWord,
      'timestamp': FieldValue.serverTimestamp(), // Optional: Add a timestamp for sorting or tracking when the search occurred
    });
    print("search words saved");
  }
  Future<List<String>> fetchSavedSearchWords() async {
    try {
      // Reference to the Firestore collection where search words are stored
      CollectionReference searchWordsCollection = FirebaseFirestore.instance.collection('searchWords');

      // Fetch all documents from the collection
      QuerySnapshot<Object?> snapshot = await searchWordsCollection.get();

      // Extract search words from the documents
      List<String> searchWords = snapshot.docs.map((doc) => doc['word'] as String).toList();

      // Optionally, you can print the search words
      print("Saved Search Words: $searchWords");

      return searchWords;
    } catch (e) {
      print('Error fetching saved search words: $e');
      return [];
    }
  }
  Future<void> signupWithEmailPassword(BuildContext context) async {
    if (!signupFormKey.currentState!.validate()) {
      return;
    }
    startLoading();
    await signUpWithEmailAndPassword(
            emailController.text, passwordController.text)
        .then((User? user) async {
      if (user != null) {
        await performSignUpTask(user);
      } else {
        Navigator.pop(context);
      }
    });
  }

  Future<void> signInWithEmailPassword(BuildContext context) async {
    if (!signInWithEmailFormKey.currentState!.validate()) {
      return;
    }
    startLoading();
    await signInWithEmailAndPassword(
            loginEmailController.text, loginPasswordController.text)
        .then((User? user) async {
      print(user);
      if (user != null) {
        await performSignUpTask(user);
      } else {
        Navigator.pop(context);
      }
    });
  }

  Future<void> authenticateWithGoogle(BuildContext context) async {
    startLoading();
    await signInWithGoogle()
        .then((User? user) async {
      print(user);
      if (user != null) {
        await performSignUpTask(user);
      } else {
        Navigator.pop(context);
      }
    });
  }

  Future<void> authenticateWithFacebook(BuildContext context) async {
    startLoading();
    await signInWithFacebook().then((User? user) async {
      if (user != null) {
        await performSignUpTask(user);
      } else {
        Navigator.pop(context);
      }
    });
  }

  Future<void> resetPassword(String email) async {
    startLoading();
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    // Sign out the current user based on their authentication provider
    var cUser = _auth.currentUser!;
    if (_auth.currentUser != null) {
      if (_auth.currentUser!.isAnonymous) {
        // Anonymous user
        await _auth.currentUser!.delete();
      } else if (cUser.providerData
          .any((userInfo) => userInfo.providerId == 'facebook.com')) {
        // Facebook user
        await FacebookAuth.instance.logOut();
        await _auth.signOut();
      } else if (cUser.providerData
          .any((userInfo) => userInfo.providerId == 'google.com')) {
        // Google user
        await _googleSignIn.signOut();
        await _auth.signOut();
      } else if (cUser.providerData
          .any((userInfo) => userInfo.providerId == 'apple.com')) {
        // Apple user
        await _auth.signOut();
      } else if (cUser.providerData
          .any((userInfo) => userInfo.providerId == 'password')) {
        // Email and password user
        await _auth.signOut();
      }
    }
  }

  Future<void> performSignUpTask(User user) async {
    String uid = user.uid;
    String photoUrl = user.photoURL ?? "";
    try {
      DocumentSnapshot<Object?> data = await usersCollection.doc(uid).get();
      var profilePhoto = await profilePhotoCollection.doc('profilePhoto').get();
      photoUrl = photoUrl.isEmpty ? profilePhoto['photoUrl'] : photoUrl;
      print('photoUrl : $photoUrl');
      if (!data.exists) {
        await usersCollection.doc(uid).set({
          'uid': uid,
          'email': user.email ?? '',
          'phone': phoneController.text ?? '',
          'educationStatus': selectedEducationStatus.value, // Use selectedEducationStatus directly
          'createdAt': FieldValue.serverTimestamp(),
          'displayName': user.displayName == '' || user.displayName == null ? nameController.text : user.displayName,
          'photoUrl': photoUrl,
        }).then((value) {
          clearController();
          print('New User');
          showToast('Welcome', 'Your account has been created');
          Get.offAndToNamed('/preferences');
        });
      } else {
        clearController();
        showToast('Welcome', 'Logged in Successfully');

        // Check if the user has preferences
        bool hasPreferences = await checkUserPreferences(uid);

        // Navigate to the appropriate page based on whether the user is new or has preferences
        if (!hasPreferences) {
          Get.offAndToNamed('/dashBoard');
        } else {
          Get.offAndToNamed('/preferences');
        }
      }
    } on FirebaseException catch (e) {
      String errorMessage = handleExceptionError(e);
      // Handle the error as needed, for example:
      showToast('Error', errorMessage, err: true);
    } on PlatformException catch (e) {
      String errorMessage = handleExceptionError(e);
      // Handle the error as needed, for example:
      showToast('Error', errorMessage, err: true);
    } catch (e) {
      print(e);
      // Handle other errors as needed
      showToast('Error', 'Something went wrong', err: true);
    }
  }

  Future<bool> checkUserPreferences(String uid) async {
    try {
      DocumentSnapshot<Object?> preferencesData =
      await _firestore.collection('preferences').doc(uid).get();
      return preferencesData.exists;
    } catch (e) {
      print('Failed to check user preferences: $e');
      throw e;
    }
  }




  Future<bool> updateEmail() async {
    final user = _auth.currentUser!;
    if (user.providerData
        .any((userInfo) => userInfo.providerId == 'password')) {
      // Email and password user
      final authCredential = EmailAuthProvider.credential(
          email: user!.email!,
          password: passwordController.text.trim());
      try{
        await user.reauthenticateWithCredential(authCredential);
      } catch(e){
        print('Incorrect Password: $e');
        showToast('Incorrect Password', '');
        return false;
      }
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      try {
        // update the email in Firebase Auth
        await user.updateEmail(emailController.text.trim());

        // update the email in Firestore
        await userRef.update({'email': emailController.text.trim()});
        showToast('Success', 'Email Changed Successfully');
        return true;
      } catch (e) {
        print('Error updating email: $e');
        showToast('Error Occurred', '');
        return false;
      }
    } else {
      showToast(
          'Email Cannot be changed', 'Login with your email and password');
      return false;
    }
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser!;
    final email = user.email;
    final password = loginPasswordController.text;
    try {
      if (_auth.currentUser!.isAnonymous) {
        print('Anonymous user');
        // Anonymous user
        await usersCollection.doc(user.uid).delete();
        // Delete the user's account
        await user.delete();
        print('User email');

        // Sign out the user
        await _auth.signOut();
      } else if (user.providerData
          .any((userInfo) => userInfo.providerId == 'password')) {
        // Email and password user
        final authCredential =
            EmailAuthProvider.credential(email: email!, password: password);
        await user.reauthenticateWithCredential(authCredential);
      } else if (user.providerData
          .any((userInfo) => userInfo.providerId == 'google.com')) {
        // Google user
        final googleSignInAccount = await _googleSignIn.signIn();
        final googleSignInAuthentication =
            await googleSignInAccount!.authentication;
        final authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await user.reauthenticateWithCredential(authCredential);
      } else if (user.providerData
          .any((userInfo) => userInfo.providerId == 'facebook.com')) {
        // Facebook user
        await FacebookAuth.instance.login(permissions: ['email']);
        final accessToken = await FacebookAuth.instance.accessToken;
        final authCredential =
            FacebookAuthProvider.credential(accessToken!.token);
        await user.reauthenticateWithCredential(authCredential);
      }
      await usersCollection.doc(user.uid).delete();
      print('User deleted COLLECTYION');

      // Delete the user's account
      await user.delete();
      print('User email');


      // Sign out the user
      await _auth.signOut();
      print('User deleted signout');
    } on PlatformException catch (e) {
      print('Error : e');
      throw FirebaseAuthException(
        code: e.code ?? 'Unknown',
        message: e.message ?? 'Unknown',
      );
    }
  }


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.onClose();
  }

  void clearController() {
    emailController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
    loginEmailController.clear();
    loginPasswordController.clear();
  }

  //sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      String errorMessage = handleExceptionError(e);
      showToast('Error', errorMessage);
      return null;
    }
  }

  //sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      String errorMessage = handleExceptionError(e);
      showToast('Error', errorMessage);
      return null;
    }
  }

  //sign up with email and password
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      String errorMessage = handleExceptionError(e);
      showToast('Error', errorMessage);
      return null;
    }
  }

  Future<User?>signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      final User firebaseUser = userCredential.user!;
      return firebaseUser;

    } catch (e) {
      String errorMessage = handleExceptionError(e);
      print('Error: $errorMessage');
      showToast('Error', errorMessage);
      return null;
    }
  }


  // //sign in with Facebook
  Future<User?> signInWithFacebook() async {
    try {
      // await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User firebaseUser = userCredential.user!;
        return firebaseUser;
      } else {
        showToast('Error', 'Error logging in with Facebook');
        throw Exception("Error logging in with Facebook: ${result.message}");
      }
    } catch (e) {
      String errorMessage = handleExceptionError(e);
      showToast('Error', errorMessage);
      return null;
    }
  }
}
