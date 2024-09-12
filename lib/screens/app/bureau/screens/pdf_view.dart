import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:origination/models/bureau_check/cibil_check_transaction.dart';
import 'package:origination/screens/app/login_pending/main_sections/document_upload/pdf_view_from_bytes.dart';
import 'package:origination/service/bureau_check_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:origination/service/file_service.dart';
import 'package:origination/service/login_flow_service.dart';
import 'package:path_provider/path_provider.dart';

class PdfView extends StatefulWidget {
  const PdfView({required this.id, super.key});

  final int id;

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  BureauCheckService bureauCheckService = BureauCheckService();
  final loginFlowService  = LoginPendingService();
  final fileService = FileService();

  String pdfUrl = '';
  var errorBody = {};
  bool isLoading = false;
  Logger logger = Logger();
  Uint8List? pdfBytes;
  String? filePath;

  @override
  void initState() {
    super.initState();
    fetchPdfUrl();
  }

  Future<void> fetchPdfUrl() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await bureauCheckService.getBureauReport(widget.id);

      if (response.statusCode == 200) {
        final cct = CibilCheckTransactionDTO.fromJson(json.decode(response.body));
        pdfBytes = await fetchImage(cct.fileId!);
      } else {
        throw Exception('Failed to load PDF URL');
      }
    } catch (e) {
      throw Exception('An error occurred while getting the data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.arrow_left,
          ),
        ),
        title: const Text("PDF View", style: TextStyle(fontSize: 18)),
      ),
      // backgroundColor: Colors.black,
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : PdfViewFromBytes(pdfBytes: pdfBytes!)
      ),
    );
  }

  Future<Uint8List> fetchImage(int fileId) async {
    final response = await loginFlowService.streamFile(fileId);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image: ${response.reasonPhrase}');
    }
  }

}
