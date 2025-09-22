class Expense {
  final String title;
  final String description;
  final String category;
  final double amount;
  final DateTime date;

  Expense({
    required this.title,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
  });

  // Format tanggal manual (dd/MM/yyyy)
  String get formattedDate {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$day/$month/$year";
  }

  // Format rupiah manual
  String get formattedAmount {
    return "Rp ${amount.toStringAsFixed(0)}";
  }
}
