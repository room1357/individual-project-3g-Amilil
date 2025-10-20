import 'package:uuid/uuid.dart';

import '../models/user.dart';

class AuthService {
  static final List<User> _registeredUsers = [...userList];
  static User? _currentUser;
  static final Uuid _uuid = const Uuid(); // ✅ tambahkan ini

  /// Register user baru
  static bool register({
    required String fullName,
    required String email,
    required String username,
    required String password,
  }) {
    final existingUser =
        _registeredUsers.any((user) => user.username == username);

    if (existingUser) return false;

    // ✅ Gunakan UUID, bukan DateTime
    final newUser = User(
      id: _uuid.v4(),
      fullName: fullName,
      email: email,
      username: username,
      password: password,
    );

    _registeredUsers.add(newUser);
    _currentUser = newUser;
    return true;
  }

  static bool login(String username, String password) {
    try {
      final user = _registeredUsers.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      _currentUser = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  static void logout() => _currentUser = null;

  static User? get currentUser => _currentUser;

  static bool get isLoggedIn => _currentUser != null;
}
