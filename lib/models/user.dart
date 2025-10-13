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
