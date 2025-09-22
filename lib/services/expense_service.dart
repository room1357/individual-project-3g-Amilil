import '../models/expense.dart';

class ExpenseService {
  final List<Expense> _expenses = [];

  List<Expense> getAll() => _expenses;

  void addExpense(Expense expense) => _expenses.add(expense);

  void updateExpense(int index, Expense expense) {
    _expenses[index] = expense;
  }

  void deleteExpense(int index) {
    _expenses.removeAt(index);
  }
}
