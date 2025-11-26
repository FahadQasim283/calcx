import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart' as mathexpr;
import 'package:rational/rational.dart';
import 'package:complex/complex.dart';
import '../constants/enums.dart';
import '../utils/advanced_math_utils.dart';
import '../utils/matrix_utils.dart';
import '../utils/complex_utils.dart';
import '../utils/statistics_utils.dart';
import '../utils/integration_utils.dart';
import '../utils/simple_matrix.dart';

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
          .replaceAll('log', 'log10');      mathexpr.Parser parser = mathexpr.Parser();
      mathexpr.Expression exp = parser.parse(parseable);
      mathexpr.ContextModel cm = mathexpr.ContextModel();
      
      // Handle angle mode conversion
      if (!_isRadianMode) {
        // For degree mode, we'd need more sophisticated parsing
        // This is a simplified approach
      }
      
      double result = exp.evaluate(mathexpr.EvaluationType.REAL, cm);
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
  
  // Advanced mathematical operations using AdvancedMathUtils
  void calculateCombination(int n, int r) {
    try {
      double result = AdvancedMathUtils.combination(n, r);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void calculatePermutation(int n, int r) {
    try {
      double result = AdvancedMathUtils.permutation(n, r);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void calculateGCD(int a, int b) {
    try {
      int result = AdvancedMathUtils.gcd(a, b);
      _result = result.toString();
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void calculateLCM(int a, int b) {
    try {
      int result = AdvancedMathUtils.lcm(a, b);
      _result = result.toString();
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void generateRandomNumber(double min, double max) {
    try {
      double result = AdvancedMathUtils.randomNumber(min, max);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void generateRandomInt(int min, int max) {
    try {
      int result = AdvancedMathUtils.randomInt(min, max);
      _result = result.toString();
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void convertToEngineering() {
    try {
      double value = double.parse(_result);
      _result = AdvancedMathUtils.toEngineering(value, 3);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void calculatePercentage(double percent) {
    try {
      double value = double.parse(_result);
      double result = AdvancedMathUtils.percentage(value, percent);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  // Enhanced trigonometric functions with degree/radian handling
  void calculateSin() {
    try {
      double value = double.parse(_result);
      if (!_isRadianMode) {
        value = AdvancedMathUtils.degreesToRadians(value);
      }
      double result = math.sin(value);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void calculateCos() {
    try {
      double value = double.parse(_result);
      if (!_isRadianMode) {
        value = AdvancedMathUtils.degreesToRadians(value);
      }
      double result = math.cos(value);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void calculateTan() {
    try {
      double value = double.parse(_result);
      if (!_isRadianMode) {
        value = AdvancedMathUtils.degreesToRadians(value);
      }
      double result = math.tan(value);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  // Hyperbolic functions
  void calculateSinh() {
    try {
      double value = double.parse(_result);
      double result = AdvancedMathUtils.sinh(value);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void calculateCosh() {
    try {
      double value = double.parse(_result);
      double result = AdvancedMathUtils.cosh(value);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Error';
    }
  }
  
  void calculateTanh() {
    try {
      double value = double.parse(_result);
      double result = AdvancedMathUtils.tanh(value);
      _result = _formatResult(result);
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
  
  // PHASE 4 - ADVANCED FUNCTIONS
    // Matrix Operations
  SimpleMatrix? _currentMatrix;
  List<List<double>> _matrixData = [];
    void createMatrix(List<List<double>> data) {
    try {
      _currentMatrix = SimpleMatrix(data);
      _matrixData = data;
      _result = 'Matrix ${data.length}×${data[0].length}';
    } catch (e) {
      _result = 'Matrix Error';
    }
  }
  
  void addMatrixElement(double value, int row, int col) {
    if (_matrixData.length <= row) {
      while (_matrixData.length <= row) {
        _matrixData.add([]);
      }
    }
    if (_matrixData[row].length <= col) {
      while (_matrixData[row].length <= col) {
        _matrixData[row].add(0.0);
      }
    }
    _matrixData[row][col] = value;
  }
  
  void finalizeMatrix() {
    if (_matrixData.isNotEmpty) {
      createMatrix(_matrixData);
    }
  }
  
  void matrixDeterminant() {
    if (_currentMatrix == null) {
      _result = 'No Matrix';
      return;
    }
    try {
      double det = MatrixUtils.determinant(_currentMatrix!);
      _result = _formatResult(det);
    } catch (e) {
      _result = 'Matrix Error';
    }
  }
    void matrixInverse() {
    if (_currentMatrix == null) {
      _result = 'No Matrix';
      return;
    }
    try {
      SimpleMatrix? inv = MatrixUtils.inverse(_currentMatrix!);
      if (inv == null) {
        _result = 'Singular Matrix';
      } else {
        _currentMatrix = inv;
        _result = 'Inverse Calculated';
      }
    } catch (e) {
      _result = 'Matrix Error';
    }
  }
  
  void matrixTranspose() {
    if (_currentMatrix == null) {
      _result = 'No Matrix';
      return;
    }
    try {
      _currentMatrix = MatrixUtils.transpose(_currentMatrix!);
      _result = 'Transposed';
    } catch (e) {
      _result = 'Matrix Error';
    }
  }
  
  void matrixRank() {
    if (_currentMatrix == null) {
      _result = 'No Matrix';
      return;
    }
    try {
      int rank = MatrixUtils.rank(_currentMatrix!);
      _result = rank.toString();
    } catch (e) {
      _result = 'Matrix Error';
    }
  }
  
  void matrixTrace() {
    if (_currentMatrix == null) {
      _result = 'No Matrix';
      return;
    }
    try {
      double trace = MatrixUtils.trace(_currentMatrix!);
      _result = _formatResult(trace);
    } catch (e) {
      _result = 'Matrix Error';
    }
  }
  
  String getMatrixString() {
    if (_currentMatrix == null) return 'No Matrix';
    return MatrixUtils.matrixToString(_currentMatrix!, precision: 3);
  }
    // Complex Number Operations
  Complex? _currentComplex;
  
  void createComplex(double real, double imaginary) {
    _currentComplex = ComplexUtils.createComplex(real, imaginary);
    _result = ComplexUtils.complexToString(_currentComplex!, precision: 6);
  }
  
  void complexFromPolar(double magnitude, double phase) {
    _currentComplex = ComplexUtils.fromPolar(magnitude, phase);
    _result = ComplexUtils.complexToString(_currentComplex!, precision: 6);
  }
  
  void complexAdd(Complex other) {
    if (_currentComplex == null) return;
    _currentComplex = ComplexUtils.add(_currentComplex!, other);
    _result = ComplexUtils.complexToString(_currentComplex!, precision: 6);
  }
  
  void complexMultiply(Complex other) {
    if (_currentComplex == null) return;
    _currentComplex = ComplexUtils.multiply(_currentComplex!, other);
    _result = ComplexUtils.complexToString(_currentComplex!, precision: 6);
  }
  
  void complexConjugate() {
    if (_currentComplex == null) return;
    _currentComplex = ComplexUtils.conjugate(_currentComplex!);
    _result = ComplexUtils.complexToString(_currentComplex!, precision: 6);
  }
  
  void complexModulus() {
    if (_currentComplex == null) return;
    double mod = ComplexUtils.modulus(_currentComplex!);
    _result = _formatResult(mod);
  }
  
  void complexArgument() {
    if (_currentComplex == null) return;
    double arg = ComplexUtils.argument(_currentComplex!);
    if (!_isRadianMode) {
      arg = arg * 180 / math.pi; // Convert to degrees
    }
    _result = _formatResult(arg);
  }
  
  void complexPower(Complex exponent) {
    if (_currentComplex == null) return;
    try {
      _currentComplex = ComplexUtils.power(_currentComplex!, exponent);
      _result = ComplexUtils.complexToString(_currentComplex!, precision: 6);
    } catch (e) {
      _result = 'Complex Error';
    }
  }
  
  void complexSqrt() {
    if (_currentComplex == null) return;
    _currentComplex = ComplexUtils.sqrt(_currentComplex!);
    _result = ComplexUtils.complexToString(_currentComplex!, precision: 6);
  }
  
  void complexExp() {
    if (_currentComplex == null) return;
    _currentComplex = ComplexUtils.exponential(_currentComplex!);
    _result = ComplexUtils.complexToString(_currentComplex!, precision: 6);
  }
  
  void complexLog() {
    if (_currentComplex == null) return;
    try {
      _currentComplex = ComplexUtils.logarithm(_currentComplex!);
      _result = ComplexUtils.complexToString(_currentComplex!, precision: 6);
    } catch (e) {
      _result = 'Complex Error';
    }
  }
  
  String getComplexPolar() {
    if (_currentComplex == null) return 'No Complex';
    return ComplexUtils.toPolarString(_currentComplex!, degrees: !_isRadianMode);
  }
  
  // Statistics Operations
  List<double> _statisticsData = [];
  
  void addStatisticsData(double value) {
    _statisticsData.add(value);
    _result = '${_statisticsData.length} values';
  }
  
  void clearStatisticsData() {
    _statisticsData.clear();
    _result = 'Data cleared';
  }
  
  void statisticsMean() {
    if (_statisticsData.isEmpty) {
      _result = 'No data';
      return;
    }
    double mean = StatisticsUtils.mean(_statisticsData);
    _result = _formatResult(mean);
  }
  
  void statisticsMedian() {
    if (_statisticsData.isEmpty) {
      _result = 'No data';
      return;
    }
    double median = StatisticsUtils.median(_statisticsData);
    _result = _formatResult(median);
  }
  
  void statisticsStandardDeviation() {
    if (_statisticsData.length < 2) {
      _result = 'Need 2+ values';
      return;
    }
    double sd = StatisticsUtils.standardDeviation(_statisticsData);
    _result = _formatResult(sd);
  }
  
  void statisticsVariance() {
    if (_statisticsData.length < 2) {
      _result = 'Need 2+ values';
      return;
    }
    double variance = StatisticsUtils.variance(_statisticsData);
    _result = _formatResult(variance);
  }
  
  void statisticsSum() {
    if (_statisticsData.isEmpty) {
      _result = 'No data';
      return;
    }
    double sum = _statisticsData.reduce((a, b) => a + b);
    _result = _formatResult(sum);
  }
  
  void statisticsRange() {
    if (_statisticsData.isEmpty) {
      _result = 'No data';
      return;
    }
    double range = StatisticsUtils.range(_statisticsData);
    _result = _formatResult(range);
  }
  
  void statisticsMin() {
    if (_statisticsData.isEmpty) {
      _result = 'No data';
      return;
    }
    double min = _statisticsData.reduce(math.min);
    _result = _formatResult(min);
  }
  
  void statisticsMax() {
    if (_statisticsData.isEmpty) {
      _result = 'No data';
      return;
    }
    double max = _statisticsData.reduce(math.max);
    _result = _formatResult(max);
  }
  
  void statisticsQuartile(int q) {
    if (_statisticsData.length < 4) {
      _result = 'Need 4+ values';
      return;
    }
    try {
      double quartile = StatisticsUtils.quartile(_statisticsData, q);
      _result = _formatResult(quartile);
    } catch (e) {
      _result = 'Stats Error';
    }
  }
  
  String getStatisticsReport() {
    if (_statisticsData.isEmpty) return 'No data available';
    return StatisticsUtils.formatStatisticsReport(_statisticsData);
  }
  
  // Integration Operations
  void integrateFunction(String expression, String variable, double a, double b) {
    try {
      double result = IntegrationUtils.integrateExpression(expression, variable, a, b);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Integration Error';
    }
  }    void trapezoidalIntegration(String expression, String variable, double a, double b, int intervals) {
    try {
      // Create function from expression
      mathexpr.Parser parser = mathexpr.Parser();
      mathexpr.Expression exp = parser.parse(expression);
      
      MathFunction f = (double x) {
        mathexpr.ContextModel context = mathexpr.ContextModel();
        context.bindVariable(mathexpr.Variable(variable), mathexpr.Number(x));
        return exp.evaluate(mathexpr.EvaluationType.REAL, context);
      };
      
      double result = IntegrationUtils.trapezoidalRule(f, a, b, intervals);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Integration Error';
    }
  }    void simpsonsIntegration(String expression, String variable, double a, double b, int intervals) {
    try {
      // Create function from expression
      mathexpr.Parser parser = mathexpr.Parser();
      mathexpr.Expression exp = parser.parse(expression);
      
      MathFunction f = (double x) {
        mathexpr.ContextModel context = mathexpr.ContextModel();
        context.bindVariable(mathexpr.Variable(variable), mathexpr.Number(x));
        return exp.evaluate(mathexpr.EvaluationType.REAL, context);
      };
      
      double result = IntegrationUtils.simpsonsRule(f, a, b, intervals);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Integration Error';
    }
  }    void gaussianIntegration(String expression, String variable, double a, double b) {
    try {
      // Create function from expression
      mathexpr.Parser parser = mathexpr.Parser();
      mathexpr.Expression exp = parser.parse(expression);
      
      MathFunction f = (double x) {
        mathexpr.ContextModel context = mathexpr.ContextModel();
        context.bindVariable(mathexpr.Variable(variable), mathexpr.Number(x));
        return exp.evaluate(mathexpr.EvaluationType.REAL, context);
      };
      
      double result = IntegrationUtils.gaussianQuadrature3(f, a, b);
      _result = _formatResult(result);
    } catch (e) {
      _result = 'Integration Error';
    }
  }
  
  // Mode-specific operations
  void performModeOperation(String operation) {
    switch (_currentMode) {
      case CalculatorMode.matrix:
        _performMatrixModeOperation(operation);
        break;
      case CalculatorMode.complex:
        _performComplexModeOperation(operation);
        break;
      case CalculatorMode.statistics:
        _performStatisticsModeOperation(operation);
        break;
      case CalculatorMode.normal:
      default:
        // Regular calculator operations
        break;
    }
  }
  
  void _performMatrixModeOperation(String operation) {
    switch (operation) {
      case 'det':
        matrixDeterminant();
        break;
      case 'inv':
        matrixInverse();
        break;
      case 'trans':
        matrixTranspose();
        break;
      case 'rank':
        matrixRank();
        break;
      case 'trace':
        matrixTrace();
        break;
    }
  }
  
  void _performComplexModeOperation(String operation) {
    switch (operation) {
      case 'conj':
        complexConjugate();
        break;
      case 'mod':
        complexModulus();
        break;
      case 'arg':
        complexArgument();
        break;
      case 'sqrt':
        complexSqrt();
        break;
      case 'exp':
        complexExp();
        break;
      case 'ln':
        complexLog();
        break;
    }
  }
  
  void _performStatisticsModeOperation(String operation) {
    switch (operation) {
      case 'mean':
        statisticsMean();
        break;
      case 'median':
        statisticsMedian();
        break;
      case 'std':
        statisticsStandardDeviation();
        break;
      case 'var':
        statisticsVariance();
        break;
      case 'sum':
        statisticsSum();
        break;
      case 'range':
        statisticsRange();
        break;
      case 'min':
        statisticsMin();
        break;
      case 'max':
        statisticsMax();
        break;
      case 'q1':
        statisticsQuartile(1);
        break;
      case 'q3':
        statisticsQuartile(3);
        break;
    }
  }
  
  // Helper methods for mode displays
  String getModeDisplayValue() {
    switch (_currentMode) {
      case CalculatorMode.matrix:
        return getMatrixString();
      case CalculatorMode.complex:
        return _currentComplex != null ? ComplexUtils.complexToString(_currentComplex!) : _result;
      case CalculatorMode.statistics:
        return '${_statisticsData.length} values: $_result';
      default:
        return _result;
    }
  }
  
  String getModeStatus() {
    switch (_currentMode) {
      case CalculatorMode.matrix:
        return _currentMatrix != null ? 'MAT ${_currentMatrix!.rows}×${_currentMatrix!.cols}' : 'MAT';
      case CalculatorMode.complex:
        return 'CMPLX';
      case CalculatorMode.statistics:
        return 'STAT';
      case CalculatorMode.fraction:
        return 'FRAC';
      default:
        return _isRadianMode ? 'RAD' : 'DEG';
    }
  }
}
