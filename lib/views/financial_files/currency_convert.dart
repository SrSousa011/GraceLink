class CurrencyConverter {
  static String format(double amount) {
    return '€ ${amount.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  static double parse(String amount) {
    return double.parse(amount.replaceAll('€ ', '').replaceAll(',', '.'));
  }

  static double parseDonationValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    } else if (value is String) {
      final sanitizedValue = value
          .replaceAll('€', '')
          .replaceAll(' ', '')
          .replaceAll(',', '.')
          .trim();

      return double.tryParse(sanitizedValue) ?? 0.0;
    } else {
      return 0.0;
    }
  }
}
