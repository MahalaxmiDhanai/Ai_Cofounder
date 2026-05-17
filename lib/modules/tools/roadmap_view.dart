import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class RoadmapView extends GetView<IdeaController> {
  const RoadmapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('30-Day Execution Plan')),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        final data = controller.roadmapResponse;
        if (data.isEmpty) return const Center(child: Text('No roadmap available.'));

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _timelineItem('Day 1-3', data['day_1_3'] ?? 'N/A'),
            _timelineItem('Week 1', data['week_1'] ?? 'N/A'),
            _timelineItem('Week 2', data['week_2'] ?? 'N/A'),
            _timelineItem('Week 3', data['week_3'] ?? 'N/A'),
            _timelineItem('Week 4', data['week_4'] ?? 'N/A'),
          ],
        );
      }),
    );
  }

  Widget _timelineItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(children: [
              Container(width: 16, height: 16, decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle)),
              Expanded(child: Container(width: 2, color: Colors.deepPurple.withValues(alpha: 0.5))),
            ]),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      const SizedBox(height: 8),
                      Text(content, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
