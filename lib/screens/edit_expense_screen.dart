import 'package:flutter/material.dart';
import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final int index;
  final Function(int, Expense) onSave;

  const EditExpenseScreen({
    super.key,
    required this.expense,
    required this.index,
    required this.onSave,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _amountController;
  late String _selectedCategory;

  final List<String> categories = [
    "Makanan",
    "Transportasi",
    "Komunikasi",
    "Hiburan",
    "Pendidikan",
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _descController = TextEditingController(text: widget.expense.description);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _selectedCategory = widget.expense.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Pengeluaran")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
              decoration: const InputDecoration(labelText: "Kategori"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedExpense = Expense(
                  id: widget.expense.id,
                  userId: widget.expense.userId, // ✅ tetap user yang sama
                  title: _titleController.text,
                  description: _descController.text,
                  category: _selectedCategory,
                  amount: double.tryParse(_amountController.text) ?? 0,
                  date: DateTime.now(),
                );

                widget.onSave(widget.index, updatedExpense);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}
