import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:caption_this/constants/hive/injection.dart';
import 'package:caption_this/constants/hive/save_service.dart';
import 'package:caption_this/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late AnimationController navAnimationController;
  late Animation<double> navAnimation;
  final iconHideBool = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    navAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..addStatusListener(
        (status) async {
          if (status == AnimationStatus.completed) {
            await getIt<ISaveService>().setObBool().run();
            Future.delayed(Duration.zero).then(
              (value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              ),
            );

            Timer(
              const Duration(milliseconds: 100),
              () => navAnimationController.reset(),
            );
          } else if (status == AnimationStatus.forward) {
            iconHideBool.value = true;
          }
        },
      );

    navAnimation = Tween<double>(begin: 0.0, end: 30.0).animate(navAnimationController);
  }

  @override
  void dispose() {
    navAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    'CaptionCraft',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                      color: Colors.deepPurple,
                      height: 1,
                      letterSpacing: -1,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .animate() // this wraps the previous Animate in another Animate
                      .fadeIn(duration: 1200.ms, curve: Curves.bounceOut)
                      .slide(),
                ),
                Container(
                  height: 2,
                  color: Colors.deepPurple.shade200,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                ).animate().scale(duration: 600.ms, alignment: Alignment.centerLeft),
                const Text(
                  'Don\'t know what to write in captions?? ',
                  style: TextStyle(fontSize: 20, color: Colors.white, height: 1, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Caption Craft is here to help! This app uses AI to generate creative, engaging captions tailored to your content. Simply upload your media, choose a tone, and let Caption Craft do the rest.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Container(
                  height: 2,
                  color: Colors.deepPurple.shade200,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                ).animate().scale(duration: 600.ms, alignment: Alignment.centerLeft),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Follow these steps to shine.',
                    style: TextStyle(fontSize: 20, color: Colors.white, height: 1, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.image,
                            color: Colors.deepPurple.shade300,
                          ),
                          const SizedBox(width: 18),
                          const Flexible(
                            child: Text(
                              'Select Image you want to upload on social media.',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.font,
                            color: Colors.deepPurple.shade300,
                          ),
                          const SizedBox(width: 18),
                          const Flexible(
                            child: Text(
                              'Add custom prompt or just click generate to get captions.',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.shareNodes,
                            color: Colors.deepPurple.shade300,
                          ),
                          const SizedBox(width: 18),
                          const Flexible(
                            child: Text(
                              'Share or save your favourite captions to social media platforms.',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                      .animate(interval: 600.ms, delay: 300.ms)
                      .fadeIn(duration: 900.ms)
                      .shimmer(blendMode: BlendMode.srcOver, color: Colors.deepPurple.withAlpha(120))
                      .move(begin: const Offset(0, 0), curve: Curves.easeOutQuad),
                ),
                const SizedBox(
                  height: 69,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'Let\'s Craft',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    AvatarGlow(
                      glowColor: Colors.deepPurple,
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      curve: Curves.easeOutQuad,
                      child: GestureDetector(
                        onTap: () {
                          navAnimationController.forward();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: AnimatedBuilder(
                                animation: navAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: navAnimation.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        borderRadius: BorderRadius.circular(360),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: iconHideBool,
                              builder: (context, value, child) {
                                return !iconHideBool.value
                                    ? const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
