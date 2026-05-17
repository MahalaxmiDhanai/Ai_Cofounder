import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plan_model.dart';

class AIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  final String apiKey;

  AIService({required this.apiKey});

  Future<PlanModel> generatePlan({
    required String idea,
    required String userId,
  }) async {
    final prompt = '''Convert this startup idea into a structured execution plan.

Return ONLY JSON with no markdown formatting, no code blocks, no backticks. Just pure JSON.

{
  "problem": "string",
  "audience": "string",
  "solution": "string",
  "features": ["string"],
  "execution_steps": ["string"],
  "daily_tasks": {
    "day1": ["string"],
    "day2": ["string"],
    "day3": ["string"],
    "day4": ["string"],
    "day5": ["string"],
    "day6": ["string"],
    "day7": ["string"]
  }
}

Startup Idea: $idea''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a startup advisor. You respond with ONLY valid JSON. No markdown, no explanations, no code blocks.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 4000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String content = data['choices'][0]['message']['content'];

        content = _cleanJsonResponse(content);

        final Map<String, dynamic> planData = jsonDecode(content);

        return PlanModel(
          id: '',
          userId: userId,
          idea: idea,
          problem: planData['problem'] ?? 'Not specified',
          audience: planData['audience'] ?? 'Not specified',
          solution: planData['solution'] ?? 'Not specified',
          features: List<String>.from(planData['features'] ?? []),
          executionSteps:
              List<String>.from(planData['execution_steps'] ?? []),
          dailyTasks: _parseDailyTasks(planData['daily_tasks'] ?? {}),
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception(
            'Failed to generate plan: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating plan: $e');
    }
  }

  String _cleanJsonResponse(String content) {
    content = content.trim();

    if (content.startsWith('```json')) {
      content = content.substring(7);
    }
    if (content.startsWith('```')) {
      content = content.substring(3);
    }
    if (content.endsWith('```')) {
      content = content.substring(0, content.length - 3);
    }

    content = content.trim();

    return content;
  }

  Map<String, List<String>> _parseDailyTasks(dynamic tasksData) {
    Map<String, List<String>> result = {};

    if (tasksData is Map) {
      for (int i = 1; i <= 7; i++) {
        String key = 'day$i';
        if (tasksData.containsKey(key)) {
          result[key] = List<String>.from(tasksData[key]);
        } else {
          result[key] = ['No tasks defined for day $i'];
        }
      }
    }

    return result;
  }
}
