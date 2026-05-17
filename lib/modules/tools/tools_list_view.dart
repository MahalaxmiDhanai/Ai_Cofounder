import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToolsListView extends StatelessWidget {
  const ToolsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Tools'), centerTitle: true),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
        children: [
          _ToolGridItem(icon: Icons.psychology, label: 'Validate Idea', color: Colors.deepPurple, route: '/tools/validate'),
          _ToolGridItem(icon: Icons.business_center, label: 'Business Plan', color: Colors.blue, route: '/tools/business-plan'),
          _ToolGridItem(icon: Icons.people, label: 'Competitors', color: Colors.teal, route: '/tools/competitor-analysis'),
          _ToolGridItem(icon: Icons.slideshow, label: 'Pitch Deck', color: Colors.orange, route: '/tools/pitch-deck'),
          _ToolGridItem(icon: Icons.travel_explore, label: 'Market Research', color: Colors.indigo, route: '/tools/market-research'),
          _ToolGridItem(icon: Icons.monetization_on, label: 'Funding Check', color: Colors.green, route: '/tools/funding-check'),
          _ToolGridItem(icon: Icons.track_changes, label: 'Goal Tracking', color: Colors.pink, route: '/tools/goal-tracking'),
          _ToolGridItem(icon: Icons.chat, label: 'AI Mentor', color: Colors.amber, route: '/chat'),
        ],
      ),
    );
  }
}

class _ToolGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  const _ToolGridItem({required this.icon, required this.label, required this.color, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Get.toNamed(route, id: 3),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 28, backgroundColor: color.withValues(alpha: 0.15), child: Icon(icon, color: color, size: 28)),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
