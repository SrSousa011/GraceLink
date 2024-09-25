import 'package:churchapp/views/donations/donnation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DonationStats {
  final double totalDonation;
  final List<double> monthlyDonations; // Lista para armazenar doações mensais

  DonationStats({
    required this.totalDonation,
    required this.monthlyDonations, // Adicionando o parâmetro
  });
  static DonationStats fromDonations(List<Donation> donations) {
    double totalDonation = 0;
    List<double> monthlyDonations = List.filled(12, 0);

    for (var donation in donations) {
      totalDonation += donation.donationValue.toDouble();

      final date = (donation.timestamp.toDate());
      final month = date.month - 1; // Adjust for 0-indexing
      monthlyDonations[month] += donation.donationValue.toDouble();
    }

    return DonationStats(
      totalDonation: totalDonation,
      monthlyDonations: monthlyDonations,
    );
  }

  static double _parseDonationValue(dynamic value) {
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

  factory DonationStats.fromMap(Map<String, dynamic> map) {
    return DonationStats(
      totalDonation: (map['totalDonation'] as num?)?.toDouble() ?? 0.0,
      monthlyDonations: (map['monthlyDonations'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          List.filled(12, 0.0), // Garante que haja 12 meses
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalDonation': totalDonation,
      'monthlyDonations': monthlyDonations, // Adiciona a lista ao mapa
    };
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '€');
    return formatter.format(value);
  }

  double get monthlyIncome {
    // Calcular a renda mensal total a partir da lista de doações mensais
    return monthlyDonations.reduce((a, b) => a + b);
  }
}
