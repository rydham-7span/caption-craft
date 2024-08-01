part of 'generate_description_bloc.dart';

@immutable
sealed class GenerateDescriptionEvent {}

class SelectAnImageEvent extends GenerateDescriptionEvent {}

class GeneratePostsEvent extends GenerateDescriptionEvent {
  GeneratePostsEvent({required this.image, this.prompt});

  final File image;
  final String? prompt;
}

class RemoveImageEvent extends GenerateDescriptionEvent {}
