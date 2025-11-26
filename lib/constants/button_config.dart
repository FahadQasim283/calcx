import 'package:flutter/material.dart' show Colors, BuildContext, Widget;
import 'package:provider/provider.dart';
import '../models/button_model.dart';
import 'colors.dart';
import 'enums.dart';
import '../providers/calculator_provider.dart';

class ButtonConfig {
  static List<List<CalculatorButton>> getButtonMatrix({
    bool shiftPressed = false,
    bool alphaPressed = false,
  }) {
    return [
      // Row 1
      [
        CalculatorButton(
          text: 'SHIFT',
          color: shiftPressed ? CalculatorColors.activeKey : CalculatorColors.specialKey,
          textColor: Colors.white,
          type: ButtonType.control,
        ),
        CalculatorButton(
          text: 'ALPHA',
          color: alphaPressed ? CalculatorColors.activeKey : CalculatorColors.specialKey,
          textColor: Colors.white,
          type: ButtonType.control,
        ),
        CalculatorButton(
          text: 'REPLAY',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.control,
        ),
        CalculatorButton(
          text: 'MODE',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.control,
        ),
        CalculatorButton(
          text: 'ON',
          color: CalculatorColors.onKey,
          textColor: Colors.white,
          type: ButtonType.control,
        ),
      ],
      // Row 2
      [
        CalculatorButton(
          text: shiftPressed ? 'x!' : 'x⁻¹',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: shiftPressed ? 'nPr' : 'nCr',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: shiftPressed ? 'Rec(' : 'Pol(',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: shiftPressed ? '∛' : 'x³',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: shiftPressed ? 'RanInt#' : 'S⇔D',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
      ],
      // Row 3
      [
        CalculatorButton(
          text: '√',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'x²',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: '^',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.operator,
        ),
        CalculatorButton(
          text: shiftPressed ? '10ˣ' : 'log',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: shiftPressed ? 'eˣ' : 'ln',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
      ],
      // Row 4
      [
        CalculatorButton(
          text: '(-)',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.operator,
        ),
        CalculatorButton(
          text: '°\'"',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: shiftPressed ? 'hyp⁻¹' : 'hyp',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: shiftPressed ? 'sin⁻¹' : 'sin',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.trigonometric,
        ),
        CalculatorButton(
          text: shiftPressed ? 'cos⁻¹' : 'cos',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.trigonometric,
        ),
      ],
      // Row 5
      [
        CalculatorButton(
          text: 'RCL',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.memory,
        ),
        CalculatorButton(
          text: 'ENG',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: shiftPressed ? 'π' : '(',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: shiftPressed ? ButtonType.special : ButtonType.operator,
        ),
        CalculatorButton(
          text: shiftPressed ? 'e' : ')',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: shiftPressed ? ButtonType.special : ButtonType.operator,
        ),
        CalculatorButton(
          text: shiftPressed ? 'tan⁻¹' : 'tan',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.trigonometric,
        ),
      ],
      // Row 6
      [
        CalculatorButton(
          text: 'STO',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.memory,
        ),
        CalculatorButton(
          text: 'M+',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.memory,
        ),
        CalculatorButton(
          text: alphaPressed ? 'X' : '7',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: alphaPressed ? ButtonType.special : ButtonType.number,
        ),
        CalculatorButton(
          text: alphaPressed ? 'Y' : '8',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: alphaPressed ? ButtonType.special : ButtonType.number,
        ),
        CalculatorButton(
          text: alphaPressed ? 'Z' : '9',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: alphaPressed ? ButtonType.special : ButtonType.number,
        ),
      ],
      // Row 7
      [
        CalculatorButton(
          text: 'CALC',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'SOLVE',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: alphaPressed ? 'M' : '4',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: alphaPressed ? ButtonType.special : ButtonType.number,
        ),
        CalculatorButton(
          text: alphaPressed ? 'N' : '5',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: alphaPressed ? ButtonType.special : ButtonType.number,
        ),
        CalculatorButton(
          text: alphaPressed ? 'P' : '6',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: alphaPressed ? ButtonType.special : ButtonType.number,
        ),
      ],
      // Row 8
      [
        CalculatorButton(
          text: '∫dx',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'MATRIX',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: alphaPressed ? 'A' : '1',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: alphaPressed ? ButtonType.special : ButtonType.number,
        ),
        CalculatorButton(
          text: alphaPressed ? 'B' : '2',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: alphaPressed ? ButtonType.special : ButtonType.number,
        ),
        CalculatorButton(
          text: alphaPressed ? 'C' : '3',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: alphaPressed ? ButtonType.special : ButtonType.number,
        ),
      ],
      // Row 9
      [
        CalculatorButton(
          text: 'RAN#',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'DT',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: '0',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
        ),
        CalculatorButton(
          text: '.',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.operator,
        ),
        CalculatorButton(
          text: '×10ˣ',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
      ],
    ];
  }

  static List<CalculatorButton> getBottomRowButtons() {
    return [
      CalculatorButton(
        text: '÷',
        color: CalculatorColors.operatorKey,
        textColor: Colors.white,
        type: ButtonType.operator,
        flex: 1,
      ),
      CalculatorButton(
        text: '×',
        color: CalculatorColors.operatorKey,
        textColor: Colors.white,
        type: ButtonType.operator,
        flex: 1,
      ),
      CalculatorButton(
        text: '-',
        color: CalculatorColors.operatorKey,
        textColor: Colors.white,
        type: ButtonType.operator,
        flex: 1,
      ),
      CalculatorButton(
        text: '+',
        color: CalculatorColors.operatorKey,
        textColor: Colors.white,
        type: ButtonType.operator,
        flex: 1,
      ),
    ];
  }

  static List<CalculatorButton> getLastRowButtons() {
    return [
      CalculatorButton(
        text: 'AC',
        color: CalculatorColors.clearKey,
        textColor: Colors.white,
        type: ButtonType.control,
        flex: 1,
      ),
      CalculatorButton(
        text: 'DEL',
        color: CalculatorColors.clearKey,
        textColor: Colors.white,
        type: ButtonType.control,
        flex: 1,
      ),
      CalculatorButton(
        text: '=',
        color: CalculatorColors.equalsKey,
        textColor: Colors.white,
        type: ButtonType.special,
        flex: 2,
      ),
    ];
  }
}
