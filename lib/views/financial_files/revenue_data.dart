class RevenueData {
  double totalDonations;
  double totalCourseRevenue;
  double totalOthers;
  double totalRevenue;

  Map<String, double> donationsPerMonth;
  Map<String, double> courseRevenuePerMonth;
  Map<String, double> incomePerMonth;

  RevenueData({
    this.totalDonations = 0.0,
    this.totalCourseRevenue = 0.0,
    this.totalOthers = 0.0,
    this.totalRevenue = 0.0,
    Map<String, double>? donationsPerMonth,
    Map<String, double>? courseRevenuePerMonth,
    Map<String, double>? incomePerMonth,
  })  : donationsPerMonth = donationsPerMonth ?? _initializeMonthlyData(),
        courseRevenuePerMonth =
            courseRevenuePerMonth ?? _initializeMonthlyData(),
        incomePerMonth = incomePerMonth ?? _initializeMonthlyData();

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
      totalCourseRevenue:
          (map['totalCourseRevenue'] as num?)?.toDouble() ?? 0.0,
      totalOthers: (map['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      donationsPerMonth: (map['donationsPerMonth'] as Map<String, dynamic>?)
              ?.map((key, value) =>
                  MapEntry(key, (value as num?)?.toDouble() ?? 0.0)) ??
          {},
      courseRevenuePerMonth:
          (map['courseRevenuePerMonth'] as Map<String, dynamic>?)?.map(
                  (key, value) =>
                      MapEntry(key, (value as num?)?.toDouble() ?? 0.0)) ??
              {},
      incomePerMonth: (map['incomePerMonth'] as Map<String, dynamic>?)?.map(
              (key, value) =>
                  MapEntry(key, (value as num?)?.toDouble() ?? 0.0)) ??
          {},
    );
  }
}
