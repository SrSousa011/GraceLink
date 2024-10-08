import 'package:churchapp/views/courses/charts/course_status.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/dashboard/revenue_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RevenueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<RevenueData> fetchAllRevenues() async {
    try {
      double totalOthers = await _getTotalOthers();

      double totalDonations = await _getTotalDonations();

      double totalCourses = await _getTotalCourses();

      double monthlyOthers =
          await _getMonthlyTotal('transactions', 'amount', 'timestamp');

      double monthlyDonations =
          await _getMonthlyTotal('donations', 'donationValue', 'timestamp');

      double monthlyCourses = await _getMonthlyTotal(
          'courseRegistration', 'price', 'registrationDate');

      double totalIncomes = totalOthers + totalDonations + totalCourses;

      double monthlyIncomes = monthlyOthers + monthlyDonations + monthlyCourses;

      return RevenueData(
        totalOthers: totalOthers,
        totalDonations: totalDonations,
        totalCourses: totalCourses,
        totalIncomes: totalIncomes,
        monthlyOthers: monthlyOthers,
        monthlyDonations: monthlyDonations,
        monthlyCourses: monthlyCourses,
        monthlyIncomes: monthlyIncomes,
      );
    } catch (e) {
      throw Exception('Error fetching all revenues: $e');
    }
  }

  Future<double> _getTotalOthers() async {
    return await _getTotalFromCollection(
        'transactions', 'Rendimento', 'amount');
  }

  Future<double> _getTotalDonations() async {
    return await _getTotalFromCollection('donations', null, 'donationValue');
  }

  Future<double> _getTotalCourses() async {
    return await _getTotalFromCollection('courseRegistration', null, 'price');
  }

  Future<double> _getTotalFromCollection(
      String collection, String? type, String field) async {
    try {
      final query = _firestore.collection(collection);
      final snapshot = type != null
          ? await query.where('type', isEqualTo: type).get()
          : await query.get();

      return snapshot.docs.fold<double>(0.0, (total, doc) {
        double value =
            (doc[field] ?? 0.0) is num ? (doc[field] as num).toDouble() : 0.0;
        return total + value;
      });
    } catch (e) {
      throw Exception('Error fetching total from collection $collection: $e');
    }
  }

  Future<double> _getMonthlyTotal(
      String collection, String field, String dateField) async {
    try {
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;

      final query = _firestore
          .collection(collection)
          .where(dateField,
              isGreaterThanOrEqualTo:
                  Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)))
          .where(dateField,
              isLessThan: Timestamp.fromDate(
                  DateTime(currentYear, currentMonth + 1, 1)));

      final snapshot = await query.get();

      return snapshot.docs.fold<double>(0.0, (total, doc) {
        double value =
            (doc[field] ?? 0.0) is num ? (doc[field] as num).toDouble() : 0.0;
        return total + value;
      });
    } catch (e) {
      throw Exception(
          'Error fetching monthly total from collection $collection: $e');
    }
  }

  Future<DonationStats> fetchDonationStats() async {
    final snapshot = await _firestore.collection('donations').get();
    double totalDonations = 0.0;
    List<double> monthlyDonations = List.filled(12, 0);

    for (var doc in snapshot.docs) {
      double donationValue = (doc['donationValue'] ?? 0.0) is num
          ? (doc['donationValue'] as num).toDouble()
          : 0.0;
      totalDonations += donationValue;

      final date = (doc['timestamp'] as Timestamp).toDate();
      final month = date.month - 1;
      monthlyDonations[month] += donationValue;
    }

    return DonationStats(
        totalDonation: totalDonations, monthlyDonations: monthlyDonations);
  }

  Future<CoursesStats> fetchCoursesStats() async {
    final snapshot = await _firestore.collection('courseRegistration').get();
    double totalCourses = 0.0;
    List<double> monthlyCourses = List.filled(12, 0);

    for (var doc in snapshot.docs) {
      double price =
          (doc['price'] ?? 0.0) is num ? (doc['price'] as num).toDouble() : 0.0;
      totalCourses += price;

      final date = (doc['registrationDate'] as Timestamp).toDate();
      final month = date.month - 1;
      monthlyCourses[month] += price;
    }

    return CoursesStats(
        totalCourses: totalCourses, monthlyCourses: monthlyCourses);
  }
}
