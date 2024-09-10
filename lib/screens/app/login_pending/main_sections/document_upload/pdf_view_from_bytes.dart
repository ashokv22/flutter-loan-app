import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';

class PdfViewFromBytes extends StatefulWidget {
  const PdfViewFromBytes({
    super.key,
    required this.pdfBytes,
  });
  
  final Uint8List pdfBytes;

  @override
  State<PdfViewFromBytes> createState() => _PdfViewFromBytesState();
}

class _PdfViewFromBytesState extends State<PdfViewFromBytes> {
  String? filePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        try {
          // Save the PDF bytes to a temporary file
          final tempDir = await getTemporaryDirectory(); // Fetch the temporary directory
          final pdfFile = File('${tempDir.path}/temp_document.pdf'); // Create a file path for the PDF
          await pdfFile.writeAsBytes(widget.pdfBytes); // Write PDF bytes to the file

          // Open the PDF file using the default PDF viewer on the device
          await OpenFilex.open(pdfFile.path);
        } catch (e) {
          // Handle error if PDF cannot be opened
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error opening PDF: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: const Text("View PDF"),
    );
  }
}