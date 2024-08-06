import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:caption_this/constants/enums/enum.dart';
import 'package:caption_this/constants/hive/injection.dart';
import 'package:caption_this/constants/hive/save_service.dart';
import 'package:caption_this/home/model/save_data_model.dart';
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
    on<SaveDataEvent>(saveData, transformer: droppable());
    on<DeleteDataEvent>(deleteData, transformer: droppable());
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
        DataPart(lookupMimeType('${event.image}') ?? 'image/jpeg', event.image),
      ];
      GenerativeModel model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyCB9amB9zA7THGhjkLPJ_qAfXt8U4dIDD4',
      );
      final response = await model.generateContent([
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

  Future<void> saveData(SaveDataEvent event, Emitter<GenerateDescriptionState> emit) async {
    try {
      emit(state.copyWith(saveDetailsState: ApiStatus.initial));
      await getIt<ISaveService>().setUserData(event.saveDataModel).run();
      emit(state.copyWith(
          saveDetailsState: ApiStatus.loaded,
          errorMessage: 'Caption saved successfully for ${event.saveDataModel.type}.'));
    } catch (_) {
      emit(state.copyWith(saveDetailsState: ApiStatus.error, errorMessage: 'Something went wrong.'));
    }
  }

  FutureOr<void> deleteData(DeleteDataEvent event, Emitter<GenerateDescriptionState> emit) {
    try {
      getIt<ISaveService>().deleteUserData(event.index).run();
      emit(state.copyWith(deleteDataEvent: ApiStatus.loaded, errorMessage: 'Caption deleted successfully.'));
    } catch (_) {
      emit(state.copyWith(deleteDataEvent: ApiStatus.error, errorMessage: 'Something went wrong.'));
    }
  }
}
