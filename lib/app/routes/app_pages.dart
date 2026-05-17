import 'package:get/get.dart';

import '../../modules/home/home_binding.dart';
import '../../modules/home/home_view.dart';
import '../../modules/result/result_binding.dart';
import '../../modules/result/result_view.dart';
import '../../modules/roadmap/roadmap_binding.dart';
import '../../modules/roadmap/roadmap_view.dart';

part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.RESULT,
      page: () => const ResultView(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: Routes.ROADMAP,
      page: () => const RoadmapView(),
      binding: RoadmapBinding(),
    ),
  ];
}
