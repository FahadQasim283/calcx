import 'package:flutter/material.dart' show debugPrint;
import '../constants/enums.dart';
import '../models/display_state_model.dart';

class CalculatorLogic {
  static void handleButtonPress(
    String buttonText,
    ButtonType type,
    Function(DisplayState) updateDisplay,
  ) {
    switch (type) {
      case ButtonType.number:
        _handleNumber(buttonText, updateDisplay);
        break;
      case ButtonType.operator:
        _handleOperator(buttonText, updateDisplay);
        break;
      case ButtonType.function:
        _handleFunction(buttonText, updateDisplay);
        break;
      case ButtonType.trigonometric:
        _handleTrigonometric(buttonText, updateDisplay);
        break;
      case ButtonType.memory:
        _handleMemory(buttonText, updateDisplay);
        break;
      case ButtonType.control:
        _handleControl(buttonText, updateDisplay);
        break;
      case ButtonType.special:
        _handleSpecial(buttonText, updateDisplay);
        break;
    }
  }

  static void _handleNumber(String number, Function(DisplayState) updateDisplay) {
    debugPrint('Number pressed: $number');
  }

  static void _handleOperator(String operator, Function(DisplayState) updateDisplay) {
    debugPrint('Operator pressed: $operator');
  }

  static void _handleFunction(String function, Function(DisplayState) updateDisplay) {
    debugPrint('Function pressed: $function');
  }

  static void _handleTrigonometric(String trigFunction, Function(DisplayState) updateDisplay) {
    debugPrint('Trigonometric function pressed: $trigFunction');
  }

  static void _handleMemory(String memoryOp, Function(DisplayState) updateDisplay) {
    debugPrint('Memory operation pressed: $memoryOp');
  }

  static void _handleControl(String control, Function(DisplayState) updateDisplay) {
    debugPrint('Control pressed: $control');
    if (control == 'AC') {
      updateDisplay(DisplayState());
    }
  }

  static void _handleSpecial(String special, Function(DisplayState) updateDisplay) {
    debugPrint('Special operation pressed: $special');
  }
}
