class SimpleMatrix {
  final List<List<double>> _data;
  final int rows;
  final int cols;
  
  SimpleMatrix(this._data) 
    : rows = _data.length,
      cols = _data.isEmpty ? 0 : _data[0].length {
    // Validate matrix dimensions
    for (int i = 0; i < rows; i++) {
      if (_data[i].length != cols) {
        throw ArgumentError('All rows must have the same number of columns');
      }
    }
  }
  
  factory SimpleMatrix.fromList(List<List<double>> data) {
    return SimpleMatrix(List.from(data.map((row) => List<double>.from(row))));
  }
  
  factory SimpleMatrix.identity(int size) {
    List<List<double>> data = List.generate(
      size, 
      (i) => List.generate(size, (j) => i == j ? 1.0 : 0.0)
    );
    return SimpleMatrix(data);
  }
  
  factory SimpleMatrix.zero(int rows, int cols) {
    List<List<double>> data = List.generate(
      rows, 
      (i) => List.generate(cols, (j) => 0.0)
    );
    return SimpleMatrix(data);
  }
  
  double operator [](int i) => _data[i ~/ cols][(i % cols)];
  
  List<double> row(int i) => List.from(_data[i]);
  
  List<double> column(int j) => _data.map((row) => row[j]).toList();
  
  double get(int i, int j) => _data[i][j];
  
  void set(int i, int j, double value) {
    _data[i][j] = value;
  }
  
  SimpleMatrix operator +(SimpleMatrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw ArgumentError('Matrices must have the same dimensions for addition');
    }
    
    List<List<double>> result = List.generate(
      rows,
      (i) => List.generate(cols, (j) => _data[i][j] + other._data[i][j])
    );
    
