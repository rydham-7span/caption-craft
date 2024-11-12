enum ApiStatus { initial, loading, loaded, error }

enum SAVEDBOX {
  data('saveDataBox'),
  onBoardingBool('onBoardingBool');

  const SAVEDBOX(this.value);

  final String value;
}

///Permissions enum
enum MediaPermission {
  notification,
  camera,
  photo,
  storage,
}

enum PermissionResult {
  granted,
  denied,
  permanentlyDenied,
}

enum RuntimePermission {
  notification,
  camera,
  photo,
  storage,
}
