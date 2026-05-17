import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class IdeaInputView extends GetView<IdeaController> {
  const IdeaInputView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Idea Validation'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Enter your startup idea', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Get AI-powered analysis with score, market demand, and suggestions.', style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextField(
              controller: controller.ideaTextController,
              decoration: const InputDecoration(hintText: 'e.g. AI-powered study planner for students', border: OutlineInputBorder()),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.analyzeIdea,
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Analyze Idea', style: TextStyle(fontSize: 16)),
            )),
          ],
        ),
      ),
    );
  }
}