    return SimpleMatrix(result);
  }
  
  SimpleMatrix operator -(SimpleMatrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw ArgumentError('Matrices must have the same dimensions for subtraction');
    }
    
    List<List<double>> result = List.generate(
      rows,
      (i) => List.generate(cols, (j) => _data[i][j] - other._data[i][j])
    );
    
    return SimpleMatrix(result);
  }
  
  SimpleMatrix operator *(dynamic other) {
    if (other is num) {
      // Scalar multiplication
      List<List<double>> result = List.generate(
        rows,
        (i) => List.generate(cols, (j) => _data[i][j] * other.toDouble())
      );
      return SimpleMatrix(result);
    } else if (other is SimpleMatrix) {
      // Matrix multiplication
      if (cols != other.rows) {
        throw ArgumentError('Number of columns in first matrix must equal number of rows in second matrix');
      }
      
      List<List<double>> result = List.generate(
        rows,
        (i) => List.generate(other.cols, (j) {
          double sum = 0;
          for (int k = 0; k < cols; k++) {
            sum += _data[i][k] * other._data[k][j];
          }
          return sum;
        })
      );
      
      return SimpleMatrix(result);
    } else {
      throw ArgumentError('Can only multiply by number or matrix');
    }
  }
  
  SimpleMatrix transpose() {
    List<List<double>> result = List.generate(
      cols,
      (i) => List.generate(rows, (j) => _data[j][i])
    );
    return SimpleMatrix(result);
  }
  
  double determinant() {
    if (rows != cols) {
      throw ArgumentError('Matrix must be square to calculate determinant');
    }
    
    if (rows == 1) return _data[0][0];
    if (rows == 2) return _data[0][0] * _data[1][1] - _data[0][1] * _data[1][0];
    
    return _calculateDeterminant(_data);
  }
  
  double _calculateDeterminant(List<List<double>> matrix) {
    int n = matrix.length;
    
    if (n == 1) return matrix[0][0];
    if (n == 2) return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
    
    double det = 0;
    for (int j = 0; j < n; j++) {
      List<List<double>> minor = [];
      for (int i = 1; i < n; i++) {
        List<double> row = [];
        for (int k = 0; k < n; k++) {
          if (k != j) row.add(matrix[i][k]);
        }
        minor.add(row);
      }
      
      double cofactor = matrix[0][j] * _calculateDeterminant(minor);
      if (j % 2 == 1) cofactor = -cofactor;
      det += cofactor;
    }
    
    return det;
  }
  
  SimpleMatrix? inverse() {
    if (rows != cols) {
      throw ArgumentError('Matrix must be square to calculate inverse');
    }
    
    double det = determinant();
    if (det.abs() < 1e-10) {
      return null; // Matrix is singular
    }
    
    int n = rows;
    
    // Create augmented matrix [A|I]
    List<List<double>> augmented = [];
    for (int i = 0; i < n; i++) {
      augmented.add([]);
      for (int j = 0; j < n; j++) {
        augmented[i].add(_data[i][j]);
      }
      for (int j = 0; j < n; j++) {
        augmented[i].add(i == j ? 1.0 : 0.0);
      }
    }
    
    // Gauss-Jordan elimination
    for (int i = 0; i < n; i++) {
      // Find pivot
      int pivot = i;
      for (int j = i + 1; j < n; j++) {
        if (augmented[j][i].abs() > augmented[pivot][i].abs()) {
          pivot = j;
        }
      }
      
      // Swap rows if needed
      if (pivot != i) {
        List<double> temp = augmented[i];
        augmented[i] = augmented[pivot];
        augmented[pivot] = temp;
      }
      
      // Scale pivot row
      double pivotValue = augmented[i][i];
      for (int j = 0; j < 2 * n; j++) {
        augmented[i][j] /= pivotValue;
      }
      
      // Eliminate column
      for (int j = 0; j < n; j++) {
        if (j != i) {
          double factor = augmented[j][i];
          for (int k = 0; k < 2 * n; k++) {
            augmented[j][k] -= factor * augmented[i][k];
          }
        }
      }
    }
    
    // Extract inverse matrix from right side of augmented matrix
    List<List<double>> inverseData = [];
    for (int i = 0; i < n; i++) {
      inverseData.add([]);
      for (int j = n; j < 2 * n; j++) {
        inverseData[i].add(augmented[i][j]);
      }
    }
    
    return SimpleMatrix(inverseData);
  }
  
  double trace() {
    if (rows != cols) {
      throw ArgumentError('Matrix must be square to calculate trace');
    }
    
    double sum = 0;
    for (int i = 0; i < rows; i++) {
      sum += _data[i][i];
    }
    return sum;
  }
  
  int rank() {
    List<List<double>> data = List.from(_data.map((row) => List<double>.from(row)));
    
    int rank = 0;
    for (int col = 0; col < cols && rank < rows; col++) {
      // Find pivot
      int pivot = -1;
      for (int row = rank; row < rows; row++) {
        if (data[row][col].abs() > 1e-10) {
          pivot = row;
          break;
        }
      }
      
      if (pivot == -1) continue;
      
      // Swap rows
      if (pivot != rank) {
        List<double> temp = data[rank];
        data[rank] = data[pivot];
        data[pivot] = temp;
      }
      
      // Eliminate
      for (int row = rank + 1; row < rows; row++) {
        if (data[row][col].abs() > 1e-10) {
          double factor = data[row][col] / data[rank][col];
          for (int c = col; c < cols; c++) {
            data[row][c] -= factor * data[rank][c];
          }
        }
      }
      
      rank++;
    }
    
    return rank;
  }
  
  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('[');
    
    for (int i = 0; i < rows; i++) {
      buffer.write('  [');
      for (int j = 0; j < cols; j++) {
        buffer.write(_data[i][j].toStringAsFixed(3));
        if (j < cols - 1) buffer.write(', ');
      }
      buffer.write(']');
      if (i < rows - 1) buffer.writeln(',');
      else buffer.writeln();
    }
    
    buffer.write(']');
    return buffer.toString();
  }
  
  List<List<double>> toList() => List.from(_data.map((row) => List<double>.from(row)));
}
