import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'models/expense_model.dart';
import 'expense_entry_page.dart';

class SummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        final dailyExpenses = expenseProvider.expenses;
        final categorizedExpenses = expenseProvider.categorizedExpenses;

        return Scaffold(
          backgroundColor: Colors.black87, // GitHub-like dark theme background
          appBar: AppBar(
            title: Text('Expense Summary'),
            backgroundColor: Colors.black, // Dark AppBar
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpenseEntryPage()),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: dailyExpenses.isEmpty ? 100 : dailyExpenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b) * 1.1,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < dailyExpenses.length) {
                                return Text(
                                  dailyExpenses[index].category,
                                  style: TextStyle(color: Colors.white), // White text for contrast
                                );
                              }
                              return Text('');
                            },
                            reservedSize: 40,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(color: Colors.white), // White text
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false), // Hide the grid behind the bars
                      barGroups: dailyExpenses.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        return BarChartGroupData(
                          x: index,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: data.amount,
                              color: Colors.blueAccent, // GitHub accent color
                              width: 20,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: categorizedExpenses.entries.map((entry) {
                        final index = categorizedExpenses.entries.toList().indexOf(entry);
                        return PieChartSectionData(
                          value: entry.value,
                          color: Colors.primaries[index % Colors.primaries.length],
                          title: '${entry.key} (${entry.value.toStringAsFixed(2)})',
                          radius: 100,
                          titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                        );
                      }).toList(),
                      borderData: FlBorderData(show: false),
                      centerSpaceRadius: 40,
                      sectionsSpace: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
