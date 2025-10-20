import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/expense_service.dart';
import 'edit_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    setState(() {
      _expenses = ExpenseService.getAll();
    });
  }

  double get totalExpense =>
      _expenses.fold(0, (sum, e) => sum + e.amount);

  void _goToAddExpense() async {
    await Navigator.pushNamed(context, AppRoutes.addExpense);
    _loadExpenses(); // refresh setelah kembali
  }

  void _goToEditExpense(int index) async {
    final expense = _expenses[index];
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpenseScreen(
          expense: expense,
          index: index,
          onSave: (i, updatedExpense) {
            ExpenseService.updateExpense(i, updatedExpense);
            _loadExpenses();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengeluaran ${user?.username ?? ""}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToAddExpense,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada pengeluaran",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.separated(
                    itemCount: _expenses.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final expense = _expenses[index];
                      return ExpenseItem(
                        expense: expense,
                        onTap: () => _goToEditExpense(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Pengeluaran:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Rp ${totalExpense.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Widget satuan item pengeluaran
class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;

  const ExpenseItem({super.key, required this.expense, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.attach_money, color: Colors.deepPurple),
      title: Text(expense.title),
      subtitle: Text(
        '${expense.category} • ${expense.formattedDate}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Text(
        expense.formattedAmount,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
