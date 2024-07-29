import 'dart:io';

import 'package:caption_this/constants/enum.dart';
import 'package:caption_this/home/bloc/generate_description_bloc.dart';
import 'package:caption_this/home/screen/fetched_data_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key, required this.controller});

  final LiquidController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocConsumer<GenerateDescriptionBloc, GenerateDescriptionState>(
            listener: (context, state) {
              if (state.selectImageState == ApiStatus.loaded) {
                Future.delayed(const Duration(seconds: 1)).then(
                  (value) {
                    int nextPage = controller.currentPage + 1;
                    controller.animateToPage(page: nextPage);
                    context.read<GenerateDescriptionBloc>().add(GeneratePostsEvent(image: state.image ?? File('')));
                  },
                );
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  context.read<GenerateDescriptionBloc>().add(SelectAnImageEvent());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      Text(state.response ?? ''),
                      DottedBorder(
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(6),
                        color: Colors.deepPurple,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: state.image != null
                              ? Image.file(
                                  state.image!,
                                  width: double.infinity,
                                  fit: BoxFit.fitHeight,
                                )
                              : const SizedBox(
                                  width: double.infinity,
                                  height: 255,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        size: 45,
                                        color: Colors.deepPurple,
                                      ),
                                      Text(
                                        'Upload an Image',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
