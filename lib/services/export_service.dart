import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportService {
  /// Export ke CSV — mengembalikan File yang dibuat.
  /// rows: optional, jika null gunakan data dummy.
  static Future<File> exportToCSV({List<List<dynamic>>? rows}) async {
    if (kIsWeb) {
      throw UnsupportedError('Export ke CSV tidak didukung di Web.');
    }

    final data = rows ??
        [
          ['Kategori', 'Jumlah (Rp)'],
          ['Makanan', 1200000],
          ['Transportasi', 500000],
          ['Rumah', 2000000],
          ['Hiburan', 750000],
        ];

    final csvData = const ListToCsvConverter().convert(data);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/pengeluaran_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csvData);
    return file;
  }

  /// Export ke PDF — mengembalikan File yang dibuat.
  /// rows: optional, jika null gunakan data dummy.
  static Future<File> exportToPDF({List<List<String>>? rows}) async {
    if (kIsWeb) {
      throw UnsupportedError('Export ke PDF tidak didukung di Web.');
    }

    final data = rows ??
        [
          ['Kategori', 'Jumlah (Rp)'],
          ['Makanan', '1.200.000'],
          ['Transportasi', '500.000'],
          ['Rumah', '2.000.000'],
          ['Hiburan', '750.000'],
        ];

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text('Laporan Pengeluaran Bulanan',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          pw.Table.fromTextArray(headers: data.first, data: data.sublist(1)),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/laporan_pengeluaran_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
