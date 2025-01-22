import 'package:flutter/material.dart';

class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color glowColor;

  const NeonText({
    Key? key,
    required this.text,
    this.fontSize = 24,
    this.glowColor = const Color(0xFF00A6FB),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Glow effects
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: glowColor.withOpacity(0.5),
            shadows: [
              Shadow(
                color: glowColor.withOpacity(0.5),
                blurRadius: 15,
              ),
              Shadow(
                color: glowColor.withOpacity(0.5),
                blurRadius: 30,
              ),
            ],
          ),
        ),
        // Main text
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
