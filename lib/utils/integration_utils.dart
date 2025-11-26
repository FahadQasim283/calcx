import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

// Function type for mathematical functions
typedef MathFunction = double Function(double x);

class IntegrationUtils {
  
  // Trapezoidal rule for numerical integration
  static double trapezoidalRule(MathFunction f, double a, double b, int n) {
    if (n <= 0) throw ArgumentError('Number of intervals must be positive');
    
    double h = (b - a) / n;
    double sum = (f(a) + f(b)) / 2;
    
    for (int i = 1; i < n; i++) {
      double x = a + i * h;
      sum += f(x);
    }
    
    return h * sum;
  }
  
  // Simpson's rule for numerical integration
  static double simpsonsRule(MathFunction f, double a, double b, int n) {
    if (n <= 0 || n % 2 != 0) {
      throw ArgumentError('Number of intervals must be positive and even');
    }
    
    double h = (b - a) / n;
    double sum = f(a) + f(b);
    
    // Add odd-indexed terms (coefficient 4)
    for (int i = 1; i < n; i += 2) {
      double x = a + i * h;
      sum += 4 * f(x);
    }
    
    // Add even-indexed terms (coefficient 2)
    for (int i = 2; i < n; i += 2) {
      double x = a + i * h;
      sum += 2 * f(x);
    }
    
    return (h / 3) * sum;
  }
  
  // Adaptive Simpson's rule
  static double adaptiveSimpson(MathFunction f, double a, double b, {double tolerance = 1e-6, int maxRecursion = 15}) {
    return _adaptiveSimpsonRecursive(f, a, b, tolerance, maxRecursion, simpsonsRule(f, a, b, 2));
  }
  
  static double _adaptiveSimpsonRecursive(MathFunction f, double a, double b, double tolerance, int maxRecursion, double wholeInterval) {
    if (maxRecursion <= 0) return wholeInterval;
    
    double c = (a + b) / 2;
    double leftInterval = simpsonsRule(f, a, c, 2);
    double rightInterval = simpsonsRule(f, c, b, 2);
    double combinedInterval = leftInterval + rightInterval;
    
    if ((combinedInterval - wholeInterval).abs() <= 15 * tolerance) {
      return combinedInterval + (combinedInterval - wholeInterval) / 15;
    }
    
    return _adaptiveSimpsonRecursive(f, a, c, tolerance / 2, maxRecursion - 1, leftInterval) +
           _adaptiveSimpsonRecursive(f, c, b, tolerance / 2, maxRecursion - 1, rightInterval);
  }
  
  // Gaussian quadrature (2-point)
  static double gaussianQuadrature2(MathFunction f, double a, double b) {
    // Transform to [-1, 1] interval
    double transform(double t) => 0.5 * ((b - a) * t + (b + a));
    
    // Gauss-Legendre nodes and weights for 2-point formula
    double x1 = -1 / math.sqrt(3);
    double x2 = 1 / math.sqrt(3);
    double w1 = 1.0;
    double w2 = 1.0;
    
    double result = w1 * f(transform(x1)) + w2 * f(transform(x2));
    return 0.5 * (b - a) * result;
  }
  
  // Gaussian quadrature (3-point)
  static double gaussianQuadrature3(MathFunction f, double a, double b) {
    // Transform to [-1, 1] interval
    double transform(double t) => 0.5 * ((b - a) * t + (b + a));
    
    // Gauss-Legendre nodes and weights for 3-point formula
    double x1 = -math.sqrt(3/5);
    double x2 = 0.0;
    double x3 = math.sqrt(3/5);
    double w1 = 5/9;
    double w2 = 8/9;
    double w3 = 5/9;
    
    double result = w1 * f(transform(x1)) + w2 * f(transform(x2)) + w3 * f(transform(x3));
    return 0.5 * (b - a) * result;
  }
  
  // Monte Carlo integration
  static double monteCarloIntegration(MathFunction f, double a, double b, int n) {
    if (n <= 0) throw ArgumentError('Number of samples must be positive');
    
    math.Random random = math.Random();
    double sum = 0;
    
    for (int i = 0; i < n; i++) {
      double x = a + random.nextDouble() * (b - a);
      sum += f(x);
    }
    
    return (b - a) * sum / n;
  }
  
  // Romberg integration
  static double rombergIntegration(MathFunction f, double a, double b, int maxIterations) {
    List<List<double>> R = List.generate(maxIterations, (i) => List.filled(maxIterations, 0.0));
    
    // Initial trapezoidal approximation
    R[0][0] = 0.5 * (b - a) * (f(a) + f(b));
    
    for (int i = 1; i < maxIterations; i++) {
      // Compute R[i][0] using trapezoidal rule with 2^i intervals
      int n = math.pow(2, i).toInt();
      double h = (b - a) / n;
      double sum = 0;
      
      for (int j = 1; j < n; j += 2) {
        sum += f(a + j * h);
      }
      
      R[i][0] = 0.5 * R[i-1][0] + h * sum;
        // Compute higher order approximations
      for (int j = 1; j <= i; j++) {
        double factor = math.pow(4, j).toDouble();
        R[i][j] = (factor * R[i][j-1] - R[i-1][j-1]) / (factor - 1.0);
      }
    }
    
    return R[maxIterations-1][maxIterations-1];
  }
  
