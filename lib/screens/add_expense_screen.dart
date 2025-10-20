import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/auth_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  String selectedCategory = 'Makanan';

  final List<String> categories = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Pendidikan',
    'Lainnya'
  ];

  void _saveExpense() {
    final user = AuthService.currentUser;
    if (user == null) return;

    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id, // ✅ simpan ID user
      title: titleController.text,
      description: descController.text,
      category: selectedCategory,
      amount: double.tryParse(amountController.text) ?? 0,
      date: DateTime.now(),
    );

    ExpenseService.addExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pengeluaran')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveExpense,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
