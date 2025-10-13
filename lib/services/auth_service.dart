// lib/services/auth_service.dart
import '../models/user.dart';

class AuthService {
  // Simulasi penyimpanan user di memori sementara
  static final List<User> _registeredUsers = [];

  static User? _currentUser;

  /// Register user baru
  static bool register({
    required String fullName,
    required String email,
    required String username,
    required String password,
  }) {
    // Cek apakah username sudah dipakai
    final existingUser =
        _registeredUsers.any((user) => user.username == username);

    if (existingUser) {
      return false; // gagal, username sudah digunakan
    }

    // Tambahkan user baru
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      username: username,
      password: password,
    );

    _registeredUsers.add(newUser);
    _currentUser = newUser;
    return true;
  }

  /// Login user
  static bool login(String username, String password) {
    try {
      final user = _registeredUsers.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      _currentUser = user;
      return true;
    } catch (e) {
      return false; // user tidak ditemukan
    }
  }

  /// Logout user
  static void logout() {
    _currentUser = null;
  }

  /// Mendapatkan user yang sedang login
  static User? get currentUser => _currentUser;

  /// Mengecek apakah user sedang login
  static bool get isLoggedIn => _currentUser != null;
}
