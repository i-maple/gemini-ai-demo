import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_ai_demo/gemini_api_key.dart';
import 'package:gemini_ai_demo/gemini_service.dart';

void main() {
  Gemini.init(apiKey: apiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GeminiApp(),
    );
  }
}

class GeminiApp extends StatefulWidget {
  const GeminiApp({super.key});

  @override
  State<GeminiApp> createState() => _GeminiAppState();
}

class _GeminiAppState extends State<GeminiApp> {
  late TextEditingController _promptController;
  bool isLoading = false;
  String responseText = '';

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _promptController.dispose();
  }

  loadPrompt() async {
    setState(() {
      isLoading = true;
    });
    var res;
    try {
      res = await GeminiService.chatWithGemini(_promptController.text);
      print(res);
    } catch (e) {
      print(e);
      return;
    }
    setState(() {
      isLoading = false;
      responseText = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isLoading
              ? const SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              responseText.isNotEmpty
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              responseText,
                            ),
                          ],
                          repeatForever: false,
                        ),
                      ),
                    )
                  : const SizedBox(),
              Card(
                child: ListTile(
                  title: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your prompt here',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(),
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: loadPrompt,
                    icon: const Icon(Icons.keyboard_arrow_right_sharp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
