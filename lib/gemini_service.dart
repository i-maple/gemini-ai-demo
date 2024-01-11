import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_ai_demo/gemini_api_key.dart';

class GeminiService {
  static final gemini = Gemini.instance;

  static chatWithGemini(String prompt) async {
    try {
      final res = await gemini.text(prompt);
      return res?.output;
    } catch (e) {
      print(e);
      return;
    }
  }
}
