class RevenueData {
  double totalOthers;
  double totalDonations;
  double totalCourses;
  double totalIncomes;
  double monthlyOthers;
  double monthlyIncomes;
  double monthlyDonations;
  double monthlyCourses;
  Map<String, double> othersPerMonth;
  Map<String, double> donationsPerMonth;
  Map<String, double> coursesPerMonth;

  RevenueData({
    required this.totalIncomes,
    required this.monthlyOthers,
    required this.monthlyIncomes,
    this.totalOthers = 0.0,
    this.totalDonations = 0.0,
    this.totalCourses = 0.0,
    this.monthlyDonations = 0.0,
    this.monthlyCourses = 0.0,
  })  : othersPerMonth = {},
        donationsPerMonth = {},
        coursesPerMonth = {};

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
}
