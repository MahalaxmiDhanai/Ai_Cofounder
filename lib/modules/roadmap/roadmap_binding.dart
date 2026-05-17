import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class RoadmapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IdeaController());
  }
}
