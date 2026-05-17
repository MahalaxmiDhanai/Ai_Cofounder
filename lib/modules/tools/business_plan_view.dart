import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class BusinessPlanView extends GetView<IdeaController> {
  const BusinessPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Plan Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Generate a complete business plan for your idea.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            TextField(
              controller: controller.ideaTextController,
              decoration: const InputDecoration(hintText: 'Enter your startup idea...', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.generateBusinessPlan,
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Generate Business Plan'),
            )),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.businessPlan.value.isEmpty) {
                  return const Center(child: Text('Your business plan will appear here.'));
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: SelectableText(controller.businessPlan.value, style: const TextStyle(fontSize: 14, height: 1.5)),
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
