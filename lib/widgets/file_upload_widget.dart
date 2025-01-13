import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import '../providers/chat_provider.dart';

class FileUploadWidget extends StatefulWidget {
  const FileUploadWidget({Key? key}) : super(key: key);

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  bool _isLoading = false;

  String parseCsv(String csvContent) {
    try {
      final List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter()
          .convert(csvContent, eol: '\n', shouldParseNumbers: true);

      if (rowsAsListOfValues.isEmpty) {
        return 'الملف فارغ';
      }

      final headers = rowsAsListOfValues[0];

      StringBuffer textContent = StringBuffer();
      textContent.writeln('تحليل البيانات المالية:\n');

      textContent.writeln('الأعمدة الموجودة في التقرير:');
      headers.forEach((header) {
        textContent.writeln('- $header');
      });
      textContent.writeln();

      textContent.writeln('ملخص البيانات:');
      for (int i = 1; i < rowsAsListOfValues.length; i++) {
        textContent.writeln('صف ${i}:');
        for (int j = 0; j < headers.length; j++) {
          textContent.writeln('${headers[j]}: ${rowsAsListOfValues[i][j]}');
        }
        textContent.writeln();
      }

      return textContent.toString();
    } catch (e) {
      return 'حدث خطأ في معالجة ملف CSV: $e';
    }
  }

  Future<void> _pickFile() async {
    try {
      setState(() => _isLoading = true);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.extension?.toLowerCase() == 'csv') {
          // قراءة محتوى الملف كنص
          final csvContent = String.fromCharCodes(file.bytes!);

          // معالجة ملف CSV
          final parsedContent = parseCsv(csvContent);

          // إرسال المحتوى المعالج إلى ChatGPT للتحليل
          if (!mounted) return;
          final provider = Provider.of<ChatProvider>(context, listen: false);
          await provider.analyzeFile(parsedContent);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _pickFile,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.upload_file),
            label:
                Text(_isLoading ? 'جاري المعالجة...' : 'رفع ملف CSV للتحليل'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (_isLoading) ...[
            const SizedBox(height: 16),
            const Text('جاري تحليل الملف...'),
          ],
        ],
      ),
    );
  }
}
