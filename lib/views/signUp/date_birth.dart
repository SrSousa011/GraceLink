import 'package:flutter/material.dart';

class DateOfBirthDropdowns extends StatelessWidget {
  const DateOfBirthDropdowns({
    super.key,
    this.selectedDay,
    this.selectedMonth,
    this.selectedYear,
    required this.onChangedDay,
    required this.onChangedMonth,
    required this.onChangedYear,
  });

  final int? selectedDay;
  final int? selectedMonth;
  final int? selectedYear;
  final ValueChanged<int?> onChangedDay;
  final ValueChanged<int?> onChangedMonth;
  final ValueChanged<int?> onChangedYear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Day',
            ),
            value: selectedDay,
            onChanged: onChangedDay,
            items: List.generate(31, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text((index + 1).toString()),
              );
            }),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Month',
            ),
            value: selectedMonth,
            onChanged: onChangedMonth,
            items: List.generate(12, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text((index + 1).toString()),
              );
            }),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Year',
            ),
            value: selectedYear,
            onChanged: onChangedYear,
            items: List.generate(80, (index) {
              return DropdownMenuItem<int>(
                value: DateTime.now().year - index,
                child: Text((DateTime.now().year - index).toString()),
              );
            }),
          ),
        ),
      ],
    );
  }
}
