import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../core/collections.dart';
import 'firebase_auth_controller.dart';
class SplashController extends GetxController
{
  final controller = Get.find<FirebaseAuthController>();
  late final box = GetStorage();
  @override
  void onInit() async
  {
    String uid = firebaseUserId();
    print(uid);
    await Future.delayed(const Duration(seconds: 6), () async
    {
      if (uid.isNotEmpty)
      {
        await controller.sendSearchWordsToBackend();
        Get.offAllNamed('/dashBoard');
      }
      else
      {
        Get.offAllNamed('/welcomeScreen');
      }
    }
    );
    super.onInit();
  }

  @override
  void onClose()
  {
    super.onClose();
  }
}
