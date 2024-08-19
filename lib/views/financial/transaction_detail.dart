import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String from;
  final double amount;
  final bool isPositive;
  final String status;
  final String time;
  final String date;
  final double earningFee;
  final double total;

  Transaction({
    required this.title,
    required this.from,
    required this.amount,
    required this.isPositive,
    required this.status,
    required this.time,
    required this.date,
    required this.earningFee,
    required this.total,
  });
}

final List<Transaction> transactionData = [
  Transaction(
    title: 'Pagamento do Cliente A',
    from: 'João Silva',
    amount: 200.00,
    isPositive: true,
    status: 'Concluído',
    time: '14:30',
    date: '2024-08-10',
    earningFee: 5.00,
    total: 205.00,
  ),
  Transaction(
    title: 'Compra de Materiais',
    from: 'Fornecedor X',
    amount: 150.00,
    isPositive: false,
    status: 'Pendente',
    time: '09:15',
    date: '2024-08-11',
    earningFee: 0.00,
    total: 150.00,
  ),
  Transaction(
    title: 'Venda de Produtos',
    from: 'Cliente Y',
    amount: 300.00,
    isPositive: true,
    status: 'Concluído',
    time: '16:45',
    date: '2024-08-12',
    earningFee: 10.00,
    total: 310.00,
  ),
  Transaction(
    title: 'Serviço Prestado',
    from: 'Empresa Z',
    amount: 450.00,
    isPositive: true,
    status: 'Cancelado',
    time: '11:00',
    date: '2024-08-13',
    earningFee: 20.00,
    total: 470.00,
  ),
  Transaction(
    title: 'Compra de Software',
    from: 'Fornecedor A',
    amount: 120.00,
    isPositive: false,
    status: 'Concluído',
    time: '13:20',
    date: '2024-08-14',
    earningFee: 0.00,
    total: 120.00,
  ),
  Transaction(
    title: 'Assinatura Anual',
    from: 'Cliente B',
    amount: 500.00,
    isPositive: true,
    status: 'Concluído',
    time: '10:10',
    date: '2024-08-15',
    earningFee: 15.00,
    total: 515.00,
  ),
  Transaction(
    title: 'Compra de Equipamentos',
    from: 'Fornecedor B',
    amount: 350.00,
    isPositive: false,
    status: 'Pendente',
    time: '17:25',
    date: '2024-08-16',
    earningFee: 0.00,
    total: 350.00,
  ),
  Transaction(
    title: 'Pagamento de Salário',
    from: 'Empresa X',
    amount: 1000.00,
    isPositive: true,
    status: 'Concluído',
    time: '12:00',
    date: '2024-08-17',
    earningFee: 50.00,
    total: 1050.00,
  ),
  Transaction(
    title: 'Reembolso de Despesas',
    from: 'Cliente C',
    amount: 75.00,
    isPositive: true,
    status: 'Concluído',
    time: '08:45',
    date: '2024-08-18',
    earningFee: 0.00,
    total: 75.00,
  ),
  Transaction(
    title: 'Compra de Serviços Online',
    from: 'Fornecedor C',
    amount: 90.00,
    isPositive: false,
    status: 'Cancelado',
    time: '15:35',
    date: '2024-08-19',
    earningFee: 0.00,
    total: 90.00,
  ),
  Transaction(
    title: 'Venda de Licença',
    from: 'Cliente D',
    amount: 250.00,
    isPositive: true,
    status: 'Concluído',
    time: '18:20',
    date: '2024-08-20',
    earningFee: 10.00,
    total: 260.00,
  ),
];

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetails({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título: ${transaction.title}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Recebido de: ${transaction.from}'),
            Text('Status: ${transaction.status}'),
            Text('Hora: ${transaction.time}'),
            Text('Data: ${transaction.date}'),
            Text(
                'Taxa de Ganho: € ${transaction.earningFee.toStringAsFixed(2)}'),
            Text('Total: € ${transaction.total.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Text(
              'Valor: € ${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: transaction.isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recibo baixado')),
                );
              },
              child: const Text('Baixar Recibo'),
            ),
          ],
        ),
      ),
    );
  }
}
