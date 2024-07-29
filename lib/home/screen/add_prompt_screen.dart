import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class AddPromptScreen extends StatelessWidget {
  const AddPromptScreen({super.key, required this.controller});
  final LiquidController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Container(
          child: TextButton(
            onPressed: () {
              int nextPage = controller.currentPage + 1;
              controller.animateToPage(page: nextPage);
            },
            child: Text('Next'),
          ),
        ),
      ),
    );
  }
}
