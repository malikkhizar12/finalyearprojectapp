import 'package:course_guide/screens/preferences.dart';
import 'package:course_guide/screens/welcomeScreen.dart';
import 'package:get/get.dart';
import '../screens/CourseDetailsPage.dart';
import '../screens/ForgotPassword.dart';
import '../screens/Terms.dart';
import '../screens/dashBoard.dart';
import '../screens/edit_profile.dart';
import '../screens/feedback.dart';
import '../screens/login.dart';
import '../screens/signup.dart';
import '../screens/splashScreen.dart';
import 'binding.dart';

class Pages {
  static List<GetPage> all = [
    GetPage(name: "/", page: () => SplashScreen(), binding: SplashBinding()),
    GetPage(name: "/login", page: () => const Login(), fullscreenDialog: true),
    GetPage(name: "/welcomeScreen", page: () => const WelcomeScreen(), fullscreenDialog: true),
    GetPage(name: "/signup", page: () => SignupPage(), fullscreenDialog: true),
    GetPage(name: "/dashBoard", page: () =>  Dashboard(),fullscreenDialog: true),
    GetPage(name: '/editProfilePage', page: () => EditProfile(), binding: EditProfileBinding()),
    GetPage(name: '/preferences', page: () =>  PreferencesPage(), binding: PreferencesBinding()),
    GetPage(name: '/ForgotPassword', page: () =>  const ForgotPassword(),fullscreenDialog: true),
    GetPage(name: '/CourseDetailsPage', page: () =>  CourseDetailPage(),fullscreenDialog: true),
    GetPage(name: '/FeedBackPage', page: () =>  FeedbackPage(),fullscreenDialog: true),
    GetPage(name: '/Terms', page: () => Terms(),fullscreenDialog: true),
  ];
}
