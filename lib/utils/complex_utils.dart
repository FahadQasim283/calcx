import 'dart:math' as math;
import 'package:complex/complex.dart';

class ComplexUtils {
  // Create complex number from real and imaginary parts
  static Complex createComplex(double real, double imaginary) {
    return Complex(real, imaginary);
  }
  
  // Create complex number from magnitude and phase (polar form)
  static Complex fromPolar(double magnitude, double phase) {
    double real = magnitude * math.cos(phase);
    double imaginary = magnitude * math.sin(phase);
    return Complex(real, imaginary);
  }  // Convert complex number to polar form
  static Map<String, double> toPolar(Complex c) {
    double magnitude = c.abs();
    double phase = c.argument();
    return {
      'magnitude': magnitude,
      'phase': phase,
    };
  }
  
  // Complex addition
  static Complex add(Complex a, Complex b) {
    return a + b;
  }
  
  // Complex subtraction
  static Complex subtract(Complex a, Complex b) {
    return a - b;
  }
  
  // Complex multiplication
  static Complex multiply(Complex a, Complex b) {
    return a * b;
  }
    // Complex division
  static Complex divide(Complex a, Complex b) {
    if (b.abs() == 0) {
      throw ArgumentError('Division by zero complex number');
    }
    return a / b;
  }
  
  // Complex conjugate
  static Complex conjugate(Complex c) {
    return c.conjugate();
  }
  
  // Complex modulus (absolute value)
  static double modulus(Complex c) {
    return c.abs();
  }
    // Complex argument (phase angle)
  static double argument(Complex c) {
    return c.argument();
  }
  
  // Complex power
  static Complex power(Complex base, Complex exponent) {
    // z^w = e^(w * ln(z))
    if (base.abs() == 0) {
      if (exponent.real > 0) return Complex.zero;
      throw ArgumentError('0^0 or 0^negative is undefined');
    }
    
    Complex ln_base = logarithm(base);
    Complex exp_arg = multiply(exponent, ln_base);
    return exponential(exp_arg);
  }
  
  // Complex exponential (e^z)
  static Complex exponential(Complex c) {
    double exp_real = math.exp(c.real);
    return Complex(
      exp_real * math.cos(c.imaginary),
      exp_real * math.sin(c.imaginary),
    );
  }
  
  // Complex natural logarithm
  static Complex logarithm(Complex c) {
    if (c.abs() == 0) {
      throw ArgumentError('Logarithm of zero is undefined');
    }
    
    double magnitude = c.abs();
    double phase = c.argument;
    
    return Complex(math.log(magnitude), phase);
  }
  
  // Complex logarithm with custom base
  static Complex logarithmBase(Complex c, Complex base) {
    return divide(logarithm(c), logarithm(base));
  }
  
  // Complex square root
  static Complex sqrt(Complex c) {
    double magnitude = math.sqrt(c.abs());
    double phase = c.argument / 2;
    
    return fromPolar(magnitude, phase);
  }
  
  // Complex nth root
  static List<Complex> nthRoot(Complex c, int n) {
    if (n <= 0) {
      throw ArgumentError('Root order must be positive');
    }
    
    if (c.abs() == 0) {
      return [Complex.zero];
    }
    
    double magnitude = math.pow(c.abs(), 1.0 / n);
    double basePhase = c.argument / n;
    
    List<Complex> roots = [];
    for (int k = 0; k < n; k++) {
      double phase = basePhase + (2 * math.pi * k) / n;
      roots.add(fromPolar(magnitude, phase));
    }
    
    return roots;
  }
  
  // Complex sine
  static Complex sin(Complex c) {
    // sin(z) = (e^(iz) - e^(-iz)) / (2i)
    Complex iz = multiply(Complex.i, c);
    Complex exp_iz = exponential(iz);
    Complex exp_neg_iz = exponential(multiply(Complex(-1, 0), iz));
    
    Complex numerator = subtract(exp_iz, exp_neg_iz);
    Complex denominator = Complex(0, 2);
    
    return divide(numerator, denominator);
  }
  
  // Complex cosine
  static Complex cos(Complex c) {
    // cos(z) = (e^(iz) + e^(-iz)) / 2
    Complex iz = multiply(Complex.i, c);
    Complex exp_iz = exponential(iz);
    Complex exp_neg_iz = exponential(multiply(Complex(-1, 0), iz));
    
    Complex numerator = add(exp_iz, exp_neg_iz);
    Complex denominator = Complex(2, 0);
    
    return divide(numerator, denominator);
  }
  
  // Complex tangent
  static Complex tan(Complex c) {
    return divide(sin(c), cos(c));
  }
  
