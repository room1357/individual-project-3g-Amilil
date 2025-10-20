// lib/models/user.dart
class User {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String password;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
  });

  // 🔹 Convert dari Map (misalnya dari database lokal)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      username: map['username'],
      password: map['password'],
    );
  }

  // 🔹 Convert ke Map (misalnya untuk simpan ke database atau JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'username': username,
      'password': password,
    };
  }
}

// ==========================================================
// 🔸 Data user dummy (multi user support)
// ==========================================================

// Gunakan ID statis agar tidak berubah setiap rebuild
final List<User> userList = [
  User(
    id: 'u1', // ✅ ID tetap
    fullName: 'User Dummy 1',
    email: 'user1@example.com',
    username: 'user1',
    password: 'password1',
  ),
  User(
    id: 'u2', // ✅ ID tetap
    fullName: 'User Dummy 2',
    email: 'user2@example.com',
    username: 'user2',
    password: 'password2',
  ),
  User(
    id: 'admin', // ✅ ID tetap
    fullName: 'Admin Account',
    email: 'admin@example.com',
    username: 'admin',
    password: 'admin123',
  ),
];
