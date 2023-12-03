import 'package:course_guide/controllers/edit_profile_controller.dart';
import 'package:course_guide/controllers/preferences_controller.dart';
import 'package:course_guide/controllers/setting_controllers.dart';
import 'package:course_guide/controllers/setting_drawer_controller.dart';
import 'package:get/get.dart';

import '../controllers/firebase_auth_controller.dart';
import '../controllers/splash_controller.dart';
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FirebaseAuthController>(FirebaseAuthController(), permanent: true);
  }
}

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
  }
}
class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }

}
class PreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreferencesController());
  }

}

