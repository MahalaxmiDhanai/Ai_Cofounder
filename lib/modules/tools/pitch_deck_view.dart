import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class PitchDeckView extends GetView<IdeaController> {
  const PitchDeckView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pitch Deck Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Auto-create an investor-ready pitch deck outline for your startup.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            TextField(
              controller: controller.ideaTextController,
              decoration: const InputDecoration(hintText: 'Enter your startup idea...', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.generatePitchDeck,
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Generate Pitch Deck'),
            )),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.pitchDeck.value.isEmpty) {
                  return const Center(child: Text('Your pitch deck outline will appear here.'));
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: SelectableText(controller.pitchDeck.value, style: const TextStyle(fontSize: 14, height: 1.5)),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
