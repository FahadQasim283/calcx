import 'package:flutter/material.dart' show Color;
import '../constants/enums.dart';

class CalculatorButton {
  final String text;
  final Color color;
  final Color textColor;
  final ButtonType type;
  final int? flex;

  CalculatorButton({
    required this.text,
    required this.color,
    required this.textColor,
    required this.type,
    this.flex = 1,
  });
}
