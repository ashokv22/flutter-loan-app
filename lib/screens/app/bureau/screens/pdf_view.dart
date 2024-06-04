import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:logger/logger.dart';
import 'package:origination/service/bureau_check_service.dart';

class PdfView extends StatefulWidget {
  const PdfView({
    required this.id,
    super.key
  });

  final int id;

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {

  BureauCheckService bureauCheckService = BureauCheckService();
  String pdfUrl = '';
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchPdfUrl();
  }

  Future<void> fetchPdfUrl() async {
    final response = await bureauCheckService.getPdfUrlForIndividual(widget.id);

    if (response.statusCode == 200) {
      setState(() {
        var data = jsonDecode(response.body)['result']['cibilData'];
        pdfUrl = data[0]['cibilPdfUrl'];
      });
    } else {
      throw Exception('Failed to load PDF URL');
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
            icon: const Icon(CupertinoIcons.arrow_left,)),
      ),
      // backgroundColor: Colors.black,
      body: Center(
        child: pdfUrl.isEmpty
            ? const CircularProgressIndicator()
            : PDF(
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,
                onError: (error) {
                  logger.e(error.toString());
                },
                onPageError: (page, error) {
                  logger.e('$page: ${error.toString()}');
                },
              ).cachedFromUrl(pdfUrl),
      ),
    );
  }
}