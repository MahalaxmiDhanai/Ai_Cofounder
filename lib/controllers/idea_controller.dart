import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/ai_service.dart';
import '../services/firestore_service.dart';
import '../app/routes/app_pages.dart';

class IdeaController extends GetxController {
  final ideaTextController = TextEditingController();
  final isLoading = false.obs;
  
  // Replace these with actual Service instances when creating them
  late final AiService aiService;
  late final FirestoreService firestoreService;

  @override
  void onInit() {
    super.onInit();
    aiService = Get.put(AiService());
    firestoreService = Get.put(FirestoreService());
  }

  var validatedResponse = {}.obs;
  var roadmapResponse = {}.obs;

  Future<void> analyzeIdea() async {
    final text = ideaTextController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Error', 'Please enter a startup idea.');
      return;
    }

    isLoading.value = true;
    try {
      // 1. Idea Validation
      final validationResult = await aiService.validateIdea(text);
      if (validationResult == null) throw Exception('Validation failed');
      
      validatedResponse.value = validationResult;
      
      // Navigate to Result Screen
      Get.toNamed(Routes.RESULT);
      
      // Note: We might want to save to firebase later
    } catch (e) {
      Get.snackbar('Error', 'Failed to analyze idea. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateRoadmap() async {
    final text = ideaTextController.text.trim();
    isLoading.value = true;
    try {
      // 2. Roadmap Generation
      final roadmapResult = await aiService.generateRoadmap(text);
      if (roadmapResult == null) throw Exception('Roadmap generation failed');
      
      roadmapResponse.value = roadmapResult;
      
      // Save data to Firebase (Idea + Validation + Roadmap)
      await firestoreService.saveIdea({
        'ideaText': text,
        'aiResponse': validatedResponse.value,
        'roadmap': roadmapResult,
        'timestamp': DateTime.now().toIso8601String(),
        'userId': 'anonymous', // will replace with auth later if needed
      });
      
      Get.toNamed(Routes.ROADMAP);
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate roadmap.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    ideaTextController.dispose();
    super.onClose();
  }
}