  // Complex hyperbolic sine
  static Complex sinh(Complex c) {
    // sinh(z) = (e^z - e^(-z)) / 2
    Complex exp_z = exponential(c);
    Complex exp_neg_z = exponential(multiply(Complex(-1, 0), c));
    
    Complex numerator = subtract(exp_z, exp_neg_z);
    Complex denominator = Complex(2, 0);
    
    return divide(numerator, denominator);
  }
  
  // Complex hyperbolic cosine
  static Complex cosh(Complex c) {
    // cosh(z) = (e^z + e^(-z)) / 2
    Complex exp_z = exponential(c);
    Complex exp_neg_z = exponential(multiply(Complex(-1, 0), c));
    
    Complex numerator = add(exp_z, exp_neg_z);
    Complex denominator = Complex(2, 0);
    
    return divide(numerator, denominator);
  }
  
  // Complex hyperbolic tangent
  static Complex tanh(Complex c) {
    return divide(sinh(c), cosh(c));
  }
  
  // Format complex number as string
  static String complexToString(Complex c, {int precision = 6}) {
    double real = c.real;
    double imag = c.imaginary;
    
    if (imag == 0) {
      return real.toStringAsFixed(precision);
    } else if (real == 0) {
      if (imag == 1) return 'i';
      if (imag == -1) return '-i';
      return '${imag.toStringAsFixed(precision)}i';
    } else {
      String realPart = real.toStringAsFixed(precision);
      String imagPart = imag.abs().toStringAsFixed(precision);
      String sign = imag >= 0 ? '+' : '-';
      
      if (imag.abs() == 1) {
        return '$realPart${sign}i';
      } else {
        return '$realPart$sign${imagPart}i';
      }
    }
  }
  
  // Parse string to complex number
  static Complex? parseComplex(String input) {
    try {
      input = input.trim().replaceAll(' ', '');
      
      // Handle pure real numbers
      if (!input.contains('i')) {
        return Complex(double.parse(input), 0);
      }
      
      // Handle pure imaginary numbers
      if (input == 'i') return Complex.i;
      if (input == '-i') return Complex(0, -1);
      
      // Handle imaginary numbers without real part
      if (input.endsWith('i') && !input.contains('+') && !input.contains('-', 1)) {
        String imagStr = input.substring(0, input.length - 1);
        if (imagStr.isEmpty) return Complex.i;
        return Complex(0, double.parse(imagStr));
      }
      
      // Handle complex numbers with both real and imaginary parts
      double real = 0;
      double imag = 0;
      
      // Find the position of + or - that separates real and imaginary parts
      int splitPos = -1;
      for (int i = 1; i < input.length; i++) {
        if (input[i] == '+' || input[i] == '-') {
          splitPos = i;
          break;
        }
      }
      
      if (splitPos != -1) {
        String realPart = input.substring(0, splitPos);
        String imagPart = input.substring(splitPos);
        
        real = double.parse(realPart);
        
        // Process imaginary part
        imagPart = imagPart.replaceAll('i', '');
        if (imagPart == '+') {
          imag = 1;
        } else if (imagPart == '-') {
          imag = -1;
        } else {
          imag = double.parse(imagPart);
        }
      }
      
      return Complex(real, imag);
    } catch (e) {
      return null;
    }
  }
  
  // Convert complex number to rectangular form string
  static String toRectangular(Complex c, {int precision = 6}) {
    return complexToString(c, precision: precision);
  }
  
  // Convert complex number to polar form string
  static String toPolarString(Complex c, {int precision = 6, bool degrees = false}) {
    double magnitude = c.abs();
    double phase = c.argument;
    
    if (degrees) {
      phase = phase * 180 / math.pi;
    }
    
    return '${magnitude.toStringAsFixed(precision)}∠${phase.toStringAsFixed(precision)}${degrees ? '°' : ''}';
  }
  
  // Convert complex number to exponential form string
  static String toExponential(Complex c, {int precision = 6}) {
    double magnitude = c.abs();
    double phase = c.argument;
    
    if (magnitude == 0) return '0';
    if (phase == 0) return magnitude.toStringAsFixed(precision);
    
    return '${magnitude.toStringAsFixed(precision)}e^(${phase.toStringAsFixed(precision)}i)';
  }
  
  // Check if complex number is real
  static bool isReal(Complex c) {
    return c.imaginary == 0;
  }
  
  // Check if complex number is imaginary
  static bool isPureImaginary(Complex c) {
    return c.real == 0 && c.imaginary != 0;
  }
  
  // Check if complex number is zero
  static bool isZero(Complex c) {
    return c.real == 0 && c.imaginary == 0;
  }
}
