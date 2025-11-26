import 'dart:math' as math;
import 'package:ml_dataframe/ml_dataframe.dart';

class StatisticsUtils {
  // Basic statistics
  static double mean(List<double> data) {
    if (data.isEmpty) return 0;
    return data.reduce((a, b) => a + b) / data.length;
  }
  
  static double median(List<double> data) {
    if (data.isEmpty) return 0;
    List<double> sorted = List.from(data)..sort();
    int mid = sorted.length ~/ 2;
    if (sorted.length % 2 == 0) {
      return (sorted[mid - 1] + sorted[mid]) / 2;
    }
    return sorted[mid];
  }
  
  static double mode(List<double> data) {
    if (data.isEmpty) return 0;
    
    Map<double, int> frequency = {};
    for (double value in data) {
      frequency[value] = (frequency[value] ?? 0) + 1;
    }
    
    int maxFreq = frequency.values.reduce(math.max);
    return frequency.keys.firstWhere((key) => frequency[key] == maxFreq);
  }
  
  static double range(List<double> data) {
    if (data.isEmpty) return 0;
    return data.reduce(math.max) - data.reduce(math.min);
  }
  
  static double variance(List<double> data, {bool population = false}) {
    if (data.length < 2) return 0;
    
    double m = mean(data);
    double sumSquaredDiffs = data.map((x) => math.pow(x - m, 2)).reduce((a, b) => a + b);
    
    int divisor = population ? data.length : data.length - 1;
    return sumSquaredDiffs / divisor;
  }
  
  static double standardDeviation(List<double> data, {bool population = false}) {
    return math.sqrt(variance(data, population: population));
  }
  
  static double standardError(List<double> data) {
    return standardDeviation(data) / math.sqrt(data.length);
  }
  
  // Quartiles and percentiles
  static double quartile(List<double> data, int q) {
    if (q < 1 || q > 3) throw ArgumentError('Quartile must be 1, 2, or 3');
    return percentile(data, q * 25);
  }
  
  static double percentile(List<double> data, double p) {
    if (data.isEmpty) return 0;
    if (p < 0 || p > 100) throw ArgumentError('Percentile must be between 0 and 100');
    
    List<double> sorted = List.from(data)..sort();
    double index = (p / 100) * (sorted.length - 1);
    
    if (index == index.floor()) {
      return sorted[index.toInt()];
    } else {
      int lower = index.floor();
      int upper = index.ceil();
      double weight = index - lower;
      return sorted[lower] * (1 - weight) + sorted[upper] * weight;
    }
  }
  
  static Map<String, double> fiveNumberSummary(List<double> data) {
    return {
      'min': data.reduce(math.min),
      'q1': quartile(data, 1),
      'median': median(data),
      'q3': quartile(data, 3),
      'max': data.reduce(math.max),
    };
  }
  
  // Correlation and regression
  static double correlation(List<double> x, List<double> y) {
    if (x.length != y.length || x.length < 2) {
      throw ArgumentError('Lists must have same length and at least 2 elements');
    }
    
    double meanX = mean(x);
    double meanY = mean(y);
    
    double numerator = 0;
    double sumXSquared = 0;
    double sumYSquared = 0;
    
    for (int i = 0; i < x.length; i++) {
      double deltaX = x[i] - meanX;
      double deltaY = y[i] - meanY;
      
      numerator += deltaX * deltaY;
      sumXSquared += deltaX * deltaX;
      sumYSquared += deltaY * deltaY;
    }
    
    double denominator = math.sqrt(sumXSquared * sumYSquared);
    return denominator == 0 ? 0 : numerator / denominator;
  }
  
  static Map<String, double> linearRegression(List<double> x, List<double> y) {
    if (x.length != y.length || x.length < 2) {
      throw ArgumentError('Lists must have same length and at least 2 elements');
    }
    
    double meanX = mean(x);
    double meanY = mean(y);
    
    double numerator = 0;
    double denominator = 0;
    
    for (int i = 0; i < x.length; i++) {
      double deltaX = x[i] - meanX;
      numerator += deltaX * (y[i] - meanY);
      denominator += deltaX * deltaX;
    }
    
    double slope = denominator == 0 ? 0 : numerator / denominator;
    double intercept = meanY - slope * meanX;
    
    // Calculate R-squared
    double rValue = correlation(x, y);
    double rSquared = rValue * rValue;
    
    return {
      'slope': slope,
      'intercept': intercept,
      'correlation': rValue,
      'r_squared': rSquared,
    };
  }
  
