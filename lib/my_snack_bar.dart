import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
MySnackBar(
    {required BuildContext context,
    required String message,
    isWarning = false,
    label,
    onPress,
    duration}) {
  final snackBar = SnackBar(
    action: SnackBarAction(label: label ?? "بستن", onPressed: onPress ?? () {}),
    duration: duration ?? const Duration(seconds: 3),
    content: Text(
      message,
      style: const TextStyle(fontFamily: 'Yekan'),
    ),
    backgroundColor: isWarning ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
