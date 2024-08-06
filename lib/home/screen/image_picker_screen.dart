import 'package:caption_this/home/bloc/generate_description_bloc.dart';
import 'package:caption_this/home/screen/saved_data_screen.dart';
import 'package:caption_this/splash/onboarding_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                                child: (state.image != null) && (state.image?.isNotEmpty ?? false)
                                    ? Image.memory(
                                            state.image ?? Uint8List(0),
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
                        (state.image != null) && (state.image?.isNotEmpty ?? false)
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
                    (state.image != null) && (state.image?.isNotEmpty ?? false)
                        ? ElevatedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SavedDataScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          side: const BorderSide(color: Colors.deepPurple, width: 4),
                        ),
                        child: const Text(
                          'View Saved',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Row(
                        children: [
                          const Text(
                            'Want to read the steps again?',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen(),));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Click here',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
