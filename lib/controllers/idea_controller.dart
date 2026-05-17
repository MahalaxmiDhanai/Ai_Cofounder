import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/ai_service.dart';
import '../services/firestore_service.dart';

class IdeaController extends GetxController {
  final ideaTextController = TextEditingController();
  final competitorsController = TextEditingController();
  final researchController = TextEditingController();
  final isLoading = false.obs;

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
  var businessPlan = ''.obs;
  var competitorResult = ''.obs;
  var pitchDeck = ''.obs;
  var marketResearch = ''.obs;
  var fundingResult = ''.obs;

  Future<void> analyzeIdea() async {
    final text = ideaTextController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Error', 'Please enter a startup idea.');
      return;
    }
    isLoading.value = true;
    try {
      final validationResult = await aiService.validateIdea(text);
      if (validationResult == null) throw Exception('Validation failed');
      validatedResponse.value = validationResult;
      Get.toNamed('/tools/result', id: 3);
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
      final roadmapResult = await aiService.generateRoadmap(text);
      if (roadmapResult == null) throw Exception('Roadmap generation failed');
      roadmapResponse.value = roadmapResult;
      await firestoreService.saveIdea({
        'ideaText': text,
        'aiResponse': Map<String, dynamic>.from(validatedResponse),
        'roadmap': roadmapResult,
        'timestamp': DateTime.now().toIso8601String(),
        'userId': 'anonymous',
      });
      Get.toNamed('/tools/roadmap', id: 3);
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate roadmap.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateBusinessPlan() async {
    final text = ideaTextController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Error', 'Please enter a startup idea first.');
      return;
    }
    isLoading.value = true;
    try {
      final result = await aiService.generateBusinessPlan(text);
      businessPlan.value = result ?? 'Failed to generate business plan.';
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate business plan.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> analyzeCompetitors() async {
    final text = competitorsController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Error', 'Please enter competitor names.');
      return;
    }
    isLoading.value = true;
    try {
      final result = await aiService.generateCompetitorAnalysis(text);
      competitorResult.value = result ?? 'Failed to analyze competitors.';
    } catch (e) {
      Get.snackbar('Error', 'Failed to analyze competitors.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generatePitchDeck() async {
    final text = ideaTextController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Error', 'Please enter a startup idea first.');
      return;
    }
    isLoading.value = true;
    try {
      final result = await aiService.generatePitchDeck(text);
      pitchDeck.value = result ?? 'Failed to generate pitch deck.';
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate pitch deck.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> doMarketResearch() async {
    final text = researchController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Error', 'Please enter a topic to research.');
      return;
    }
    isLoading.value = true;
    try {
      final result = await aiService.marketResearch(text);
      marketResearch.value = result ?? 'Failed to research.';
    } catch (e) {
      Get.snackbar('Error', 'Failed to research market.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkFundingReadiness(Map<String, dynamic> answers) async {
    isLoading.value = true;
    try {
      final result = await aiService.fundingReadiness(answers);
      fundingResult.value = result ?? 'Failed to check funding readiness.';
    } catch (e) {
      Get.snackbar('Error', 'Failed to check funding readiness.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    ideaTextController.dispose();
    competitorsController.dispose();
    researchController.dispose();
    super.onClose();
  }
}
