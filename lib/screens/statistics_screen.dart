import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengeluaran Bulanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Placeholder statistik (misalnya total bulanan per kategori)
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.fastfood, color: Colors.orange),
                    title: Text('Makanan'),
                    trailing: Text('Rp 1.200.000'),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_car, color: Colors.blue),
                    title: Text('Transportasi'),
                    trailing: Text('Rp 500.000'),
                  ),
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.green),
                    title: Text('Rumah'),
                    trailing: Text('Rp 2.000.000'),
                  ),
                  ListTile(
                    leading: Icon(Icons.movie, color: Colors.purple),
                    title: Text('Hiburan'),
                    trailing: Text('Rp 750.000'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
