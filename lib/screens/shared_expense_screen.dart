// lib/screens/shared_expense_screen.dart
import 'package:flutter/material.dart';

class SharedExpenseScreen extends StatelessWidget {
  const SharedExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Expenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Shared Expenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Expanded(
              child: Center(
                child: Text(
                  'Belum ada data bersama.\nTambahkan pengeluaran yang dibagikan di sini.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // contoh navigasi ke add expense
                Navigator.pushNamed(context, '/add-expense');
              },
              child: const Text('Tambah Shared Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
