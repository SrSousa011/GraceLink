class ExpenseData {
  double totalExpenses;
  Map<String, double> expensesPerMonth;

  ExpenseData({
    this.totalExpenses = 0.0,
    Map<String, double>? expensesPerMonth,
  }) : expensesPerMonth = expensesPerMonth ?? _initializeMonthlyData();

  static Map<String, double> _initializeMonthlyData() {
    return {
      for (int month = 1; month <= 12; month++) getMonthName(month): 0.0,
    };
  }

  static String getMonthName(int month) {
    const monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return monthNames[month - 1];
  }

  factory ExpenseData.fromMap(Map<String, dynamic> map) {
    return ExpenseData(
      totalExpenses: (map['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      expensesPerMonth: (map['expensesPerMonth'] as Map<String, dynamic>?)?.map(
              (key, value) =>
                  MapEntry(key, (value as num?)?.toDouble() ?? 0.0)) ??
          _initializeMonthlyData(),
    );
  }
}