  // Distribution functions
  static double normalPDF(double x, double mean, double stdDev) {
    double coefficient = 1 / (stdDev * math.sqrt(2 * math.pi));
    double exponent = -0.5 * math.pow((x - mean) / stdDev, 2);
    return coefficient * math.exp(exponent);
  }
  
  static double normalCDF(double x, double mean, double stdDev) {
    // Approximation using error function
    double z = (x - mean) / (stdDev * math.sqrt(2));
    return 0.5 * (1 + _erf(z));
  }
  
  // Error function approximation
  static double _erf(double x) {
    // Abramowitz and Stegun approximation
    const double a1 = 0.254829592;
    const double a2 = -0.284496736;
    const double a3 = 1.421413741;
    const double a4 = -1.453152027;
    const double a5 = 1.061405429;
    const double p = 0.3275911;
    
    int sign = x < 0 ? -1 : 1;
    x = x.abs();
    
    double t = 1.0 / (1.0 + p * x);
    double y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x * x);
    
    return sign * y;
  }
  
  // Student's t-distribution
  static double tPDF(double x, int degreesOfFreedom) {
    double gamma1 = _gamma((degreesOfFreedom + 1) / 2);
    double gamma2 = _gamma(degreesOfFreedom / 2);
    double coefficient = gamma1 / (math.sqrt(degreesOfFreedom * math.pi) * gamma2);
    double factor = math.pow(1 + (x * x) / degreesOfFreedom, -(degreesOfFreedom + 1) / 2);
    return coefficient * factor;
  }
  
  // Chi-square distribution
  static double chiSquarePDF(double x, int degreesOfFreedom) {
    if (x < 0) return 0;
    if (x == 0) return degreesOfFreedom == 2 ? 0.5 : 0;
    
    double coefficient = 1 / (math.pow(2, degreesOfFreedom / 2) * _gamma(degreesOfFreedom / 2));
    double factor = math.pow(x, degreesOfFreedom / 2 - 1) * math.exp(-x / 2);
    return coefficient * factor;
  }
  
  // Gamma function approximation
  static double _gamma(double x) {
    if (x == 1) return 1;
    if (x == 0.5) return math.sqrt(math.pi);
    
    // Stirling's approximation for large values
    if (x > 10) {
      return math.sqrt(2 * math.pi / x) * math.pow(x / math.e, x);
    }
    
    // Use recursion: Γ(x) = (x-1) * Γ(x-1)
    if (x > 1) {
      return (x - 1) * _gamma(x - 1);
    }
    
    // For 0 < x < 1, use Γ(x) = Γ(x+1) / x
    return _gamma(x + 1) / x;
  }
  
  // Hypothesis testing
  static Map<String, double> tTest(List<double> sample, double populationMean) {
    double sampleMean = mean(sample);
    double sampleStdDev = standardDeviation(sample);
    double standardError = sampleStdDev / math.sqrt(sample.length);
    
    double tStatistic = (sampleMean - populationMean) / standardError;
    int degreesOfFreedom = sample.length - 1;
    
    return {
      't_statistic': tStatistic,
      'degrees_of_freedom': degreesOfFreedom.toDouble(),
      'sample_mean': sampleMean,
      'standard_error': standardError,
    };
  }
  
  static Map<String, double> tTestTwoSample(List<double> sample1, List<double> sample2) {
    double mean1 = mean(sample1);
    double mean2 = mean(sample2);
    double var1 = variance(sample1);
    double var2 = variance(sample2);
    
    // Pooled variance
    double pooledVariance = ((sample1.length - 1) * var1 + (sample2.length - 1) * var2) /
        (sample1.length + sample2.length - 2);
    
    double standardError = math.sqrt(pooledVariance * (1 / sample1.length + 1 / sample2.length));
    double tStatistic = (mean1 - mean2) / standardError;
    int degreesOfFreedom = sample1.length + sample2.length - 2;
    
    return {
      't_statistic': tStatistic,
      'degrees_of_freedom': degreesOfFreedom.toDouble(),
      'mean_difference': mean1 - mean2,
      'standard_error': standardError,
    };
  }
  
  // Frequency analysis
  static Map<double, int> frequencyTable(List<double> data) {
    Map<double, int> frequency = {};
    for (double value in data) {
      frequency[value] = (frequency[value] ?? 0) + 1;
    }
    return frequency;
  }
  
  static Map<String, int> histogram(List<double> data, int bins) {
    if (data.isEmpty || bins <= 0) return {};
    
    double min = data.reduce(math.min);
    double max = data.reduce(math.max);
    double binWidth = (max - min) / bins;
    
    Map<String, int> histogram = {};
    
    for (int i = 0; i < bins; i++) {
      double binStart = min + i * binWidth;
      double binEnd = binStart + binWidth;
      String binLabel = '${binStart.toStringAsFixed(2)}-${binEnd.toStringAsFixed(2)}';
      histogram[binLabel] = 0;
    }
    
    for (double value in data) {
      int binIndex = ((value - min) / binWidth).floor();
      if (binIndex >= bins) binIndex = bins - 1; // Handle max value
      
      double binStart = min + binIndex * binWidth;
      double binEnd = binStart + binWidth;
      String binLabel = '${binStart.toStringAsFixed(2)}-${binEnd.toStringAsFixed(2)}';
      histogram[binLabel] = (histogram[binLabel] ?? 0) + 1;
    }
    
    return histogram;
  }
  
  // Outlier detection
  static List<double> findOutliers(List<double> data) {
    Map<String, double> summary = fiveNumberSummary(data);
    double q1 = summary['q1']!;
    double q3 = summary['q3']!;
    double iqr = q3 - q1;
    
    double lowerBound = q1 - 1.5 * iqr;
    double upperBound = q3 + 1.5 * iqr;
    
    return data.where((value) => value < lowerBound || value > upperBound).toList();
  }
  
  // Z-score calculation
  static List<double> zScores(List<double> data) {
    double m = mean(data);
    double sd = standardDeviation(data);
    
    return data.map((value) => (value - m) / sd).toList();
  }
  
  // Coefficient of variation
  static double coefficientOfVariation(List<double> data) {
    double m = mean(data);
    if (m == 0) return double.infinity;
    return standardDeviation(data) / m;
  }
  
  // Skewness
  static double skewness(List<double> data) {
    if (data.length < 3) return 0;
    
    double m = mean(data);
    double sd = standardDeviation(data);
    
    double sumCubed = data.map((x) => math.pow((x - m) / sd, 3)).reduce((a, b) => a + b);
    return sumCubed / data.length;
  }
  
  // Kurtosis
  static double kurtosis(List<double> data) {
    if (data.length < 4) return 0;
    
    double m = mean(data);
    double sd = standardDeviation(data);
    
    double sumFourth = data.map((x) => math.pow((x - m) / sd, 4)).reduce((a, b) => a + b);
    return (sumFourth / data.length) - 3; // Excess kurtosis
  }
  
  // Format statistics report
  static String formatStatisticsReport(List<double> data) {
    if (data.isEmpty) return 'No data available';
    
    StringBuffer report = StringBuffer();
    report.writeln('Statistical Summary:');
    report.writeln('n = ${data.length}');
    report.writeln('Mean = ${mean(data).toStringAsFixed(4)}');
    report.writeln('Median = ${median(data).toStringAsFixed(4)}');
    report.writeln('Mode = ${mode(data).toStringAsFixed(4)}');
    report.writeln('Standard Deviation = ${standardDeviation(data).toStringAsFixed(4)}');
    report.writeln('Variance = ${variance(data).toStringAsFixed(4)}');
    report.writeln('Range = ${range(data).toStringAsFixed(4)}');
    
    Map<String, double> summary = fiveNumberSummary(data);
    report.writeln('Five Number Summary:');
    report.writeln('  Min = ${summary['min']!.toStringAsFixed(4)}');
    report.writeln('  Q1 = ${summary['q1']!.toStringAsFixed(4)}');
    report.writeln('  Median = ${summary['median']!.toStringAsFixed(4)}');
    report.writeln('  Q3 = ${summary['q3']!.toStringAsFixed(4)}');
    report.writeln('  Max = ${summary['max']!.toStringAsFixed(4)}');
    
    report.writeln('Skewness = ${skewness(data).toStringAsFixed(4)}');
    report.writeln('Kurtosis = ${kurtosis(data).toStringAsFixed(4)}');
    
    List<double> outliers = findOutliers(data);
    if (outliers.isNotEmpty) {
      report.writeln('Outliers: ${outliers.map((x) => x.toStringAsFixed(4)).join(', ')}');
    }
    
    return report.toString();
  }
}
