import 'package:caption_this/constants/enum.dart';
import 'package:caption_this/home/bloc/generate_description_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
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
      body: SafeArea(
        child: BlocConsumer<GenerateDescriptionBloc, GenerateDescriptionState>(
          listener: (context, state) {
            if (state.selectImageState == ApiStatus.loaded) {
              Future.delayed(const Duration(seconds: 1)).then(
                (value) {
                  int nextPage = controller.currentPage + 1;
                  controller.animateToPage(page: nextPage);
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
                padding: const EdgeInsets.only(left: 30, right: 40, bottom: 20, top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'STEP : 1',
                        style: TextStyle(fontSize: 54, fontFamily: 'Danfo'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Upload an image',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DottedBorder(
                          strokeWidth: 2,
                          dashPattern: const [8],
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
                                    height: 260,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(
                                    width: double.infinity,
                                    height: 260,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.photo,
                                          size: 45,
                                          color: Colors.deepPurple,
                                        ),
                                        Text(
                                          'Select an Image',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
