class RevenueData {
  double totalDonations;
  double totalCourses;
  double totalOthers;
  double totalIncomes;

  Map<String, double> donationsPerMonth;
  Map<String, double> coursesPerMonth;
  Map<String, double> othersPerMonth;

  RevenueData({
    this.totalDonations = 0.0,
    this.totalCourses = 0.0,
    this.totalOthers = 0.0,
    this.totalIncomes = 0.0,
    Map<String, double>? donationsPerMonth,
    Map<String, double>? courseRevenuePerMonth,
    Map<String, double>? otherPerMonth,
  })  : donationsPerMonth = donationsPerMonth ?? _initializeMonthlyData(),
        coursesPerMonth = courseRevenuePerMonth ?? _initializeMonthlyData(),
        othersPerMonth = otherPerMonth ?? _initializeMonthlyData();

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
      'Dezembro'
    ];
    return monthNames[month - 1];
  }

  factory RevenueData.fromMap(Map<String, dynamic> map) {
    return RevenueData(
      totalDonations: (map['totalDonations'] as num?)?.toDouble() ?? 0.0,
      totalCourses: (map['totalCourses'] as num?)?.toDouble() ?? 0.0,
      otherPerMonth: (map['otherPerMonth'] as Map<String, dynamic>?)?.map(
              (key, value) =>
                  MapEntry(key, (value as num?)?.toDouble() ?? 0.0)) ??
          {},
    );
  }
}
