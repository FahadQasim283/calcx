import 'package:flutter/foundation.dart';
import '../constants/enums.dart';
import '../services/calculator_engine.dart';
import '../models/display_state_model.dart';

class CalculatorProvider with ChangeNotifier {
  final CalculatorEngine _engine = CalculatorEngine();
  DisplayState _displayState = DisplayState();
  
  DisplayState get displayState => _displayState;
  
  void handleButtonPress(String buttonText, ButtonType type) {
    switch (type) {
      case ButtonType.number:
        _engine.inputNumber(buttonText);
        break;
      case ButtonType.operator:
        if (buttonText == '.') {
          _engine.inputDecimal();
        } else {
          _engine.setOperation(buttonText);
        }
        break;
      case ButtonType.control:
        if (buttonText == 'AC') {
          _engine.clear();
        } else if (buttonText == 'DEL') {
          _engine.delete();
        }
        break;
      case ButtonType.special:
        if (buttonText == '=') {
          _engine.calculate();
        }
        break;
      default:
        // Handle other button types later
        break;
    }
    
    _updateDisplay();
  }
  
  void _updateDisplay() {
    _displayState = _displayState.copyWith(
      mainDisplay: _engine.displayValue,
    );
    notifyListeners();
  }
}