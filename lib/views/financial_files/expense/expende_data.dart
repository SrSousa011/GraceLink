import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseData {
  final String id; // Identificador único para a despesa
  final String category; // Categoria da despesa
  final double amount; // Valor da despesa
  final DateTime createdAt; // Data da criação da despesa
  final String createdBy; // ID do usuário que criou a despesa

  ExpenseData({
    required this.id,
    required this.category,
    required this.amount,
    required this.createdAt,
    required this.createdBy,
  });

  factory ExpenseData.fromFirestore(Map<String, dynamic> data, String id) {
    return ExpenseData(
      id: id,
      category: data['category'] as String,
      amount: (data['amount'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}
