class Category {
  final String id;
  final String name;
  final String icon;
  final String userId; // WAJIB: Field untuk menyimpan ID Pengguna

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.userId,
  });
}