part of 'generate_description_bloc.dart';

class GenerateDescriptionState {
  const GenerateDescriptionState({
    this.selectImageState = ApiStatus.initial,
    this.fetchDetailsState = ApiStatus.initial,
    this.errorMessage,
    this.image,
    this.response,
  });

  final String? errorMessage;
  final ApiStatus? selectImageState;
  final ApiStatus? fetchDetailsState;
  final Uint8List? image;
  final String? response;

  GenerateDescriptionState copyWith({
    String? errorMessage,
    ApiStatus? selectImageState,
    ApiStatus? fetchDetailsState,
    Uint8List? image,
    String? response,
  }) {
    return GenerateDescriptionState(
      selectImageState: selectImageState ?? ApiStatus.initial,
      fetchDetailsState: fetchDetailsState ?? this.fetchDetailsState,
      errorMessage: errorMessage ?? '',
      response: response ?? this.response,
      image: image ?? this.image,
    );
  }
}
