import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class ValidationResultView extends GetView<IdeaController> {
  const ValidationResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validation Result')),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        final data = controller.validatedResponse;
        if (data.isEmpty) return const Center(child: Text('No result available.'));

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _card('Score', data['score']?.toString() ?? 'N/A', Icons.score, Colors.deepPurple),
            _card('Market Demand', data['market_demand'] ?? 'N/A', Icons.trending_up, Colors.green),
            _card('Revenue Potential', data['revenue_potential'] ?? 'N/A', Icons.attach_money, Colors.blue),
            _card('Target Audience', data['target_audience'] ?? 'N/A', Icons.groups, Colors.teal),
            _card('Competitor Presence', data['competitor_presence'] ?? 'N/A', Icons.storefront, Colors.orange),
            _card('Problems', data['problems'] ?? 'N/A', Icons.warning_amber, Colors.red),
            _card('Suggestions', data['suggestions'] ?? 'N/A', Icons.lightbulb_outline, Colors.amber),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller.generateRoadmap(),
              child: const Text('Generate 30-Day Roadmap', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      }),
    );
  }

  Widget _card(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, color: color), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
