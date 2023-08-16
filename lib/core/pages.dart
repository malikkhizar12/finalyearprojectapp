import 'package:course_guide/screens/preferences.dart';
import 'package:course_guide/screens/settings.dart';
import 'package:course_guide/screens/welcomeScreen.dart';
import 'package:get/get.dart';
import '../screens/dashBoard.dart';
import '../screens/edit_profile.dart';
import '../screens/login.dart';
import '../screens/signup.dart';
import '../screens/splashScreen.dart';
import 'binding.dart';

class Pages {
  static List<GetPage> all = [
    GetPage(name: "/", page: () => SplashScreen(), binding: SplashBinding()),
    GetPage(name: "/login", page: () => Login(), fullscreenDialog: true),
    GetPage(name: "/welcomeScreen", page: () => const WelcomeScreen(), fullscreenDialog: true),
    GetPage(name: "/signup", page: () => SignupPage(), fullscreenDialog: true),
    GetPage(name: "/dashBoard", page: () =>  DashBoard(),fullscreenDialog: true),
    GetPage(name: '/editProfilePage', page: () => EditProfile(), binding: EditProfileBinding()),
    GetPage(name: '/settings', page: () =>  SettingsPage(), binding: SettingBinding()),
    GetPage(name: '/preferences', page: () =>  PreferencesPage(), binding: PreferencesBinding()),

  ];
}
