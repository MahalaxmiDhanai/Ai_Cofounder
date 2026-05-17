import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/constants/api_constants.dart';

class AiService {
  Future<Map<String, dynamic>?> validateIdea(String idea) async {
    final prompt = '''
You are a startup expert.

Analyze this startup idea:

$idea

Return response in this structured format:

1. Idea Score (out of 10)
2. Market Demand (High/Medium/Low)
3. Target Audience
4. Competitor Presence
5. Problems in Idea
6. Suggestions to improve

Ensure the output is exclusively a valid JSON object with the following keys exactly: "score", "market_demand", "target_audience", "competitor_presence", "problems", "suggestions". Do not include Markdown formatted blocks like ```json.
''';

    return await _callOpenAi(prompt);
  }

  Future<Map<String, dynamic>?> generateRoadmap(String idea) async {
    final prompt = '''
Act as a startup mentor.

Create a 30-day execution plan for this idea:

$idea

Divide into:

* Day 1–3
* Week 1
* Week 2
* Week 3
* Week 4

Ensure the output is exclusively a valid JSON object with the following keys exactly: "day_1_3", "week_1", "week_2", "week_3", "week_4". Do not include Markdown formatted blocks like ```json.
''';

    return await _callOpenAi(prompt);
  }

  Future<Map<String, dynamic>?> _callOpenAi(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.openAiEndpoint),
        headers: {
          'Authorization': 'Bearer \${ApiConstants.openAiApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini", // Standard fallback model 
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "temperature": 0.7
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      }
    } catch (e) {
      print('AI Service Error: $e');
    }
    return null;
  }
}
