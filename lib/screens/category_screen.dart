import 'package:flutter/material.dart';

import '../models/category.dart'; // Pastikan path ini benar

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _controller = TextEditingController();
  
  // 🔑 SIMULASI: ID Pengguna yang sedang login.
  // Dalam aplikasi nyata, ganti ini dengan data dari sistem otentikasi (Auth).
  final String _currentUserId = 'user_a';

  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // SIMULASI: Fungsi untuk memuat kategori dari "database"
  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    // ⚠️ Dalam aplikasi nyata, panggil DatabaseService.getCategoriesByUserId(_currentUserId)
    await Future.delayed(const Duration(milliseconds: 700)); // Simulasi loading

    // SIMULASI DATA AWAL (hanya dimuat saat pertama kali state dibuat)
    final List<Category> initialData = [
      Category(id: '1', name: "Makanan", icon: "🍔", userId: _currentUserId),
      Category(id: '2', name: "Transportasi", icon: "🚌", userId: _currentUserId),
      Category(id: '3', name: "Hiburan", icon: "🎬", userId: _currentUserId),
    ];

    setState(() {
      // Dalam simulasi ini, kita hanya menggunakan data awal.
      // Dalam implementasi nyata, data ini akan diambil dari DB yang sudah terfilter oleh userId.
      _categories = initialData; 
      _isLoading = false;
    });
  }

  // MODIFIKASI: Menambahkan userId saat membuat kategori baru
  void _addCategory(String name) async { // Jadikan async untuk simulasi penyimpanan
    if (name.isEmpty) return;
    
    final newCategory = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      icon: "📌", 
      userId: _currentUserId, // KUNCI: Menambahkan ID Pengguna ke objek Category
    );
    
    // ⚠️ Dalam aplikasi nyata, simpan 'newCategory' ke database persisten di sini.
    await Future.delayed(const Duration(milliseconds: 100)); // Simulasi penyimpanan

    setState(() {
      _categories.add(newCategory);
    });
    _controller.clear();
  }

  // MODIFIKASI: Menghapus kategori (dan seharusnya dari database)
  void _deleteCategory(int index) async { // Jadikan async untuk simulasi penghapusan
    // final categoryToDelete = _categories[index];
    
    // ⚠️ Dalam aplikasi nyata, panggil DatabaseService.deleteCategory(categoryToDelete.id) di sini.
    await Future.delayed(const Duration(milliseconds: 100)); // Simulasi penghapusan
    
    setState(() {
      _categories.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Kategori"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Input tambah kategori
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Nama Kategori",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addCategory(_controller.text),
                  child: const Text("Tambah"),
                ),
              ],
            ),
          ),

          // Daftar kategori
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator()) // Tampilkan loading
                : ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Text(category.icon, style: const TextStyle(fontSize: 24)), 
                          title: Text(category.name),
                          // Subtitle menunjukkan pemilik (untuk debugging, bisa dihapus)
                          subtitle: Text('Owner ID: ${category.userId}'), 
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}