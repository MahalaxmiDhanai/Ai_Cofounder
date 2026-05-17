import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';
import '../../services/auth_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => IdeaController());
  }
}
