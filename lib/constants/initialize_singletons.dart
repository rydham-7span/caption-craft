import 'package:caption_this/constants/hive/save_service.dart';

import 'hive/injection.dart';

void initializeSingletons() {
  getIt.registerSingleton<ISaveService>(SaveService());
}
