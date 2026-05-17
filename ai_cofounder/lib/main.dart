import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/plan_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/idea_input_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/task_screen.dart';
import 'screens/progress_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  const openaiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: 'YOUR_OPENAI_API_KEY_HERE',
  );

  Get.put(PlanController(openaiApiKey: openaiApiKey));

  runApp(const AICofounderApp());
}

class AICofounderApp extends StatelessWidget {
  const AICofounderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Co-Founder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6C63FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF3F3D56),
        ),
        fontFamily: 'System',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF3F3D56)),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
        GetPage(name: '/idea', page: () => const IdeaInputScreen()),
        GetPage(name: '/plan', page: () => const PlanScreen()),
        GetPage(name: '/tasks', page: () => const TaskScreen()),
        GetPage(name: '/progress', page: () => const ProgressScreen()),
      ],
    );
  }
}
