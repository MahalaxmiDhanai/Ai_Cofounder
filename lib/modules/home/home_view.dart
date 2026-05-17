import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';
import '../../services/auth_service.dart';

class HomeView extends GetView<IdeaController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Co-Founder'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () async {
              final authService = Get.find<AuthService>();
              await authService.signInWithGoogle();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your startup idea',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.ideaTextController,
              decoration: const InputDecoration(
                hintText: 'e.g. AI-powered study planner for students',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.analyzeIdea(),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Analyze Idea', style: TextStyle(fontSize: 16)),
                )),
          ],
        ),
      ),
    );
  }
}
