import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class MarketResearchView extends GetView<IdeaController> {
  const MarketResearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market Research')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Research industry trends, customer pain points, and market opportunities.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            TextField(
              controller: controller.researchController,
              decoration: const InputDecoration(hintText: 'e.g. AI in education market 2026', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.doMarketResearch,
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Research Market'),
            )),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.marketResearch.value.isEmpty) {
                  return const Center(child: Text('Market research results will appear here.'));
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: SelectableText(controller.marketResearch.value, style: const TextStyle(fontSize: 14, height: 1.5)),
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
