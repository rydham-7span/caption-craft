import 'dart:async';

import 'package:caption_craft/constants/hive/injection.dart';
import 'package:caption_craft/constants/hive/save_service.dart';
import 'package:caption_craft/home/screen/home_screen.dart';
import 'package:caption_craft/splash/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart' as fpdart;

import '../constants/notifications/onesignal_service.dart';

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
    navAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    navAnimation = Tween<double>(begin: 0.0, end: 0.69).animate(navAnimationController);
    Timer(const Duration(milliseconds: 100), () {
      navAnimationController.forward();
    });
    getRoute();
    getPermissions();
    super.initState();
  }

  @override
  void dispose() {
    navAnimationController.dispose();
    super.dispose();
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1)).then(
          (value) {
            if (mounted) {
              return Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }
          },
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1)).then(
          (value) {
            if (mounted) {
              return Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingScreen(),
                ),
              );
            }
          },
        );
      });
    }
    return fpdart.unit;
  }

  Future<void> getPermissions() async {
    // final permissionManager = PermissionManager();
    // permissionManager.requestPermission(MediaPermission.notification, context);
    final playerId = await getIt<OneSignalService>().getNotificationSubscriptionId();
    debugPrint('PLAYER ID ::::: $playerId');
  }
}
