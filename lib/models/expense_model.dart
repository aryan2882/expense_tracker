// models/expense_model.dart
import 'package:flutter/foundation.dart';

class Expense {
  final String category;
  final double amount;

  Expense({required this.category, required this.amount});
}

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  // Method to get expenses categorized by type for the Pie Chart
  Map<String, double> get categorizedExpenses {
    Map<String, double> categories = {};

    for (var expense in _expenses) {
      if (categories.containsKey(expense.category)) {
        categories[expense.category] = categories[expense.category]! + expense.amount;
      } else {
        categories[expense.category] = expense.amount;
      }
    }

    return categories;
  }
}
