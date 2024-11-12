import 'package:caption_craft/constants/api/api_config.dart';
import 'package:caption_craft/constants/hive/save_service.dart';
import 'package:caption_craft/constants/notifications/onesignal_service.dart';
import 'package:caption_craft/home/bloc/generate_description_bloc.dart';
import 'package:caption_craft/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/initialize_singletons.dart';
import 'constants/hive/injection.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeSingletons();
  await getIt<ISaveService>().init();
  await getIt<OneSignalService>().init(ApiConfig.oneSignalId,shouldLog: true);
  await getIt<OneSignalService>().requestNotificationPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GenerateDescriptionBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CaptionCraft',
        theme: ThemeData(
          fontFamily: 'Syne',
          platform: TargetPlatform.iOS,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
