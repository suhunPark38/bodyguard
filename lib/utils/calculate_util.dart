class CalculateUtil {
  static final CalculateUtil _instance = CalculateUtil._internal();

  factory CalculateUtil() {
    return _instance;
  }

  CalculateUtil._internal();

  double getSumOfLists(List<double> reals) {
    double sum = 0.0;

    for (double real in reals){
      sum += real;
    }

    return sum;
  }

  double subtract(double a, double b) => a - b;

  double multiply(double a, double b) => a * b;

  double divide(double a, double b) => a / b;

  int calculateClassification(int hour) {
    if (hour >= 6 && hour < 12) {
      return 0;
    } else if (hour >= 12 && hour < 17) {
      return 1;
    } else {
      return 2;
    }
  }
}
