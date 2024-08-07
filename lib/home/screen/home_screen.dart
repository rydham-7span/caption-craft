import 'package:caption_craft/constants/widgets/custom_snackbar.dart';
import 'package:caption_craft/home/screen/add_prompt_screen.dart';
import 'package:caption_craft/home/screen/fetched_data_screen.dart';
import 'package:caption_craft/home/screen/image_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final liquidController = LiquidController();
  final pageIndicatorController = PageController();

  final activeIndex = ValueNotifier<int>(0);
  DateTime? currentPress;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {

          final now = DateTime.now();
          if (currentPress == null ||
              now.difference(currentPress!) > const Duration(milliseconds: 1500)) {
            currentPress = now;
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                message: 'Press back again to exit',
                context: context,
              ),
            );
            return;
          } else {
            // controller?.goBack();
            SystemNavigator.pop();
          }

      },
      child: ValueListenableBuilder(
        valueListenable: activeIndex,
        builder: (context, value, child) {
          return Scaffold(
            extendBody: true,
            body: LiquidSwipe(
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
              enableLoop: true,
              liquidController: liquidController,
              positionSlideIcon: 0.13,
              enableSideReveal: true,
              slideIconWidget: const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox.shrink(),
              ),
              onPageChangeCallback: (activePageIndex) {
                activeIndex.value = activePageIndex;
              },
              waveType: WaveType.liquidReveal,
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 28, top: 20),
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
          );
        },
      ),
    );
  }
}
