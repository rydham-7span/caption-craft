import 'package:caption_this/constants/save_service.dart';

import 'injection.dart';

void initializeSingletons() {
  getIt.registerSingleton<ISaveService>(SaveService());
}
