import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';
import 'package:rational/rational.dart';
import '../constants/enums.dart';

class CalculatorEngine {
  String _expression = '';
  String _result = '0';
  bool _isRadianMode = true;
  int _cursorPosition = 0;
  
  // Memory operations
  double _memoryValue = 0.0;
  bool _memoryHasValue = false;
  
  // Advanced mode support
  CalculatorMode _currentMode = CalculatorMode.normal;
  bool _fractionMode = false;
  bool _complexMode = false;
  
  // Fraction storage for fraction mode
  Rational? _currentFraction;
  
  // Getters
  String get displayExpression => _expression;
  String get displayResult => _result;
  String get displayValue => _expression.isEmpty ? _result : _expression;
  bool get isRadianMode => _isRadianMode;
  int get cursorPosition => _cursorPosition;
  bool get memoryHasValue => _memoryHasValue;
  bool get fractionMode => _fractionMode;
  bool get complexMode => _complexMode;
  CalculatorMode get currentMode => _currentMode;
  
  void addToExpression(String value) {
    // Insert at cursor position
    String before = _expression.substring(0, _cursorPosition);
    String after = _expression.substring(_cursorPosition);
    _expression = before + value + after;
    _cursorPosition += value.length;
    _evaluateExpression();
  }
  
  void inputNumber(String number) {
    addToExpression(number);
  }
  
  void inputDecimal() {
    addToExpression('.');
  }
  
  void setOperation(String operation) {
    addToExpression(operation);
  }
  
  void insertConstant(String constant) {
    addToExpression(constant);
  }
  
  void performScientificFunction(String function) {
    // For functions that wrap the current number
    String functionCall = function + '(';
    addToExpression(functionCall);
  }
  
  void clear() {
    _expression = '';
    _result = '0';
    _cursorPosition = 0;
  }
  
  void deleteLast() {
    if (_expression.isNotEmpty && _cursorPosition > 0) {
      String before = _expression.substring(0, _cursorPosition - 1);
      String after = _expression.substring(_cursorPosition);
      _expression = before + after;
      _cursorPosition = math.max(0, _cursorPosition - 1);
      _evaluateExpression();
    }
  }
  
  void setCursorPosition(int position) {
    _cursorPosition = math.max(0, math.min(position, _expression.length));
  }
  
  void moveCursorLeft() {
    if (_cursorPosition > 0) {
      _cursorPosition--;
    }
  }
  
  void moveCursorRight() {
    if (_cursorPosition < _expression.length) {
      _cursorPosition++;
    }
  }
  
  void calculate() {
    _evaluateExpression();
    if (_result != 'Error') {
      _expression = _result;
      _cursorPosition = _expression.length;
    }
  }
  
