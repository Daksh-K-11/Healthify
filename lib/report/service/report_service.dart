import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthify/core/constant.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

void showEvaluationBottomSheet(String report, BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Markdown(
                data: report,
                controller: scrollController,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await _downloadPdf(report);
              },
              icon: const Icon(Icons.download),
              label: const Text("Download PDF"),
            ),
          ],
        ),
      ),
    ),
  );
}

final healthReportProvider = FutureProvider<String>((ref) async {
  final url = Uri.parse("$baseUrl/auth/health-evaluation/");
  try {
    final response = await http.post(
      url,
      headers: headersForAuth,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['health_report'] as String? ?? "No report available.";
    } else {
      return "Error: ${response.statusCode}";
    }
  } catch (e) {
    return "Error: $e";
  }
});

Future<void> _downloadPdf(String report) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Padding(
        padding: const pw.EdgeInsets.all(16),
        child: pw.Text(report),
      ),
    ),
  );
  await Printing.sharePdf(
      bytes: await pdf.save(), filename: "health_report.pdf");
}
