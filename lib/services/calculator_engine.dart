class CalculatorEngine {
  String _currentInput = '0';
  String _previousInput = '';
  String _operation = '';
  bool _isNewNumber = true;

  String get displayValue => _currentInput;

  void inputNumber(String number) {
    if (_isNewNumber) {
      _currentInput = number;
      _isNewNumber = false;
    } else {
      _currentInput = _currentInput + number;
    }
  }

  void inputDecimal() {
    if (!_currentInput.contains('.')) {
      _currentInput = _currentInput + '.';
      _isNewNumber = false;
    }
  }

  void setOperation(String operation) {
    _operation = operation;
    _previousInput = _currentInput;
    _isNewNumber = true;
  }

  void clear() {
    _currentInput = '0';
    _previousInput = '';
    _operation = '';
    _isNewNumber = true;
  }

  void delete() {
    if (_currentInput.length > 1) {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
    } else {
      _currentInput = '0';
      _isNewNumber = true;
    }
  }

  void calculate() {
    if (_previousInput.isEmpty || _operation.isEmpty) return;

    double num1 = double.parse(_previousInput);
    double num2 = double.parse(_currentInput);
    double result = 0;

    switch (_operation) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '×':
        result = num1 * num2;
        break;
      case '÷':
        if (num2 != 0) {
          result = num1 / num2;
        } else {
          _currentInput = 'Error';
          return;
        }
        break;
    }

    _currentInput = result.toString();
    _previousInput = '';
    _operation = '';
    _isNewNumber = true;
  }
}