  void _evaluateExpression() {
    if (_expression.isEmpty) {
      _result = '0';
      return;
    }
    
    try {
      // Replace mathematical symbols with parseable ones
      String parseable = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', '${math.pi}')
          .replaceAll('e', '${math.e}')
          .replaceAll('sin⁻¹', 'arcsin')
          .replaceAll('cos⁻¹', 'arccos')
          .replaceAll('tan⁻¹', 'arctan')
          .replaceAll('x²', '^2')
          .replaceAll('x³', '^3')
          .replaceAll('√', 'sqrt')
          .replaceAll('∛', 'nrt')
          .replaceAll('ln', 'log')
          .replaceAll('log', 'log10');
      
      Parser parser = Parser();
      Expression exp = parser.parse(parseable);
      ContextModel cm = ContextModel();
      
      // Handle angle mode conversion
      if (!_isRadianMode) {
        // For degree mode, we'd need more sophisticated parsing
        // This is a simplified approach
      }
      
      double result = exp.evaluate(EvaluationType.REAL, cm);
      _result = _formatResult(result);
      
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void toggleAngleMode() {
    _isRadianMode = !_isRadianMode;
  }
  
  // Memory Operations
  void memoryStore() {
    try {
      double value = double.parse(_result);
      _memoryValue = value;
      _memoryHasValue = true;
    } catch (e) {
      // Cannot store non-numeric values
    }
  }
  
  void memoryRecall() {
    if (_memoryHasValue) {
      addToExpression(_memoryValue.toString());
    }
  }
  
  void memoryAdd() {
    if (_memoryHasValue) {
      try {
        double currentValue = double.parse(_result);
        _memoryValue += currentValue;
      } catch (e) {
        // Cannot add non-numeric values
      }
    } else {
      memoryStore();
    }
  }
  
  void memorySubtract() {
    if (_memoryHasValue) {
      try {
        double currentValue = double.parse(_result);
        _memoryValue -= currentValue;
      } catch (e) {
        // Cannot subtract non-numeric values
      }
    } else {
      try {
        double currentValue = double.parse(_result);
        _memoryValue = -currentValue;
        _memoryHasValue = true;
      } catch (e) {
        // Cannot store non-numeric values
      }
    }
  }
  
  void memoryClear() {
    _memoryValue = 0.0;
    _memoryHasValue = false;
  }
  
  // Mode Operations
  void setMode(CalculatorMode mode) {
    _currentMode = mode;
  }
  
  void toggleFractionMode() {
    _fractionMode = !_fractionMode;
  }
  
  void toggleComplexMode() {
    _complexMode = !_complexMode;
  }
  
  // Fraction Operations
  void addFraction(int numerator, int denominator) {
    if (_fractionMode) {
      _currentFraction = Rational(BigInt.from(numerator), BigInt.from(denominator));
      addToExpression(_formatFraction(_currentFraction!));
    }
  }
  
  void convertToFraction() {
    try {
      double value = double.parse(_result);
      // Convert decimal to fraction using a simple approach
      String valueStr = value.toString();
      if (valueStr.contains('.')) {
        List<String> parts = valueStr.split('.');
        int denominator = math.pow(10, parts[1].length).toInt();
        int numerator = (value * denominator).round();
        _currentFraction = Rational(BigInt.from(numerator), BigInt.from(denominator));
      } else {
        _currentFraction = Rational(BigInt.from(value.toInt()));
      }
      _result = _formatFraction(_currentFraction!);
    } catch (e) {
      // Cannot convert to fraction
    }
  }
  
  String _formatFraction(Rational fraction) {
    if (fraction.denominator == 1) {
      return fraction.numerator.toString();
    }
    return '${fraction.numerator}/${fraction.denominator}';
  }
  
  // Enhanced calculation with package support
  void calculateWithPackages() {
    if (_fractionMode) {
      _calculateFraction();
    } else if (_complexMode) {
      _calculateComplex();
    } else {
      calculate();
    }
  }
  
  void _calculateFraction() {
    // Enhanced fraction calculation using rational package
    try {
      if (_currentFraction != null) {
        _result = _formatFraction(_currentFraction!);
      } else {
        // Try to convert current result to fraction
        convertToFraction();
      }
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void _calculateComplex() {
    // Complex number calculation - basic implementation
    try {
      // For now, just indicate complex mode is active
      if (_expression.contains('i') || _expression.contains('j')) {
        // Basic complex number parsing - can be enhanced
        _result = 'Complex mode active';
      } else {
        calculate(); // Fall back to regular calculation
      }
    } catch (e) {
      _result = 'Error';
    }
  }
  
  // Advanced mathematical functions
  void performStatisticalFunction(String function, List<double> data) {
    try {
      switch (function) {
        case 'mean':
          double mean = data.reduce((a, b) => a + b) / data.length;
          _result = _formatResult(mean);
          break;
        case 'std':
          double mean = data.reduce((a, b) => a + b) / data.length;
          double variance = data.map((x) => math.pow(x - mean, 2)).reduce((a, b) => a + b) / data.length;
          _result = _formatResult(math.sqrt(variance));
          break;
        case 'sum':
          double sum = data.reduce((a, b) => a + b);
          _result = _formatResult(sum);
          break;
        default:
          _result = 'Error';
      }
    } catch (e) {
      _result = 'Error';
    }
  }
  
  // Factorial function for improved mathematical operations
  void calculateFactorial() {
    try {
      double value = double.parse(_result);
      if (value < 0 || value != value.floor()) {
        _result = 'Error';
        return;
      }
      
      int n = value.toInt();
      if (n > 170) { // Prevent overflow
        _result = 'Error';
        return;
      }
      
      double factorial = 1;
      for (int i = 2; i <= n; i++) {
        factorial *= i;
      }
      _result = _formatResult(factorial);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  String _formatResult(double result) {
    // Handle special cases
    if (result.isNaN) return 'Error';
    if (result.isInfinite) return 'Error';
    if (result.abs() < 1e-10) return '0';
    
    // Scientific notation for very large or small numbers
    if (result.abs() >= 1e10 || (result.abs() < 1e-4 && result != 0)) {
      return result.toStringAsExponential(6);
    }
    
    // Regular formatting
    String formatted = result.toString();
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }
    return formatted;
  }
}
