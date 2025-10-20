import 'package:intl/intl.dart';

class Expense {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
  });

  /// 🔹 Copy untuk update sebagian data
  Expense copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? category,
    double? amount,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  /// 🔹 Format tanggal dan jumlah uang
  String get formattedDate => DateFormat('dd MMM yyyy').format(date);

  String get formattedAmount =>
      'Rp ${NumberFormat("#,##0", "id_ID").format(amount)}';

  /// 🔹 Konversi dari Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      amount: map['amount'].toDouble(),
      date: DateTime.parse(map['date']),
    );
  }

  /// 🔹 Konversi ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
