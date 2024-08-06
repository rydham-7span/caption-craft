part of 'generate_description_bloc.dart';

@immutable
sealed class GenerateDescriptionEvent {}

class SelectAnImageEvent extends GenerateDescriptionEvent {}

class GeneratePostsEvent extends GenerateDescriptionEvent {
  GeneratePostsEvent({required this.image, this.prompt});

  final Uint8List image;
  final String? prompt;
}

class RemoveImageEvent extends GenerateDescriptionEvent {}

class SaveDataEvent extends GenerateDescriptionEvent {
  final SaveDataModel saveDataModel;

  SaveDataEvent({required this.saveDataModel});
}

class DeleteDataEvent extends GenerateDescriptionEvent {
  final int index;

  DeleteDataEvent({required this.index});

}
