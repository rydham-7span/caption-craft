import 'package:caption_this/home/screen/add_prompt_screen.dart';
import 'package:caption_this/home/screen/fetched_data_screen.dart';
import 'package:caption_this/home/screen/image_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final controller = LiquidController();
  static late final GenerativeModel model;

  @override
  void initState() {
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyCB9amB9zA7THGhjkLPJ_qAfXt8U4dIDD4',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            disableUserGesture: false,
            pages: [
              ImagePickerScreen(
                controller: controller,
              ),
              AddPromptScreen(
                controller: controller,
              ),
              FetchedDataScreen(
                controller: controller,
              ),
            ],
            enableLoop: false,
            liquidController: controller,
            waveType: WaveType.circularReveal,
          ),
        ],
      ),
    );
  }
}
