import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/theme/app_theme.dart';
import 'controllers/main_controller.dart';
import 'modules/dashboard/dashboard_view.dart';
import 'modules/chat/mentor_chat_view.dart';
import 'modules/tools/tools_list_view.dart';
import 'modules/profile/profile_view.dart';
import 'modules/validate/idea_input_view.dart';
import 'modules/validate/validation_result_view.dart';
import 'modules/tools/roadmap_view.dart';
import 'modules/tools/business_plan_view.dart';
import 'modules/tools/competitor_analysis_view.dart';
import 'modules/tools/pitch_deck_view.dart';
import 'modules/tools/market_research_view.dart';
import 'modules/tools/funding_check_view.dart';
import 'modules/tools/goal_tracking_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    return GetMaterialApp(
      title: 'AI Co-Founder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeTab(),
            ChatTab(),
            ToolsTab(),
            ProfileTab(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changePage,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.chat_outlined), selectedIcon: Icon(Icons.chat), label: 'Chat'),
            NavigationDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: 'Tools'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) => _buildNavigator('/home');
}

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});
  @override
  Widget build(BuildContext context) => _buildNavigator('/chat');
}

class ToolsTab extends StatelessWidget {
  const ToolsTab({super.key});
  @override
  Widget build(BuildContext context) => _buildNavigator('/tools');
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) => _buildNavigator('/profile');
}

Widget _buildNavigator(String initialRoute) {
  return Navigator(
    key: Get.nestedKey(Get.find<MainController>().currentIndex.value + 1),
    initialRoute: initialRoute,
    onGenerateRoute: (settings) {
      Map<String, Widget Function()> routes = {
        '/home': () => const DashboardView(),
        '/chat': () => const MentorChatView(),
        '/tools': () => const ToolsListView(),
        '/profile': () => const ProfileView(),
        '/tools/validate': () => const IdeaInputView(),
        '/tools/result': () => const ValidationResultView(),
        '/tools/roadmap': () => const RoadmapView(),
        '/tools/business-plan': () => const BusinessPlanView(),
        '/tools/competitor-analysis': () => const CompetitorAnalysisView(),
        '/tools/pitch-deck': () => const PitchDeckView(),
        '/tools/market-research': () => const MarketResearchView(),
        '/tools/funding-check': () => const FundingCheckView(),
        '/tools/goal-tracking': () => const GoalTrackingView(),
      };
      return MaterialPageRoute(builder: (_) => routes[settings.name]!());
    },
  );
}
