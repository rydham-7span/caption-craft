import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class FetchedDataScreen extends StatelessWidget {
  const FetchedDataScreen({super.key, required this.controller});

  final LiquidController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          color: Colors.black,
          child: TextButton(
            onPressed: () {
              int nextPage = controller.currentPage + 1;
              controller.animateToPage(page: nextPage);
            },
            child: const Text('Next'),
          ),
        ),
      ),
    );
  }
}
