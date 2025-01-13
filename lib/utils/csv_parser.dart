import 'package:csv/csv.dart';

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
