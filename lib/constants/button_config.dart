import 'package:flutter/material.dart' show Colors;

import '../models/button_model.dart';
import 'colors.dart';
import 'enums.dart';

class ButtonConfig {
  static List<List<CalculatorButton>> getButtonMatrix() {
    return [
      // Row 1
     [
        CalculatorButton(
          text: 'SHIFT',
          color: CalculatorColors.specialKey,
          textColor: Colors.white,
          type: ButtonType.control,
        ),
        CalculatorButton(
          text: 'ALPHA',
          color: CalculatorColors.specialKey,
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
          text: 'x⁻¹',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'nCr',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'Pol(',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'x³',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'S⇔D',
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
          text: 'log',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'ln',
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
          text: 'hyp',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.function,
        ),
        CalculatorButton(
          text: 'sin',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.trigonometric,
        ),
        CalculatorButton(
          text: 'cos',
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
          text: '(',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.operator,
        ),
        CalculatorButton(
          text: ')',
          color: CalculatorColors.functionKey,
          textColor: Colors.white,
          type: ButtonType.operator,
        ),
        CalculatorButton(
          text: 'tan',
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
          text: '7',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
        ),
        CalculatorButton(
          text: '8',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
        ),
        CalculatorButton(
          text: '9',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
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
          text: '4',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
        ),
        CalculatorButton(
          text: '5',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
        ),
        CalculatorButton(
          text: '6',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
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
          text: '1',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
        ),
        CalculatorButton(
          text: '2',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
        ),
        CalculatorButton(
          text: '3',
          color: CalculatorColors.numberKey,
          textColor: Colors.white,
          type: ButtonType.number,
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
        text: 'DEL',
        color: CalculatorColors.numberKey,
        textColor: Colors.white,
        type: ButtonType.control,
        flex: 2,
      ),
      CalculatorButton(
        text: '÷',
        color: CalculatorColors.functionKey,
        textColor: Colors.white,
        type: ButtonType.operator,
      ),
      CalculatorButton(
        text: '×',
        color: CalculatorColors.functionKey,
        textColor: Colors.white,
        type: ButtonType.operator,
      ),
      CalculatorButton(
        text: '-',
        color: CalculatorColors.functionKey,
        textColor: Colors.white,
        type: ButtonType.operator,
      ),
    ];
  }

  static List<CalculatorButton> getLastRowButtons() {
    return [
      CalculatorButton(
        text: 'AC',
        color: CalculatorColors.acKey,
        textColor: Colors.white,
        type: ButtonType.control,
        flex: 2,
      ),
      CalculatorButton(
        text: '+',
        color: CalculatorColors.functionKey,
        textColor: Colors.white,
        type: ButtonType.operator,
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
