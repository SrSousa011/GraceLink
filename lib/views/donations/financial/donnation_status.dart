import 'package:cloud_firestore/cloud_firestore.dart';

class DonationStats {
  final double totalDonnation;
  final double monthlyDonnation;

  DonationStats({
    required this.totalDonnation,
    required this.monthlyDonnation,
  });

  factory DonationStats.fromDonations(List<DocumentSnapshot> donations) {
    double totalBalance = 0.0;
    double monthlyIncome = 0.0;
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    for (var doc in donations) {
      final data = doc.data() as Map<String, dynamic>;

      final donationValueStr = data['donationValue']?.toString() ?? '0.00';
      final donationValue = _parseDonationValue(donationValueStr);
      final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

      totalBalance += donationValue;

      if (timestamp != null && timestamp.isAfter(startOfMonth)) {
        monthlyIncome += donationValue;
      }
    }

    return DonationStats(
      totalDonnation: totalBalance,
      monthlyDonnation: monthlyIncome,
    );
  }

  static double _parseDonationValue(String value) {
    final sanitizedValue = value
        .replaceAll('€', '')
        .replaceAll(' ', '')
        .replaceAll(',', '.')
        .trim();

    return double.tryParse(sanitizedValue) ?? 0.0;
  }
}
