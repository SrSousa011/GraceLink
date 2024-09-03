import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FinancialAnalytics extends StatelessWidget {
  final double totalBalance;
  final double monthlyIncome;

  const FinancialAnalytics({
    required this.totalBalance,
    required this.monthlyIncome,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<BarChartGroupData> incomeData = List.generate(12, (index) {
      final values = [
        3000,
        2500,
        2800,
        3500,
        4000,
        3700,
        3600,
        3200,
        3100,
        3400,
        2900,
        3300
      ];
      final value = values[index].toDouble();
      const averageIncome = 3200.0;

      return BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            toY: value,
            color: value > averageIncome ? Colors.green : Colors.red,
            width: 20,
          ),
        ],
      );
    });

    final monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    final currentMonth = DateTime.now().month - 1;
    final currentMonthTotal = incomeData[currentMonth].barRods.first.toY;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visão Financeira'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balanço Mensal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 40.0,
                            color: const Color.fromARGB(255, 190, 214, 233),
                            title: '40%',
                            radius: 80,
                            titleStyle: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          PieChartSectionData(
                            value: 25.0,
                            color: Colors.green,
                            title: '25%',
                            radius: 80,
                            titleStyle: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          PieChartSectionData(
                            value: 20.0,
                            color: Colors.red,
                            title: '20%',
                            radius: 80,
                            titleStyle: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          PieChartSectionData(
                            value: 15.0,
                            color: Colors.orange,
                            title: '15%',
                            radius: 80,
                            titleStyle: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 8), // Espaço reduzido entre o gráfico e a legenda
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(
                          'Doações',
                          40.0,
                          const Color.fromARGB(255, 190, 214, 233),
                          isDarkMode,
                        ),
                        _buildLegendItem(
                          'Custos Operacionais',
                          25.0,
                          Colors.green,
                          isDarkMode,
                        ),
                        _buildLegendItem(
                          'Despesas com Eventos',
                          20.0,
                          Colors.red,
                          isDarkMode,
                        ),
                        _buildLegendItem(
                          'Outros Custos',
                          15.0,
                          Colors.orange,
                          isDarkMode,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${monthNames[currentMonth]}: €${currentMonthTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Balanço Anual',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16), // Espaço entre o título e o gráfico
              SizedBox(
                height: 400,
                child: BarChart(
                  BarChartData(
                    barGroups: incomeData,
                    titlesData: const FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(
      String title, double value, Color color, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
            margin: const EdgeInsets.only(right: 8.0),
          ),
          Expanded(
            child: Text(
              '$title: €${value.toStringAsFixed(2)}',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
