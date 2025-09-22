import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Category> _categories = [
    Category(id: '1', name: "Makanan", icon: "🍔"),
    Category(id: '2', name: "Transportasi", icon: "🚌"),
    Category(id: '3', name: "Hiburan", icon: "🎬"),
  ];

void _addCategory(String name) {
    if (name.isEmpty) return;
    setState(() {
      _categories.add(
        Category(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // auto unique id
          name: name,
          icon: "📌", // default icon
        ),
      );
    });
    _controller.clear();
  }

  void _deleteCategory(int index) {
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
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(category.name),
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
