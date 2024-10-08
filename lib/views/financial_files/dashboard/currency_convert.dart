class CurrencyConverter {
  static String format(double amount) {
    String integerPart = amount.toStringAsFixed(2).split('.')[0];
    String fractionalPart = amount.toStringAsFixed(2).split('.')[1];

    if (integerPart.length <= 3) {
      return '€ $integerPart,$fractionalPart';
    }

    StringBuffer formattedIntegerPart = StringBuffer();
    int count = 0;

    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        formattedIntegerPart.write('.');
      }
      formattedIntegerPart.write(integerPart[i]);
      count++;
    }

    String reversedIntegerPart =
        formattedIntegerPart.toString().split('').reversed.join('');

    return '€ $reversedIntegerPart,$fractionalPart';
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
