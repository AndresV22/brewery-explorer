import 'package:flutter/material.dart';

class AppNavigator {
  const AppNavigator._();

  static Future<void> push(BuildContext context, Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
