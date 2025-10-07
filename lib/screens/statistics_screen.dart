import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/services/export_service.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  Future<void> _exportData(BuildContext context, String type) async {
    try {
      if (type == 'csv') {
        await ExportService.exportToCSV();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diexport ke CSV!')),
        );
      } else if (type == 'pdf') {
        await ExportService.exportToPDF();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diexport ke PDF!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal export: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk grafik
    final Map<String, double> data = {
      'Makanan': 1200000,
      'Transportasi': 500000,
      'Rumah': 2000000,
      'Hiburan': 750000,
    };

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

            // === GRAFIK BATANG ===
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final keys = data.keys.toList();
                          if (value.toInt() < keys.length) {
                            return Text(keys[value.toInt()]);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(data.length, (index) {
                    final value = data.values.elementAt(index);
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: value.toDouble(),
                          color: Colors.blueAccent,
                          width: 22,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // === LIST DETAIL ===
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

            const SizedBox(height: 20),

            // === TOMBOL EXPORT ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _exportData(context, 'csv'),
                  icon: const Icon(Icons.file_download),
                  label: const Text('Export CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _exportData(context, 'pdf'),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
