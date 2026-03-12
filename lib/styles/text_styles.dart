import 'package:flutter/material.dart';

class HololiveTextStyles extends StatelessWidget {
  const HololiveTextStyles(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }
}