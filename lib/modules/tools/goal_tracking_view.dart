import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/firestore_service.dart';
import '../../controllers/idea_controller.dart';

class GoalTrackingView extends StatefulWidget {
  const GoalTrackingView({super.key});

  @override
  State<GoalTrackingView> createState() => _GoalTrackingViewState();
}

class _GoalTrackingViewState extends State<GoalTrackingView> {
  final goalController = TextEditingController();
  final milestoneController = TextEditingController();

  void _addGoal() {
    final goal = goalController.text.trim();
    final milestone = milestoneController.text.trim();
    if (goal.isEmpty) return;

    Get.find<FirestoreService>().saveGoal({
      'goal': goal,
      'milestone': milestone,
      'completed': false,
      'createdAt': DateTime.now().toIso8601String(),
      'userId': 'anonymous',
    });

    goalController.clear();
    milestoneController.clear();
    Get.snackbar('Goal Added', 'Track your progress on the dashboard.');
  }

  @override
  void dispose() {
    goalController.dispose();
    milestoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = Get.find<FirestoreService>();
    final ideaCtrl = Get.find<IdeaController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Goal Tracking')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Add New Goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: goalController,
                      decoration: const InputDecoration(hintText: 'e.g. Launch MVP by June', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: milestoneController,
                      decoration: const InputDecoration(hintText: 'Key milestone (optional)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: _addGoal, child: const Text('Add Goal')),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Your Goals', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('AI Suggest'),
                  onPressed: () {
                    ideaCtrl.ideaTextController.text.isNotEmpty
                        ? ideaCtrl.generateRoadmap()
                        : Get.snackbar('Info', 'Enter an idea in Validate tab first for AI suggestions.');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: firestore.getGoalsStream('anonymous'),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final goals = snapshot.data!.docs;
                if (goals.isEmpty) {
                  return const Center(child: Text('No goals yet. Add your first goal above.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: goals.length,
                  itemBuilder: (_, i) {
                    final g = goals[i].data() as Map<String, dynamic>;
                    final isDone = g['completed'] == true;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? Colors.green : null),
                        title: Text(g['goal'] ?? '', style: TextStyle(decoration: isDone ? TextDecoration.lineThrough : null)),
                        subtitle: g['milestone'] != null && (g['milestone'] as String).isNotEmpty ? Text(g['milestone']) : null,
                        trailing: IconButton(
                          icon: Icon(isDone ? Icons.undo : Icons.check, size: 20),
                          onPressed: () => goals[i].reference.update({'completed': !isDone}),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
