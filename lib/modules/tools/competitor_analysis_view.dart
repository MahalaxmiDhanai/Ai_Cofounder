import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class CompetitorAnalysisView extends GetView<IdeaController> {
  const CompetitorAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Competitor Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Enter competitor names to analyze their strengths, weaknesses, and market positioning.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            TextField(
              controller: controller.competitorsController,
              decoration: const InputDecoration(hintText: 'e.g. Notion, Asana, Trello', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.analyzeCompetitors,
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Analyze Competitors'),
            )),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.competitorResult.value.isEmpty) {
                  return const Center(child: Text('Competitor analysis will appear here.'));
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: SelectableText(controller.competitorResult.value, style: const TextStyle(fontSize: 14, height: 1.5)),
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
