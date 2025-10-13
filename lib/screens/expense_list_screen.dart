import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../routes/app_routes.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  // Dummy data sementara (bisa diganti ambil dari service)
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      title: 'Makan Siang',
      amount: 25000,
      category: 'Makanan',
      date: DateTime(2025, 10, 10),
      description: 'Nasi goreng dan es teh',
    ),
    Expense(
      id: '2',
      title: 'Transportasi',
      amount: 10000,
      category: 'Transportasi',
      date: DateTime(2025, 10, 11),
      description: 'Naik ojek ke kampus',
    ),
  ];

  double get totalExpense =>
      _expenses.fold(0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengeluaran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addExpense);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(
            child: ListView.separated(
              itemCount: _expenses.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return ExpenseItem(expense: expense);
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

// ✅ Komponen untuk menampilkan satu item pengeluaran
class ExpenseItem extends StatelessWidget {
  final Expense expense;
  const ExpenseItem({super.key, required this.expense});

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
        'Rp ${expense.amount.toStringAsFixed(0)}',
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        // contoh: nanti bisa diarahkan ke edit expense
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Detail: ${expense.title}')),
        );
      },
    );
  }
}
