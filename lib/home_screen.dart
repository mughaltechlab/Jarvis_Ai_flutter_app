import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jarvis/pallete.dart';
import 'package:jarvis/services/openai_services.dart';
import 'package:jarvis/widget/feature_box.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // stt.SpeechToText? speechToText;
  // bool isListening = false;
  // String text = 'Press button and start speaking';
  // double confidence = 1.0;

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  bool speechEnabled = false;
  final stt.SpeechToText speechToText = stt.SpeechToText();
  final OpenAiServices openAiServices = OpenAiServices();
  final FlutterTts flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImageUrl;

  String boxText = 'SIR SAQIB! What task can i do for you';
  String lastWords = '';
  // these variables are used in duration of animation
  int start = 200;
  int delay = -200;

  @override
  void initState() {
    super.initState();
    // speechToText = stt.SpeechToText();

    initializeSpeechToText();
    initTextToSpeech();
  }

// __________--------------FUNCTIONS--------------_________________________

  // // func->> initializing text to speech.
  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  // // func->> initializing speech to text.
  Future<void> initializeSpeechToText() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  // start listening
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  // stop listening
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  // onresult function
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  // function for speaking the system
  Future<void> systemSpeak(String content) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.5);
    await flutterTts.speak(content);
  }

  // dispose
  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: const Text(
            'JARVIS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // profile pic
            ZoomIn(
              child: Stack(
                children: [
                  // background circle
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Pallete.profileCircle,
                      ),
                    ),
                  ),

                  // picture
                  Center(
                    child: Container(
                      height: 160,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/robot.png')),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // chat box
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Pallete.mainBox,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15)).copyWith(
                        topLeft: Radius.zero,
                      )),
                  child: Text(
                    generatedContent == null ? boxText : generatedContent!,
                    style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontFamily: 'Cera Pro',
                      fontSize: generatedContent == null ? 25 : 18,
                    ),
                  ),
                ),
              ),
            ),
            // logic for showing image
            if (generatedImageUrl != null)
              ZoomIn(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(generatedImageUrl!),
                  ),
                ),
              ),

            // features
            // heading
            SlideInRight(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Cera Pro',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // features boxes

            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInRight(
                    delay: Duration(milliseconds: start),
                    child: FeatureBox(
                      title: 'ChatGPT',
                      description:
                          'A smarter way to stay organized and informed with CatGPT',
                      color: Pallete.firstFeatureBox,
                    ),
                  ),
                  SlideInRight(
                    delay: Duration(milliseconds: start + delay),
                    child: FeatureBox(
                      title: 'Dall-E',
                      description:
                          'Get inspired and stay creative with your personal assistant powered by Dall-E',
                      color: Pallete.secondFeatureBox,
                    ),
                  ),
                  SlideInRight(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: FeatureBox(
                      title: 'Smart Voice Assistant',
                      description:
                          'Get the best of both worlds with a voice assistant powered by Dall-E',
                      color: Pallete.thirdFeatureBox,
                    ),
                  ),
                ],
              ),
            ),

            // floating mic
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.mainBox,
          // onPressed: listen,
          // onPressed: speechToText.isNotListening ? startListening : stopListening,
          onPressed: () async {
            // if speech permission is true but its not listening , so its start listening
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();

              print('play');
              // print(lastWords);
            }
            // speech is listen so stop when pressing button
            else if (speechToText.isListening) {
              final speech = await openAiServices.isArtPromptApi(lastWords);

              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }

              print('stop');
              await stopListening();
            } else {
              initializeSpeechToText();
            }
          },
          child: Icon(speechToText.isNotListening ? Icons.mic : Icons.mic_off),
        ),
      ),
    );
  }

  // void listen() async {
  //   if (!isListening) {
  //     bool available = await speechToText!.initialize(
  //       onStatus: (val) => print('onStatus: $val'),
  //       onError: (val) => print('onError: $val'),
  //     );
  //     if (available) {
  //       setState(() => isListening = true);
  //       speechToText!.listen(
  //         listenFor: const Duration(seconds: 300),

  //         onResult: (val) => setState(() {
  //           text = val.recognizedWords;
  //           if (val.hasConfidenceRating && val.confidence > 0) {
  //             confidence = val.confidence;
  //           }
  //         }),
  //       );
  //     }
  //   } else {
  //     setState(() => isListening = false);
  //     speechToText!.stop();

  //   }
  // }
}
