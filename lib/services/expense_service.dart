import '../models/expense.dart';
import 'auth_service.dart';

class ExpenseService {
  static final Map<String, List<Expense>> _userExpenses = {}; // 🔹 userId -> list expense

  /// Ambil semua pengeluaran untuk user yang sedang login
  static List<Expense> getAll() {
    final user = AuthService.currentUser;
    if (user == null) return [];
    return _userExpenses[user.id] ?? [];
  }

  /// Tambahkan pengeluaran baru
  static void addExpense(Expense expense) {
    final user = AuthService.currentUser;
    if (user == null) return;
    _userExpenses.putIfAbsent(user.id, () => []);
    _userExpenses[user.id]!.add(expense);
  }

  /// Update pengeluaran berdasarkan index
  static void updateExpense(int index, Expense expense) {
    final user = AuthService.currentUser;
    if (user == null) return;
    if (_userExpenses[user.id] == null || index >= _userExpenses[user.id]!.length) return;
    _userExpenses[user.id]![index] = expense;
  }

  /// Hapus pengeluaran berdasarkan index
  static void deleteExpense(int index) {
    final user = AuthService.currentUser;
    if (user == null) return;
    _userExpenses[user.id]?.removeAt(index);
  }

  /// Hapus semua pengeluaran user
  static void clearForUser(String userId) {
    _userExpenses.remove(userId);
  }
}
