import 'package:flutter/material.dart';
import '../managers/expense_manager.dart';
import '../models/expense.dart';
import 'package:uuid/uuid.dart';

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  _AdvancedExpenseListScreenState createState() =>
      _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
  late List<Expense> expenses;
  late List<Expense> filteredExpenses;
  String selectedCategory = 'Semua';
  final TextEditingController searchController = TextEditingController();
  final uuid = const Uuid();

  final List<String> categories = [
    'Semua',
    'Makanan',
    'Transportasi',
    'Komunikasi',
    'Hiburan',
    'Pendidikan'
  ];

  @override
  void initState() {
    super.initState();
    expenses = List<Expense>.from(ExpenseManager.getUserExpenses());
    filteredExpenses = List<Expense>.from(expenses);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengeluaran Advanced'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _filterExpenses(),
            ),
          ),

          // Category filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories
                  .map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                              _filterExpenses();
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Statistik ringkas
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', _calculateTotal(filteredExpenses)),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard('Rata-rata', _calculateAverage(filteredExpenses)),
              ],
            ),
          ),

          // Daftar pengeluaran
          Expanded(
            child: filteredExpenses.isEmpty
                ? const Center(child: Text('Tidak ada pengeluaran ditemukan'))
                : ListView.builder(
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(expense.category),
                            child: Icon(
                              _getCategoryIcon(expense.category),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(expense.title),
                          subtitle: Text(
                              '${expense.category} • ${expense.formattedDate}'),
                          trailing: Text(
                            expense.formattedAmount,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[600],
                            ),
                          ),
                          onTap: () => _showExpenseDetails(context, expense),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 🔍 Filter pengeluaran
  void _filterExpenses() {
    final q = searchController.text.toLowerCase();
    setState(() {
      filteredExpenses = expenses.where((expense) {
        final matchesSearch = q.isEmpty ||
            expense.title.toLowerCase().contains(q) ||
            expense.description.toLowerCase().contains(q);
        final matchesCategory =
            (selectedCategory == 'Semua') || (expense.category == selectedCategory);
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  // 🧮 Kartu statistik
  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _calculateTotal(List<Expense> list) {
    final double total = list.fold(0.0, (sum, e) => sum + e.amount);
    return 'Rp ${total.toStringAsFixed(0)}';
  }

  String _calculateAverage(List<Expense> list) {
    if (list.isEmpty) return 'Rp 0';
    final double avg = list.fold(0.0, (s, e) => s + e.amount) / list.length;
    return 'Rp ${avg.toStringAsFixed(0)}';
  }

  // 🎨 Warna kategori
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.green;
      case 'Transportasi':
        return Colors.blue;
      case 'Komunikasi':
        return Colors.orange;
      case 'Hiburan':
        return Colors.purple;
      case 'Pendidikan':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  // 🎯 Ikon kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.fastfood;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Komunikasi':
        return Icons.phone_android;
      case 'Hiburan':
        return Icons.movie;
      case 'Pendidikan':
        return Icons.school;
      default:
        return Icons.attach_money;
    }
  }

  // 🔹 Detail pengeluaran
  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Deskripsi: ${expense.description}"),
            Text("Kategori: ${expense.category}"),
            Text("Tanggal: ${expense.formattedDate}"),
            Text("Jumlah: ${expense.formattedAmount}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          )
        ],
      ),
    );
  }

  // ➕ Tambah pengeluaran baru
  void _showAddExpenseDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedCat = 'Makanan';
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Pengeluaran"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Judul"),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Deskripsi"),
              ),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCat,
                items: categories
                    .where((c) => c != 'Semua')
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => selectedCat = val ?? 'Makanan',
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isEmpty ||
                  amountCtrl.text.isEmpty ||
                  double.tryParse(amountCtrl.text) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Isi data dengan benar")),
                );
                return;
              }

              final newExpense = Expense(
                id: uuid.v4(),
                userId: "u1", // nanti bisa diganti AuthService.currentUser!.id
                title: titleCtrl.text,
                description: descCtrl.text,
                category: selectedCat,
                amount: double.parse(amountCtrl.text),
                date: DateTime.now(),
              );

              setState(() {
                ExpenseManager.addExpense(newExpense);
                expenses = ExpenseManager.getUserExpenses();
                filteredExpenses = List<Expense>.from(expenses);
              });

              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
