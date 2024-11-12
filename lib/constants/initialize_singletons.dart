import 'package:caption_craft/constants/hive/save_service.dart';
import 'package:caption_craft/constants/notifications/onesignal_service.dart';

import 'hive/injection.dart';

void initializeSingletons() {
  getIt.registerSingleton<ISaveService>(SaveService());
  getIt.registerSingleton<OneSignalService>(OneSignalService());
}
