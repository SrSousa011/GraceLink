class CurrencyConverter {
  static String format(double amount) {
    String integerPart = amount.toStringAsFixed(2).split('.')[0];
    String fractionalPart = amount.toStringAsFixed(2).split('.')[1];

    String formattedIntegerPart = '';
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if ((integerPart.length - i) % 3 == 0 && i != integerPart.length - 1) {
        formattedIntegerPart = '.$formattedIntegerPart';
      }
      formattedIntegerPart = integerPart[i] + formattedIntegerPart;
    }

    return '€ $formattedIntegerPart,$fractionalPart';
  }

  static double parse(String amount) {
    return double.parse(
        amount.replaceAll('€ ', '').replaceAll('.', '').replaceAll(',', '.'));
  }

  static double parseDonationValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    } else if (value is String) {
      final sanitizedValue = value
          .replaceAll('€', '')
          .replaceAll(' ', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim();

      return double.tryParse(sanitizedValue) ?? 0.0;
    } else {
      return 0.0;
    }
  }
}
