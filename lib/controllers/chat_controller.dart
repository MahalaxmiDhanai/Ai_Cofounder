import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/ai_service.dart';

class ChatController extends GetxController {
  final chatController = TextEditingController();
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final isListening = false.obs;
  late final AiService aiService;
  late final stt.SpeechToText _speech;

  @override
  void onInit() {
    super.onInit();
    aiService = Get.find<AiService>();
    _speech = stt.SpeechToText();
    messages.add(ChatMessage(
      text: "Hi! I'm your AI Co-Founder mentor. Ask me anything about your startup — validation, marketing, fundraising, or building your MVP.",
      isUser: false,
    ));
  }

  Future<void> sendMessage() async {
    final text = chatController.text.trim();
    if (text.isEmpty) return;

    messages.add(ChatMessage(text: text, isUser: true));
    chatController.clear();
    isLoading.value = true;

    try {
      final history = messages
          .map((m) => {'role': m.isUser ? 'user' : 'assistant', 'content': m.text})
          .toList();
      final response = await aiService.chatWithMentor(text, history);
      if (response != null) {
        messages.add(ChatMessage(text: response, isUser: false));
      } else {
        messages.add(ChatMessage(text: "Sorry, I couldn't process that. Please try again.", isUser: false));
      }
    } catch (e) {
      messages.add(ChatMessage(text: "Error: Could not reach AI mentor.", isUser: false));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleListening() async {
    if (isListening.value) {
      await _speech.stop();
      isListening.value = false;
      return;
    }

    final available = await _speech.initialize();
    if (available) {
      isListening.value = true;
      _speech.listen(
        onResult: (result) {
          chatController.text = result.recognizedWords;
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar('Voice Unavailable', 'Speech recognition is not available on this device.');
    }
  }

  @override
  void onClose() {
    _speech.stop();
    chatController.dispose();
    super.onClose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  ChatMessage({required this.text, required this.isUser, DateTime? time})
      : time = time ?? DateTime.now();
}
