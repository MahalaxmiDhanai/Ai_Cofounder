import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/idea_controller.dart';

class FundingCheckView extends GetView<IdeaController> {
  const FundingCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    final mvpReady = false.obs;
    final hasRevenue = false.obs;
    final hasPitch = false.obs;
    final revenueAmount = TextEditingController();
    final teamSize = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Funding Readiness Checker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Assess your startup\'s readiness for investor funding.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Startup Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(controller: controller.ideaTextController, decoration: const InputDecoration(labelText: 'Your Idea / Product', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    Obx(() => CheckboxListTile(title: const Text('MVP is built / in development'), value: mvpReady.value, onChanged: (v) => mvpReady.value = v!)),
                    Obx(() => CheckboxListTile(title: const Text('Has revenue / paying customers'), value: hasRevenue.value, onChanged: (v) => hasRevenue.value = v!)),
                    Obx(() => CheckboxListTile(title: const Text('Has pitch deck / investor materials'), value: hasPitch.value, onChanged: (v) => hasPitch.value = v!)),
                    const SizedBox(height: 12),
                    TextField(controller: revenueAmount, decoration: const InputDecoration(labelText: 'Monthly Revenue (if any)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    TextField(controller: teamSize, decoration: const InputDecoration(labelText: 'Team Size', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.checkFundingReadiness({
                      'idea': controller.ideaTextController.text,
                      'mvp_ready': mvpReady.value,
                      'has_revenue': hasRevenue.value,
                      'has_pitch': hasPitch.value,
                      'monthly_revenue': revenueAmount.text,
                      'team_size': teamSize.text,
                    }),
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Check Funding Readiness'),
            )),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.fundingResult.value.isEmpty) return const SizedBox.shrink();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(controller.fundingResult.value, style: const TextStyle(fontSize: 14, height: 1.5)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