  // Integrate expression string
  static double integrateExpression(String expression, String variable, double a, double b, {int intervals = 1000}) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      
      MathFunction f = (double x) {
        ContextModel context = ContextModel();
        context.bindVariable(Variable(variable), Number(x));
        return exp.evaluate(EvaluationType.REAL, context);
      };
      
      return adaptiveSimpson(f, a, b);
    } catch (e) {
      throw ArgumentError('Error parsing or evaluating expression: $e');
    }
  }
  
  // Numerical derivative (for verification and related calculations)
  static double derivative(MathFunction f, double x, {double h = 1e-7}) {
    return (f(x + h) - f(x - h)) / (2 * h);
  }
  
  // Second derivative
  static double secondDerivative(MathFunction f, double x, {double h = 1e-5}) {
    return (f(x + h) - 2 * f(x) + f(x - h)) / (h * h);
  }
  
  // Find definite integral using multiple methods and compare
  static Map<String, double> integrateWithMethods(MathFunction f, double a, double b) {
    return {
      'trapezoidal_100': trapezoidalRule(f, a, b, 100),
      'trapezoidal_1000': trapezoidalRule(f, a, b, 1000),
      'simpson_100': simpsonsRule(f, a, b, 100),
      'simpson_1000': simpsonsRule(f, a, b, 1000),
      'adaptive_simpson': adaptiveSimpson(f, a, b),
      'gaussian_2point': gaussianQuadrature2(f, a, b),
      'gaussian_3point': gaussianQuadrature3(f, a, b),
      'monte_carlo_10000': monteCarloIntegration(f, a, b, 10000),
      'romberg': rombergIntegration(f, a, b, 8),
    };
  }
  
  // Common mathematical functions for integration
  static Map<String, MathFunction> getCommonFunctions() {
    return {
      'polynomial': (x) => x * x * x - 2 * x * x + x - 1,
      'exponential': (x) => math.exp(x),
      'logarithmic': (x) => x > 0 ? math.log(x) : double.nan,
      'trigonometric': (x) => math.sin(x) * math.cos(x),
      'sqrt': (x) => x >= 0 ? math.sqrt(x) : double.nan,
      'rational': (x) => x != 0 ? 1 / (1 + x * x) : double.infinity,
      'gaussian': (x) => math.exp(-x * x / 2) / math.sqrt(2 * math.pi),
    };
  }
  
  // Arc length calculation
  static double arcLength(MathFunction f, double a, double b, {int intervals = 1000}) {
    MathFunction arcLengthIntegrand = (double x) {
      double dy_dx = derivative(f, x);
      return math.sqrt(1 + dy_dx * dy_dx);
    };
    
    return adaptiveSimpson(arcLengthIntegrand, a, b);
  }
  
  // Surface area of revolution (around x-axis)
  static double surfaceAreaRevolution(MathFunction f, double a, double b, {int intervals = 1000}) {
    MathFunction surfaceIntegrand = (double x) {
      double y = f(x);
      double dy_dx = derivative(f, x);
      return 2 * math.pi * y * math.sqrt(1 + dy_dx * dy_dx);
    };
    
    return adaptiveSimpson(surfaceIntegrand, a, b);
  }
  
  // Volume of revolution (disk method)
  static double volumeRevolutionDisk(MathFunction f, double a, double b) {
    MathFunction volumeIntegrand = (double x) {
      double y = f(x);
      return math.pi * y * y;
    };
    
    return adaptiveSimpson(volumeIntegrand, a, b);
  }
  
  // Center of mass (centroid) x-coordinate
  static double centroidX(MathFunction f, double a, double b) {
    MathFunction xIntegrand = (double x) => x * f(x);
    MathFunction areaIntegrand = f;
    
    double numerator = adaptiveSimpson(xIntegrand, a, b);
    double denominator = adaptiveSimpson(areaIntegrand, a, b);
    
    return denominator != 0 ? numerator / denominator : 0;
  }
  
  // Center of mass (centroid) y-coordinate
  static double centroidY(MathFunction f, double a, double b) {
    MathFunction yIntegrand = (double x) {
      double y = f(x);
      return 0.5 * y * y;
    };
    MathFunction areaIntegrand = f;
    
    double numerator = adaptiveSimpson(yIntegrand, a, b);
    double denominator = adaptiveSimpson(areaIntegrand, a, b);
    
    return denominator != 0 ? numerator / denominator : 0;
  }
  
  // Error estimation for integration methods
  static double estimateError(MathFunction f, double a, double b, String method) {
    double result1, result2;
    
    switch (method.toLowerCase()) {
      case 'trapezoidal':
        result1 = trapezoidalRule(f, a, b, 100);
        result2 = trapezoidalRule(f, a, b, 200);
        break;
      case 'simpson':
        result1 = simpsonsRule(f, a, b, 100);
        result2 = simpsonsRule(f, a, b, 200);
        break;
      default:
        throw ArgumentError('Unknown method: $method');
    }
    
    return (result2 - result1).abs();
  }
  
  // Format integration result
  static String formatIntegrationResult(double result, {int precision = 6}) {
    if (result.isNaN) return 'NaN';
    if (result.isInfinite) return result.isNegative ? '-∞' : '∞';
    
    return result.toStringAsFixed(precision);
  }
}
