import 'dart:math' as math;
import 'package:rational/rational.dart';

class AdvancedMathUtils {
  // Combination (nCr) calculation
  static double combination(int n, int r) {
    if (r > n || r < 0) return 0;
    if (r == 0 || r == n) return 1;
    
    // Use the multiplicative formula to avoid large factorials
    double result = 1;
    for (int i = 0; i < r; i++) {
      result = result * (n - i) / (i + 1);
    }
    return result;
  }
  
  // Permutation (nPr) calculation
  static double permutation(int n, int r) {
    if (r > n || r < 0) return 0;
    if (r == 0) return 1;
    
    double result = 1;
    for (int i = 0; i < r; i++) {
      result *= (n - i);
    }
    return result;
  }
  
  // Greatest Common Divisor using Euclidean algorithm
  static int gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a.abs();
  }
  
  // Least Common Multiple
  static int lcm(int a, int b) {
    return (a * b).abs() ~/ gcd(a, b);
  }
  
  // Convert degrees to radians
  static double degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }
  
  // Convert radians to degrees
  static double radiansToDegrees(double radians) {
    return radians * 180 / math.pi;
  }
  
  // Random number generation
  static double randomNumber(double min, double max) {
    return min + math.Random().nextDouble() * (max - min);
  }
  
  // Random integer generation
  static int randomInt(int min, int max) {
    return min + math.Random().nextInt(max - min + 1);
  }
  
  // Engineering notation conversion
  static String toEngineering(double value, int precision) {
    if (value == 0) return '0E0';
    
    int exponent = (math.log(value.abs()) / math.ln10).floor();
    int engExponent = (exponent ~/ 3) * 3;
    double mantissa = value / math.pow(10, engExponent);
    
    return '${mantissa.toStringAsFixed(precision)}E$engExponent';
  }
  
  // Percentage calculations
  static double percentage(double value, double percent) {
    return value * percent / 100;
  }
  
  // Percentage change
  static double percentageChange(double oldValue, double newValue) {
    if (oldValue == 0) return double.infinity;
    return ((newValue - oldValue) / oldValue) * 100;
  }
  
  // Fraction simplification using rational package
  static Rational simplifyFraction(int numerator, int denominator) {
    return Rational(BigInt.from(numerator), BigInt.from(denominator));
  }
  
  // Convert decimal to fraction
  static Rational decimalToFraction(double decimal, {int maxDenominator = 10000}) {
    // Simple continued fraction approach
    if (decimal == decimal.floor()) {
      return Rational(BigInt.from(decimal.toInt()));
    }
    
    // For now, use a simple approach
    String decimalStr = decimal.toString();
    if (decimalStr.contains('.')) {
      List<String> parts = decimalStr.split('.');
      int denominator = math.pow(10, parts[1].length).toInt();
      int numerator = (decimal * denominator).round();
      return Rational(BigInt.from(numerator), BigInt.from(denominator));
    }
    
    return Rational(BigInt.from(decimal.toInt()));
  }
  
  // Hyperbolic functions
  static double sinh(double x) {
    return (math.exp(x) - math.exp(-x)) / 2;
  }
  
  static double cosh(double x) {
    return (math.exp(x) + math.exp(-x)) / 2;
  }
  
  static double tanh(double x) {
    return sinh(x) / cosh(x);
  }
  
  // Inverse hyperbolic functions
  static double asinh(double x) {
    return math.log(x + math.sqrt(x * x + 1));
  }
  
  static double acosh(double x) {
    if (x < 1) return double.nan;
    return math.log(x + math.sqrt(x * x - 1));
  }
  
  static double atanh(double x) {
    if (x.abs() >= 1) return double.nan;
    return 0.5 * math.log((1 + x) / (1 - x));
  }
  
  // Statistical functions
  static double mean(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
  
  static double standardDeviation(List<double> values) {
    if (values.length < 2) return 0;
    double m = mean(values);
    double sum = values.map((x) => math.pow(x - m, 2)).reduce((a, b) => a + b);
    return math.sqrt(sum / (values.length - 1));
  }
  
  static double median(List<double> values) {
    if (values.isEmpty) return 0;
    List<double> sorted = List.from(values)..sort();
    int mid = sorted.length ~/ 2;
    if (sorted.length % 2 == 0) {
      return (sorted[mid - 1] + sorted[mid]) / 2;
    }
    return sorted[mid];
  }
  
  // Logarithm with custom base
  static double logBase(double value, double base) {
    return math.log(value) / math.log(base);
  }
  
  // Cube root
  static double cubeRoot(double value) {
    if (value < 0) {
      return -math.pow(-value, 1/3);
    }
    return math.pow(value, 1/3);
  }
  
  // nth root
  static double nthRoot(double value, double n) {
    if (n == 0) return double.nan;
    if (n < 0) return 1 / nthRoot(value, -n);
    if (value < 0 && n % 2 == 0) return double.nan;
    if (value < 0) return -math.pow(-value, 1/n);
    return math.pow(value, 1/n);
  }
}
