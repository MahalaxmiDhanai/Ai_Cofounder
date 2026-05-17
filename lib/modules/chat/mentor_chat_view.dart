import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';

class MentorChatView extends StatelessWidget {
  const MentorChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Mentor'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.messages.length,
              itemBuilder: (_, i) {
                final msg = controller.messages[i];
                return _ChatBubble(text: msg.text, isUser: msg.isUser, time: msg.time);
              },
            )),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator());
            }
            return const SizedBox.shrink();
          }),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.chatController,
                      decoration: const InputDecoration(hintText: 'Ask your AI mentor...', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => controller.sendMessage(),
                    ),
                  ),
                  Obx(() => IconButton(
                    icon: Icon(controller.isListening.value ? Icons.mic : Icons.mic_none),
                    color: controller.isListening.value ? Colors.red : null,
                    onPressed: controller.toggleListening,
                  )),
                  const SizedBox(width: 4),
                  Obx(() => IconButton.filled(
                    onPressed: controller.isLoading.value ? null : controller.sendMessage,
                    icon: const Icon(Icons.send),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime time;

  const _ChatBubble({required this.text, required this.isUser, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: TextStyle(color: isUser ? Colors.white : null)),
            const SizedBox(height: 4),
            Text(_formatTime(time), style: TextStyle(fontSize: 10, color: isUser ? Colors.white70 : Colors.grey)),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
