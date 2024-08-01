import 'package:caption_this/home/bloc/generate_description_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 50, bottom: 20, top: 20),
        child: SafeArea(
          child: BlocConsumer<GenerateDescriptionBloc, GenerateDescriptionState>(
            listener: (context, state) {},
            buildWhen: (previous, current) => previous.image != current.image,
            builder: (context, state) {
              return SingleChildScrollView(
                clipBehavior: Clip.none,
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
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              context.read<GenerateDescriptionBloc>().add(SelectAnImageEvent());
                            },
                            child: DottedBorder(
                              strokeWidth: 2,
                              dashPattern: const [8],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(6),
                              color: Colors.deepPurple,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child: (state.image != null) && (state.image?.path != '')
                                    ? kIsWeb
                                        ? Image.network(state.image!.path)
                                        : Image.file(
                                            state.image!,
                                            width: double.infinity,
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
                        ),
                        (state.image != null) && (state.image?.path != '')
                            ? Positioned(
                                top: -15,
                                right: -15,
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<GenerateDescriptionBloc>().add(RemoveImageEvent());
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      border: const Border(
                                        bottom: BorderSide(color: Colors.deepPurple, width: 1),
                                        left: BorderSide(color: Colors.deepPurple, width: 1),
                                      ),
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      size: 35,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    (state.image != null) && (state.image?.path != '')
                        ? ElevatedButton(
                            onPressed: () {
                              int nextPage = controller.currentPage + 1;
                              controller.animateToPage(page: nextPage);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(46),
                              backgroundColor: Colors.deepPurple,
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
