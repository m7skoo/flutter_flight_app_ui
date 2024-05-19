import 'package:flutter/material.dart';

class TextUtil extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final bool? weight;
  final TextOverflow overflow;

  const TextUtil({
    super.key,
    required this.text,
    this.size,
    this.color,
    this.weight,
    required this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        color: color ?? Theme.of(context).canvasColor,
        fontSize: size ?? 18,
        fontWeight: weight == null ? FontWeight.normal : FontWeight.bold,
      ),
    );
  }
}
