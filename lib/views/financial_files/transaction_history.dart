import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final incomeColor =
        isDarkMode ? Colors.lightGreenAccent : Colors.lightGreen;
    final expenseColor = isDarkMode ? Colors.redAccent : Colors.red;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700];

    final List<Map<String, dynamic>> recentTransactions = [
      {
        'title': 'Doação para a Igreja',
        'amount': '€ 50.00',
        'date': '2024-08-25',
        'time': '14:30',
        'user': 'John Doe',
        'type': 'Doação',
      },
      {
        'title': 'Compra de Materiais',
        'amount': '€ 30.00',
        'date': '2024-08-22',
        'time': '10:15',
        'user': 'Jane Smith',
        'type': 'Compra',
      },
      {
        'title': 'Patrocínio de Evento',
        'amount': '€ 100.00',
        'date': '2024-07-15',
        'time': '09:00',
        'user': 'Alice Johnson',
        'type': 'Patrocínio',
      },
      {
        'title': 'Cafeteria',
        'amount': '€ 5.50',
        'date': '2024-08-20',
        'time': '16:45',
        'user': 'Michael Brown',
        'type': 'Compra',
      },
      {
        'title': 'Assinatura de Academia',
        'amount': '€ 35.00',
        'date': '2024-08-18',
        'time': '08:00',
        'user': 'Emily Davis',
        'type': 'Assinatura',
      },
      {
        'title': 'Compra de Livro',
        'amount': '€ 20.00',
        'date': '2024-08-17',
        'time': '12:00',
        'user': 'David Wilson',
        'type': 'Compra',
      },
      {
        'title': 'Conta de Serviços',
        'amount': '€ 75.00',
        'date': '2024-08-14',
        'time': '14:00',
        'user': 'Sarah Lee',
        'type': 'Conta',
      },
      {
        'title': 'Jantar no Restaurante',
        'amount': '€ 45.00',
        'date': '2024-08-13',
        'time': '19:30',
        'user': 'Daniel Martinez',
        'type': 'Despesa',
      },
      {
        'title': 'Ingressos de Cinema',
        'amount': '€ 25.00',
        'date': '2024-08-11',
        'time': '21:00',
        'user': 'Laura Anderson',
        'type': 'Entretenimento',
      },
      {
        'title': 'Curso Online',
        'amount': '€ 120.00',
        'date': '2024-08-09',
        'time': '10:30',
        'user': 'James White',
        'type': 'Educação',
      },
      {
        'title': 'Manutenção do Carro',
        'amount': '€ 150.00',
        'date': '2024-08-05',
        'time': '11:00',
        'user': 'Olivia Harris',
        'type': 'Manutenção',
      },
      {
        'title': 'Passagem Aérea',
        'amount': '€ 200.00',
        'date': '2024-08-02',
        'time': '15:30',
        'user': 'Ethan Clark',
        'type': 'Viagem',
      },
      {
        'title': 'Reparo de Computador',
        'amount': '€ 80.00',
        'date': '2024-07-30',
        'time': '09:00',
        'user': 'Sophia Lewis',
        'type': 'Reparo',
      },
      {
        'title': 'Novo Celular',
        'amount': '€ 300.00',
        'date': '2024-07-28',
        'time': '17:00',
        'user': 'Benjamin Young',
        'type': 'Compra',
      },
      {
        'title': 'Serviço de Assinatura',
        'amount': '€ 15.00',
        'date': '2024-07-25',
        'time': '20:00',
        'user': 'Isabella King',
        'type': 'Assinatura',
      },
      {
        'title': 'Presente de Aniversário',
        'amount': '€ 50.00',
        'date': '2024-07-22',
        'time': '13:00',
        'user': 'William Scott',
        'type': 'Presente',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Transações'),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recentTransactions.length,
          itemBuilder: (context, index) {
            final transaction = recentTransactions[index];
            final isExpense = transaction['amount']!.startsWith('-');
            transaction['amount']!.replaceAll('€ ', '');

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: cardBackgroundColor,
              child: ListTile(
                leading: Icon(
                  isExpense ? Icons.trending_down : Icons.trending_up,
                  color: isExpense ? expenseColor : incomeColor,
                ),
                title: Text(
                  transaction['title']!,
                  style: TextStyle(
                      color: primaryTextColor, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  transaction['amount']!,
                  style: TextStyle(
                    color: isExpense ? expenseColor : incomeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Data: ${transaction['date']}\n'
                  'Hora: ${transaction['time']}\n'
                  'Usuário: ${transaction['user']}\n'
                  'Tipo: ${transaction['type']}',
                  style: TextStyle(color: secondaryTextColor),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
