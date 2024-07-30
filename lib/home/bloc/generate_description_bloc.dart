import 'dart:async';
import 'dart:io';

import 'package:caption_this/constants/enum.dart';
import 'package:caption_this/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

part 'generate_description_event.dart';

part 'generate_description_state.dart';

class GenerateDescriptionBloc extends Bloc<GenerateDescriptionEvent, GenerateDescriptionState> {
  GenerateDescriptionBloc() : super(const GenerateDescriptionState()) {
    on<SelectAnImageEvent>(selectImage);
    on<GeneratePostsEvent>(getSocialPosts);
  }

  Future<void> selectImage(SelectAnImageEvent event, Emitter<GenerateDescriptionState> emit) async {
    emit(state.copyWith(selectImageState: ApiStatus.loading));
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(state.copyWith(selectImageState: ApiStatus.loaded, image: File(pickedFile.path)));
    } else {
      emit(state.copyWith(selectImageState: ApiStatus.error, errorMessage: 'Please select at-least one image.'));
    }
  }

  Future<void> getSocialPosts(GeneratePostsEvent event, Emitter<GenerateDescriptionState> emit) async {
    emit(state.copyWith(fetchDetailsState: ApiStatus.loading,));

    try {
      final image1 = await event.image.readAsBytes();
      final prompt = TextPart(
          "${event.prompt},Here I want social media post for all three platforms LinkedIn, X & Instagram with hashtags.Please format the response as follows : LinkedIn: [post description]\n******** Instagram: [post description]\n******** X: [post description]\n********");
      final imageParts = [
        DataPart('image/jpeg', image1),
      ];
      final response = await HomeScreenState.model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      final text = response.text;
      emit(state.copyWith(response: text,fetchDetailsState: ApiStatus.loaded,));
    } catch (_) {
      emit(state.copyWith(fetchDetailsState: ApiStatus.error, errorMessage: 'Something went wrong.'));
    }
  }
}
