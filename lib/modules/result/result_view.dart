import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class ResultView extends GetView<IdeaController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation Result'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final data = controller.validatedResponse;
        if (data.isEmpty) {
          return const Center(child: Text('No result available.'));
        }

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildResultCard('Score', data['score']?.toString() ?? 'N/A', Icons.score),
            _buildResultCard('Market Demand', data['market_demand'] ?? 'N/A', Icons.trending_up),
            _buildResultCard('Target Audience', data['target_audience'] ?? 'N/A', Icons.groups),
            _buildResultCard('Competitor Presence', data['competitor_presence'] ?? 'N/A', Icons.storefront),
            _buildResultCard('Problems', data['problems'] ?? 'N/A', Icons.warning_amber),
            _buildResultCard('Suggestions', data['suggestions'] ?? 'N/A', Icons.lightbulb_outline),
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

  Widget _buildResultCard(String title, String content, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
