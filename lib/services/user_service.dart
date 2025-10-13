// lib/services/user_service.dart
import '../models/user.dart';

/// Kelas ini bertanggung jawab untuk menyimpan dan mengambil data user.
/// Untuk proyek ini, datanya masih disimpan secara lokal (dummy / simulasi),
/// bukan dari database atau API.
class UserService {
  // Simulasi database user lokal
  static final List<User> _users = [];

  /// Menambahkan user baru (biasanya dari RegisterScreen)
  static Future<bool> registerUser(User newUser) async {
    // Cek apakah username atau email sudah dipakai
    final existingUser = _users.any((u) =>
        u.username == newUser.username || u.email == newUser.email);

    if (existingUser) {
      return false; // gagal register karena user sudah ada
    }

    _users.add(newUser);
    return true;
  }

  /// Mengecek login user berdasarkan username dan password
  static Future<User?> login(String username, String password) async {
    try {
      final user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      return user;
    } catch (e) {
      return null; // user tidak ditemukan
    }
  }

  /// Mengambil semua user yang terdaftar
  static List<User> getAllUsers() {
    return _users;
  }

  /// Mengupdate data user
  static Future<bool> updateUser(User updatedUser) async {
    final index = _users.indexWhere((u) => u.username == updatedUser.username);
    if (index != -1) {
      _users[index] = updatedUser;
      return true;
    }
    return false;
  }

  /// Menghapus user berdasarkan username
  static Future<bool> deleteUser(String username) async {
    final index = _users.indexWhere((u) => u.username == username);
    if (index != -1) {
      _users.removeAt(index);
      return true;
    }
    return false;
  }
}
