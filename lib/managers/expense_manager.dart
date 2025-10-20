// lib/managers/expense_manager.dart
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../services/auth_service.dart';

class ExpenseManager {
  static final List<Expense> _allExpenses = [];
  static final Uuid _uuid = const Uuid();

  /// Getter yang mengembalikan hanya pengeluaran milik user yang sedang login
  static List<Expense> get expenses {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) return [];
    return _allExpenses.where((expense) => expense.userId == currentUser.id).toList();
  }

  /// Alternatif nama fungsi: ambil expenses user (sama dengan getter)
  static List<Expense> getUserExpenses() => expenses;

  /// ========================
  /// 1) Tambah pengeluaran dari objek Expense
  ///    (cocok untuk dipanggil: ExpenseManager.addExpense(newExpense))
  /// ========================
  static void addExpense(Expense expense) {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) return;

    // Pastikan expense disimpan dengan id unik dan userId sesuai user aktif
    final toAdd = expense.copyWith(
      id: expense.id.isNotEmpty ? expense.id : _uuid.v4(),
      userId: currentUser.id,
    );

    _allExpenses.add(toAdd);
  }

  /// ========================
  /// 2) Helper: Tambah pengeluaran dengan field langsung (opsional)
  ///    Bisa dipanggil seperti:
  ///    ExpenseManager.addExpenseRaw(title: '...', description: '...', amount: 1000, ...)
  /// ========================
  static void addExpenseRaw({
    required String title,
    required String description,
    required String category,
    required double amount,
    required DateTime date,
  }) {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) return;

    final newExpense = Expense(
      id: _uuid.v4(),
      userId: currentUser.id,
      title: title,
      description: description,
      category: category,
      amount: amount,
      date: date,
    );

    _allExpenses.add(newExpense);
  }

  /// ========================
  /// 3) Update pengeluaran berdasarkan id
  ///    updateExpense(id, updatedExpense) — updatedExpense dapat berupa Expense lengkap
  /// ========================
  static void updateExpense(String id, Expense updatedExpense) {
    final idx = _allExpenses.indexWhere((e) => e.id == id);
    if (idx == -1) return;

    final currentUser = AuthService.currentUser;
    if (currentUser == null) return;

    // Pastikan user yang mengubah adalah pemilik expense
    if (_allExpenses[idx].userId != currentUser.id) return;

    // Simpan perubahan — pastikan id & userId tetap milik owner
    _allExpenses[idx] = updatedExpense.copyWith(
      id: id,
      userId: currentUser.id,
    );
  }

  /// ========================
  /// 4) Hapus pengeluaran berdasarkan id
  /// ========================
  static void deleteExpense(String id) {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) return;

    _allExpenses.removeWhere((e) => e.id == id && e.userId == currentUser.id);
  }

  /// ========================
  /// 5) Hapus semua pengeluaran milik user tertentu
  /// ========================
  static void deleteAllUserExpenses(String userId) {
    _allExpenses.removeWhere((e) => e.userId == userId);
  }

  /// ========================
  /// 6) Utility: tambahkan dummy data untuk user (untuk testing)
  /// ========================
  static void addDummyDataForUser(String userId) {
    if (_allExpenses.any((e) => e.userId == userId)) return; // jangan duplikat

    _allExpenses.addAll([
      Expense(
        id: _uuid.v4(),
        userId: userId,
        title: 'Makan Siang',
        description: 'Nasi padang + minum',
        category: 'Makanan',
        amount: 25000,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Expense(
        id: _uuid.v4(),
        userId: userId,
        title: 'Naik Ojol',
        description: 'Perjalanan ke kampus',
        category: 'Transportasi',
        amount: 15000,
        date: DateTime.now(),
      ),
    ]);
  }

  /// ========================
  /// 7) Statistik / filter helper (menggunakan expenses milik user aktif)
  /// ========================
  static Map<String, double> getTotalByCategoryForCurrentUser() {
    final list = expenses;
    final Map<String, double> result = {};
    for (var e in list) {
      result[e.category] = (result[e.category] ?? 0) + e.amount;
    }
    return result;
  }

  static Expense? getHighestExpenseForCurrentUser() {
    final list = expenses;
    if (list.isEmpty) return null;
    return list.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  static List<Expense> getExpensesByMonthForCurrentUser(int month, int year) {
    return expenses.where((e) => e.date.month == month && e.date.year == year).toList();
  }

  static List<Expense> searchExpensesForCurrentUser(String keyword) {
    final lower = keyword.toLowerCase();
    return expenses.where((e) =>
      e.title.toLowerCase().contains(lower) ||
      e.description.toLowerCase().contains(lower) ||
      e.category.toLowerCase().contains(lower)
    ).toList();
  }

  static double getAverageDailyForCurrentUser() {
    final list = expenses;
    if (list.isEmpty) return 0;
    final total = list.fold<double>(0, (s, e) => s + e.amount);
    final uniqueDays = list.map((e) => '${e.date.year}-${e.date.month}-${e.date.day}').toSet().length;
    return total / uniqueDays;
  }
}
