import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/bureau_check/cibil_check_transaction.dart';
import 'package:origination/service/bureau_check_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:origination/service/file_service.dart';

class PdfView extends StatefulWidget {
  const PdfView({required this.id, super.key});

  final int id;

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  BureauCheckService bureauCheckService = BureauCheckService();
  final fileService = FileService();

  String pdfUrl = '';
  var errorBody = {};
  bool isLoading = false;
  Logger logger = Logger();

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
        final cct =
            CibilCheckTransactionDTO.fromJson(json.decode(response.body));
        errorBody = cct.toJson();
        if (cct.cibilResponse != null) {
          pdfUrl = jsonDecode(response.body)['result']['cibilData'][0]
              ['cibilPdfUrl'];
        }
        setState(() {
          var data = jsonDecode(response.body)['result']['cibilData'];
          pdfUrl = data[0]['cibilPdfUrl'];
        });
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
            : pdfUrl.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Generating PDF may take a while!',
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          '${errorBody.toString()}\n',
                          style: GoogleFonts.sourceCodePro(
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    ],
                  )
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
