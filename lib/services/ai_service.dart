import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../app/constants/api_constants.dart';

class AiService {
  Future<Map<String, dynamic>?> validateIdea(String idea) async {
    final prompt = '''
You are a startup expert.
Analyze this startup idea: $idea
Return valid JSON with these exact keys: "score" (out of 10), "market_demand" (High/Medium/Low), "target_audience", "competitor_presence", "problems", "suggestions", "revenue_potential" (High/Medium/Low), "risks".
Do not include markdown code blocks.
''';
    return _callOpenAi(prompt);
  }

  Future<Map<String, dynamic>?> generateRoadmap(String idea) async {
    final prompt = '''
Act as a startup mentor. Create a 30-day execution plan for this idea: $idea
Return valid JSON with these exact keys: "day_1_3", "week_1", "week_2", "week_3", "week_4".
Do not include markdown code blocks.
''';
    return _callOpenAi(prompt);
  }

  Future<String?> generateBusinessPlan(String idea) async {
    final prompt = '''
You are a business strategist. Create a detailed business plan for this startup idea: $idea
Include: startup name suggestions, elevator pitch, mission & vision, business model canvas, revenue model, go-to-market strategy.
Return as plain text with clear sections.
''';
    return _callOpenAiText(prompt);
  }

  Future<String?> generateCompetitorAnalysis(String competitors) async {
    final prompt = '''
You are a market analyst. Analyze these competitors: $competitors
For each competitor provide: strengths, weaknesses, pricing, feature comparison, opportunities.
Return as plain text with clear sections.
''';
    return _callOpenAiText(prompt);
  }

  Future<String?> generatePitchDeck(String idea) async {
    final prompt = '''
You are a pitch deck expert. Create a pitch deck outline for this startup idea: $idea
Include sections: Problem, Solution, Market Size, Product, Business Model, Team, Financials, Ask.
Return as plain text with clear sections.
''';
    return _callOpenAiText(prompt);
  }

  Future<String?> marketResearch(String topic) async {
    final prompt = '''
You are a market research analyst. Research this topic: $topic
Provide: industry trends, customer pain points, keywords, opportunities, market size estimates.
Return as plain text with clear sections.
''';
    return _callOpenAiText(prompt);
  }

  Future<String?> fundingReadiness(Map<String, dynamic> answers) async {
    final prompt = '''
You are a funding readiness advisor. Based on these answers from a startup founder:
${jsonEncode(answers)}
Assess: MVP readiness, revenue status, pitch quality, investor readiness score (out of 10), specific recommendations.
Return as plain text with clear sections.
''';
    return _callOpenAiText(prompt);
  }

  Future<String?> chatWithMentor(String message, List<Map<String, String>> history) async {
    final prompt = '''
You are an experienced startup mentor. You give practical, actionable advice to founders.
Be concise, direct, and helpful. The user's message: $message
''';
    return _callOpenAiChat(prompt, history);
  }

  Future<Map<String, dynamic>?> _callOpenAi(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.openAiEndpoint),
        headers: {
          'Authorization': 'Bearer ${ApiConstants.openAiApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [{"role": "user", "content": prompt}],
          "temperature": 0.7,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      }
    } catch (e) {
      debugPrint('AI Service Error: $e');
    }
    return null;
  }

  Future<String?> _callOpenAiText(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.openAiEndpoint),
        headers: {
          'Authorization': 'Bearer ${ApiConstants.openAiApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [{"role": "user", "content": prompt}],
          "temperature": 0.7,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String?;
      }
    } catch (e) {
      debugPrint('AI Service Error: $e');
    }
    return null;
  }

  Future<String?> _callOpenAiChat(String message, List<Map<String, String>> history) async {
    try {
      List<Map<String, String>> messages = [
        {"role": "system", "content": "You are an experienced startup mentor. Be concise, direct, and helpful."},
        ...history.map((m) => {"role": m['role']!, "content": m['content']!}),
        {"role": "user", "content": message},
      ];
      final response = await http.post(
        Uri.parse(ApiConstants.openAiEndpoint),
        headers: {
          'Authorization': 'Bearer ${ApiConstants.openAiApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": messages,
          "temperature": 0.7,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String?;
      }
    } catch (e) {
      debugPrint('AI Mentor Error: $e');
    }
    return null;
  }
}
