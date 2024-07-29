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
  final File? image;
  final String? response;

  GenerateDescriptionState copyWith({
    String? errorMessage,
    ApiStatus? selectImageState,
    ApiStatus? fetchDetailsState,
    File? image,
    String? response,
  }) {
    return GenerateDescriptionState(
      selectImageState: selectImageState ?? this.selectImageState,
      fetchDetailsState: fetchDetailsState ?? this.fetchDetailsState,
      errorMessage: errorMessage ?? '',
      response: response ?? this.response,
      image: image ?? this.image,
    );
  }
}
