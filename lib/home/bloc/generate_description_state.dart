part of 'generate_description_bloc.dart';

class GenerateDescriptionState {
  const GenerateDescriptionState({
    this.selectImageState = ApiStatus.initial,
    this.fetchDetailsState = ApiStatus.initial,
    this.saveDetailsState = ApiStatus.initial,
    this.deleteDataEvent = ApiStatus.initial,
    this.errorMessage,
    this.image,
    this.response,
  });

  final String? errorMessage;
  final ApiStatus? selectImageState;
  final ApiStatus? fetchDetailsState;
  final ApiStatus? saveDetailsState;
  final ApiStatus? deleteDataEvent;
  final Uint8List? image;
  final String? response;

  GenerateDescriptionState copyWith({
    String? errorMessage,
    ApiStatus? selectImageState,
    ApiStatus? fetchDetailsState,
    ApiStatus? saveDetailsState,
    ApiStatus? deleteDataEvent,
    Uint8List? image,
    String? response,
  }) {
    return GenerateDescriptionState(
      selectImageState: selectImageState ?? ApiStatus.initial,
      fetchDetailsState: fetchDetailsState ?? this.fetchDetailsState,
      saveDetailsState: saveDetailsState ?? ApiStatus.initial,
      deleteDataEvent: deleteDataEvent ?? ApiStatus.initial,
      errorMessage: errorMessage ?? '',
      response: response ?? this.response,
      image: image ?? this.image,

    );
  }
}
