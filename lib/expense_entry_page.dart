// expense_entry_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/expense_model.dart';

class ExpenseEntryPage extends StatelessWidget {
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final category = _categoryController.text;
                final amount = double.tryParse(_amountController.text) ?? 0.0;

                if (category.isNotEmpty && amount > 0) {
                  final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
                  expenseProvider.addExpense(Expense(category: category, amount: amount));

                  Navigator.pop(context); // Return to the SummaryPage
                }
              },
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
