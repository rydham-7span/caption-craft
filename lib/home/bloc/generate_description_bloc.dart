import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:caption_this/constants/enum.dart';
import 'package:caption_this/home/screen/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

part 'generate_description_event.dart';

part 'generate_description_state.dart';

class GenerateDescriptionBloc extends Bloc<GenerateDescriptionEvent, GenerateDescriptionState> {
  GenerateDescriptionBloc() : super(const GenerateDescriptionState()) {
    on<SelectAnImageEvent>(selectImage, transformer: droppable());
    on<GeneratePostsEvent>(getSocialPosts, transformer: droppable());
    on<RemoveImageEvent>(removeImage, transformer: droppable());
  }

  Future<void> selectImage(SelectAnImageEvent event, Emitter<GenerateDescriptionState> emit) async {
    emit(state.copyWith(selectImageState: ApiStatus.loading));
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    XFile imageFile = XFile(pickedFile?.path ?? '');
    final image = await imageFile.readAsBytes();
    if (pickedFile != null) {
      emit(state.copyWith(selectImageState: ApiStatus.loaded, image: image));
    } else {
      emit(state.copyWith(selectImageState: ApiStatus.error, errorMessage: 'Please select at-least one image.'));
    }
  }

  Future<void> getSocialPosts(GeneratePostsEvent event, Emitter<GenerateDescriptionState> emit) async {
    emit(state.copyWith(
      fetchDetailsState: ApiStatus.loading,
    ));

    try {
      final prompt = TextPart(
          "${event.prompt},Here I want social media post for all three platforms LinkedIn, X & Instagram with hashtags.Please format the response as follows : LinkedIn: [post description]\n******** Instagram: [post description]\n******** X: [post description]\n********");
      final imageParts = [
        DataPart( lookupMimeType('${event.image}') ?? 'image/jpeg', event.image),
      ];
      final response = await HomeScreenState.model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      final text = response.text;
      emit(state.copyWith(
        response: text,
        fetchDetailsState: ApiStatus.loaded,
      ));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(state.copyWith(fetchDetailsState: ApiStatus.error, errorMessage: 'Something went wrong.'));
    }
  }

  FutureOr<void> removeImage(RemoveImageEvent event, Emitter<GenerateDescriptionState> emit) {
    emit(state.copyWith(image: Uint8List(0)));
  }
}
