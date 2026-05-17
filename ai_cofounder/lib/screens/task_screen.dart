import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/plan_controller.dart';
import 'progress_screen.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlanController>();
    final plan = controller.plan;

    if (plan == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.task_alt, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No plan found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.offAllNamed('/idea'),
                child: const Text('Create Plan'),
              ),
            ],
          ),
        ),
      );
    }

    if (plan.currentDay > 7) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.off(() => const ProgressScreen());
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3F3D56)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Day ${plan.currentDay} Tasks',
          style: const TextStyle(
            color: Color(0xFF3F3D56),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final tasks = controller.getCurrentDayTasks();
        final completedCount = controller.completedTasksTodayCount;
        final totalCount = controller.totalTasksToday;
        final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6C63FF),
                    const Color(0xFF6C63FF).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$completedCount / $totalCount',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final taskId = 'day${plan.currentDay}_task$index';
                  final isCompleted = controller.isTaskCompleted(taskId);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCompleted
                            ? const Color(0xFF6C63FF).withOpacity(0.3)
                            : Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CheckboxListTile(
                      value: isCompleted,
                      onChanged: (value) {
                        controller.toggleTaskCompletion(taskId);
                      },
                      title: Text(
                        task,
                        style: TextStyle(
                          fontSize: 16,
                          color: isCompleted
                              ? Colors.grey.shade500
                              : const Color(0xFF3F3D56),
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      secondary: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFF6C63FF)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isCompleted
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      activeColor: const Color(0xFF6C63FF),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(() {
            final isCompletingDay = controller.isLoading;

            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isCompletingDay
                    ? null
                    : () async {
                        await controller.markDayComplete();

                        if (controller.plan != null &&
                            controller.plan!.currentDay > 7) {
                          Get.off(() => const ProgressScreen());
                        } else {
                          Get.snackbar(
                            'Day Complete!',
                            'Great job! Moving to Day ${controller.plan?.currentDay ?? 0}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green.shade100,
                            colorText: Colors.green.shade900,
                            icon: const Icon(Icons.check_circle,
                                color: Colors.green),
                            duration: const Duration(seconds: 2),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompletingDay
                      ? Colors.grey
                      : const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: const Color(0xFF6C63FF).withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isCompletingDay
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Mark Day Complete',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
