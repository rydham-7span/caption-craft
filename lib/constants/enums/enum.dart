enum ApiStatus { initial, loading, loaded, error }

enum SAVEDBOX {
  data('saveDataBox'),
  onBoardingBool('onBoardingBool');

  const SAVEDBOX(this.value);

  final String value;
}
