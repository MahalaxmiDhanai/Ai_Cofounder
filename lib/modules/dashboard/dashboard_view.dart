import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';
import '../../controllers/main_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    Get.put(IdeaController());
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Co-Founder'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(controller.isDarkMode.value ? Icons.light_mode : Icons.dark_mode),
            onPressed: controller.toggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Your Startup Dashboard', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Validate, plan, and grow your startup with AI.', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 24),
          _ToolCard(
            icon: Icons.psychology,
            title: 'Idea Validation',
            subtitle: 'Get AI-powered analysis & score',
            color: Colors.deepPurple,
            onTap: () => Get.toNamed('/tools/validate', id: 3),
          ),
          _ToolCard(
            icon: Icons.business_center,
            title: 'Business Plan',
            subtitle: 'Generate a complete business plan',
            color: Colors.blue,
            onTap: () => Get.toNamed('/tools/business-plan', id: 3),
          ),
          _ToolCard(
            icon: Icons.people,
            title: 'Competitor Analysis',
            subtitle: 'Analyze competitors & find gaps',
            color: Colors.teal,
            onTap: () => Get.toNamed('/tools/competitor-analysis', id: 3),
          ),
          _ToolCard(
            icon: Icons.slideshow,
            title: 'Pitch Deck',
            subtitle: 'Auto-create investor pitch deck',
            color: Colors.orange,
            onTap: () => Get.toNamed('/tools/pitch-deck', id: 3),
          ),
          _ToolCard(
            icon: Icons.travel_explore,
            title: 'Market Research',
            subtitle: 'Industry trends & customer insights',
            color: Colors.indigo,
            onTap: () => Get.toNamed('/tools/market-research', id: 3),
          ),
          _ToolCard(
            icon: Icons.monetization_on,
            title: 'Funding Checker',
            subtitle: 'Assess investor readiness',
            color: Colors.green,
            onTap: () => Get.toNamed('/tools/funding-check', id: 3),
          ),
          _ToolCard(
            icon: Icons.track_changes,
            title: 'Goal Tracking',
            subtitle: 'Track startup progress & milestones',
            color: Colors.pink,
            onTap: () => Get.toNamed('/tools/goal-tracking', id: 3),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ToolCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
          leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
