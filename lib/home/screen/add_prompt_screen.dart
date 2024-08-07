import 'package:caption_this/home/bloc/generate_description_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class AddPromptScreen extends StatefulWidget {
  const AddPromptScreen({super.key, required this.controller});

  final LiquidController controller;

  @override
  State<AddPromptScreen> createState() => _AddPromptScreenState();
}

class _AddPromptScreenState extends State<AddPromptScreen> {
  final textPrompt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: BlocConsumer<GenerateDescriptionBloc, GenerateDescriptionState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(left: 30, right: 40, bottom: 20, top: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STEP : 2',
                      style: TextStyle(fontSize: 54, fontFamily: 'Danfo'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Add more details about image',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    TextFormField(
                      controller: textPrompt,
                      maxLines: 11,
                      decoration: InputDecoration(
                        hintText: 'Enter details',
                        enabledBorder: OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: BorderSide(color: Colors.white.withAlpha(150), width: 2),
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                            gapPadding: 0,
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(12)),
                        border: OutlineInputBorder(
                          gapPadding: 0,
                          borderSide: const BorderSide(color: Colors.white, width: 4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 8),
                      child: Text(
                        '(Optional to add)',
                        style: TextStyle(fontSize: 15, color: Colors.white.withAlpha(150)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.read<GenerateDescriptionBloc>().add(
                              GeneratePostsEvent(
                                image: state.image ?? Uint8List(0),
                                prompt: textPrompt.text.trim(),
                              ),
                            );
                        int nextPage = widget.controller.currentPage + 1;
                        widget.controller.animateToPage(page: nextPage);
                      },
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.maxFinite, 46)),
                      child: const Text(
                        'Generate',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Row(
                        children: [
                          const Text(
                            'Want to change image?',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              int nextPage = widget.controller.currentPage - 1;
                              widget.controller.animateToPage(page: nextPage);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Go Back',
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
