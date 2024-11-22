class ExpenseData {
  final double totalExpenses;
  final Map<String, double> expensesPerMonth;

  ExpenseData({required this.totalExpenses, required this.expensesPerMonth});

  // Method to get the month name from the month number
  static String getMonthName(int month) {
    const List<String> monthNames = [
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
    return monthNames[month - 1]; // Adjusting because months are 1-indexed
  }
}
