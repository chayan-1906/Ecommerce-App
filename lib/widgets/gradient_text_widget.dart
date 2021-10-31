import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText({
    Key? key,
    required this.text,
    required this.textAlign,
    required this.gradient,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
