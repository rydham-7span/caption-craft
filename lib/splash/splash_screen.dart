import 'package:caption_this/constants/hive/injection.dart';
import 'package:caption_this/constants/hive/save_service.dart';
import 'package:caption_this/home/screen/home_screen.dart';
import 'package:caption_this/splash/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart' as fpdart;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController navAnimationController;
  late Animation<double> navAnimation;

  @override
  void initState() {
    navAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));

    navAnimation = Tween<double>(begin: 0.5, end: 40).animate(navAnimationController);
    super.initState();
    getRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: AnimatedBuilder(
          animation: navAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: navAnimation.value,
              child: SvgPicture.asset(
                'assets/icons/app_icon.svg',
              ),
            );
          },
        ),
      ),
    );
  }

  fpdart.Unit getRoute() {
    final isFirst = getIt<ISaveService>().getObBool();
    if (isFirst) {
      navAnimationController.forward();
      Future.delayed(const Duration(seconds: 1000)).then(
        (value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        ),
      );
    } else {
      navAnimationController.forward();
      Future.delayed(const Duration(seconds: 10000)).then(
        (value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        ),
      );
    }
    return fpdart.unit;
  }
}
