import 'package:flutter/material.dart';

class FinancialCardWidgets {
  static Widget buildFinancialCard({
    required IconData icon,
    required String title,
    required String value,
    required TextStyle valueStyle,
    required bool withShadow,
    required Color backgroundColor,
    required TextStyle titleStyle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: valueStyle.color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle),
                const SizedBox(height: 8),
                Text(value, style: valueStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFinanceSectionCard({
    required IconData icon,
    required String title,
    required String value,
    required Color backgroundColor,
    required Color titleColor,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: titleColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, color: titleColor)),
                const SizedBox(height: 8),
                Text(value, style: TextStyle(fontSize: 16, color: valueColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
