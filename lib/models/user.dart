import 'package:uuid/uuid.dart';

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

// Gunakan Uuid agar id selalu unik
const _uuid = Uuid();

final List<User> userList = [
  User(
    id: _uuid.v4(),
    fullName: 'User Dummy 1',
    email: 'user1@example.com',
    username: 'user1',
    password: 'password1',
  ),
  User(
    id: _uuid.v4(),
    fullName: 'User Dummy 2',
    email: 'user2@example.com',
    username: 'user2',
    password: 'password2',
  ),
  User(
    id: _uuid.v4(),
    fullName: 'Admin Account',
    email: 'admin@example.com',
    username: 'admin',
    password: 'admin123',
  ),
];
