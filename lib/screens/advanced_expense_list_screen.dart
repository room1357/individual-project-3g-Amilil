import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../managers/expense_manager.dart';
import '../models/expense.dart';

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Expenses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _showAddExpenseDialog,
          backgroundColor: Colors.blue[700],
          icon: const Icon(Icons.add_rounded, size: 28),
          label: const Text(
            'Add Expense',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Header with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[700]!, Colors.blue[500]!],
              ),
            ),
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search expenses...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search_rounded, color: Colors.blue[700], size: 24),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear_rounded, color: Colors.grey[400]),
                                onPressed: () {
                                  searchController.clear();
                                  _filterExpenses();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      onChanged: (value) {
                        setState(() {});
                        _filterExpenses();
                      },
                    ),
                  ),
                ),

                // Category filter chips
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                              _filterExpenses();
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.blue[700],
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? Colors.blue[700]! : Colors.blue[200]!,
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Statistics cards
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    _calculateTotal(filteredExpenses),
                    Icons.account_balance_wallet_rounded,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Items',
                    '${filteredExpenses.length}',
                    Icons.receipt_long_rounded,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Average',
                    _calculateAverage(filteredExpenses),
                    Icons.trending_up_rounded,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Expense list
          Expanded(
            child: filteredExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No expenses found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your first expense',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildExpenseCard(expense),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    final categoryColor = _getCategoryColor(expense.category);
    final categoryIcon = _getCategoryIcon(expense.category);

    return InkWell(
      onTap: () => _showExpenseDetails(context, expense),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [categoryColor, categoryColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(categoryIcon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              // Expense info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            expense.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(
                          expense.formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Amount
              Text(
                expense.formattedAmount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  String _calculateTotal(List<Expense> list) {
    final double total = list.fold(0.0, (sum, e) => sum + e.amount);
    return 'Rp ${total.toStringAsFixed(0)}';
  }

  String _calculateAverage(List<Expense> list) {
    if (list.isEmpty) return 'Rp 0';
    final double avg = list.fold(0.0, (s, e) => s + e.amount) / list.length;
    return 'Rp ${avg.toStringAsFixed(0)}';
  }

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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.restaurant_rounded;
      case 'Transportasi':
        return Icons.directions_car_rounded;
      case 'Komunikasi':
        return Icons.phone_android_rounded;
      case 'Hiburan':
        return Icons.movie_rounded;
      case 'Pendidikan':
        return Icons.school_rounded;
      default:
        return Icons.attach_money;
    }
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getCategoryColor(expense.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getCategoryIcon(expense.category),
                color: _getCategoryColor(expense.category),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                expense.title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.description_rounded, "Description", expense.description),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.category_rounded, "Category", expense.category),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.calendar_today_rounded, "Date", expense.formattedDate),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.payments_rounded, "Amount", expense.formattedAmount),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddExpenseDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedCat = 'Makanan';
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add_rounded, color: Colors.blue[700]),
            ),
            const SizedBox(width: 12),
            const Text("Add Expense"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: "Title",
                  prefixIcon: const Icon(Icons.title_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: const Icon(Icons.description_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount (Rp)",
                  prefixIcon: const Icon(Icons.payments_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCat,
                items: categories
                    .where((c) => c != 'Semua')
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Row(
                            children: [
                              Icon(_getCategoryIcon(c), size: 20, color: _getCategoryColor(c)),
                              const SizedBox(width: 8),
                              Text(c),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (val) => selectedCat = val ?? 'Makanan',
                decoration: InputDecoration(
                  labelText: "Category",
                  prefixIcon: const Icon(Icons.category_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isEmpty ||
                  amountCtrl.text.isEmpty ||
                  double.tryParse(amountCtrl.text) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.white),
                        SizedBox(width: 12),
                        Text("Please fill all fields correctly"),
                      ],
                    ),
                    backgroundColor: Colors.red[600],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                return;
              }

              final newExpense = Expense(
                id: uuid.v4(),
                userId: "u1",
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
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text("Expense added successfully!"),
                    ],
                  ),
                  backgroundColor: Colors.green[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}