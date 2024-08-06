import 'package:flutter/material.dart';

SnackBar customSnackBar({
  required String message,
  required BuildContext context,
  Duration? time,
  bool? isDismissAble,
}) {
  return SnackBar(
    margin: const EdgeInsets.only(
      bottom: 10,
      left: 10,
      right: 10,
    ),
    dismissDirection: (isDismissAble ?? true) ? DismissDirection.vertical : DismissDirection.none,
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    ),
    duration: time ?? const Duration(milliseconds: 800),
    padding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 20,
    ),
    backgroundColor: Colors.deepPurple,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
