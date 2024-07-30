import 'package:caption_this/home/screen/add_prompt_screen.dart';
import 'package:caption_this/home/screen/fetched_data_screen.dart';
import 'package:caption_this/home/screen/image_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final liquidController = LiquidController();
  final pageIndicatorController = PageController();
  static late final GenerativeModel model;
  final activeIndex = ValueNotifier<int>(0);

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
      body: ValueListenableBuilder(
          valueListenable: activeIndex,
          builder: (context, value, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                LiquidSwipe(
                  disableUserGesture: true,
                  ignoreUserGestureWhileAnimating: true,
                  pages: [
                    ImagePickerScreen(
                      controller: liquidController,
                    ),
                    AddPromptScreen(
                      controller: liquidController,
                    ),
                    FetchedDataScreen(
                      controller: liquidController,
                    ),
                  ],
                  enableLoop: false,
                  liquidController: liquidController,
                  positionSlideIcon: 0.13,
                  enableSideReveal: true,
                  slideIconWidget: const Padding(
                    padding: EdgeInsets.all(17),
                    child: SizedBox.shrink(),
                  ),
                  onPageChangeCallback: (activePageIndex) {
                    activeIndex.value = activePageIndex;
                  },
                  waveType: WaveType.liquidReveal,
                ),
                Positioned(
                  bottom: 30,
                  left: 30,
                  child: AnimatedSmoothIndicator(
                    activeIndex: activeIndex.value,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      spacing: 20,
                      dotColor: Colors.white,
                      paintStyle: PaintingStyle.fill,
                      activeDotColor: Colors.deepPurple.shade300.withAlpha(200),
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
