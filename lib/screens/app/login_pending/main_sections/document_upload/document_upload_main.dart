import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/login_flow/sections/document_upload/document_specification.dart';
import 'package:origination/models/login_flow/sections/loan_application_entity.dart';
import 'package:origination/screens/app/login_pending/main_sections/document_upload.dart';
import 'package:origination/service/login_flow_service.dart';

class DocumentUploadMain extends StatefulWidget {
  const DocumentUploadMain({
    super.key,
    required this.id,
    required this.selectedType,
  });

  final int id;
  final String selectedType;

  @override
  State<DocumentUploadMain> createState() => _DocumentUploadMainState();
}

class _DocumentUploadMainState extends State<DocumentUploadMain> {
  final loginPendingService = LoginPendingService();
  late Future<LoanApplicationEntity> leadsSummaryFuture;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await refreshScreen();
  }

  Future<void> refreshScreen() async {
    setState(() {
      leadsSummaryFuture =
          loginPendingService.getSectionMaster(widget.id, "DocumentsUpload");
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Details", style: TextStyle(fontSize: 16)),
      ),
      body: RefreshIndicator(
        onRefresh: refreshScreen,
        child: Container(
          decoration: BoxDecoration(
              border: isDarkTheme
                  ? Border.all(
                      color: Colors.white12,
                      width: 1.0) // Outlined border for dark theme
                  : null,
              gradient: isDarkTheme
                  ? null // No gradient for dark theme, use a single color
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                          Colors.white,
                          Color.fromRGBO(193, 248, 245, 1),
                          Color.fromRGBO(184, 182, 253, 1),
                          Color.fromRGBO(62, 58, 250, 1),
                        ]),
              color: isDarkTheme ? Colors.black38 : null),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: leadsSummaryFuture,
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      LoanApplicationEntity entity = snapshot.data!;
                      if (entity.loanSections.isEmpty) {
                        return const SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                                child: Text(
                              'No data found',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )));
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: entity.loanSections.length,
                                  itemBuilder: (context, index) {
                                    LoanSection section =
                                        entity.loanSections[index];
                                    String title = section.sectionName;
                                    EntityTypes entityType = getEntityType(widget.selectedType);

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentUpload(id: widget.id, category: (DocumentCategory.values[index]), entityType: entityType, applicantId: 0,)));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 4.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 0.50,
                                                strokeAlign: BorderSide
                                                    .strokeAlignOutside,
                                                color: isDarkTheme
                                                    ? Colors.white70
                                                    : Colors.black87),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              section.displayTitle,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .color,
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (section.status == "COMPLETED")
                                              const Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons
                                                        .checkmark_alt_circle_fill,
                                                    color: Color.fromARGB(
                                                        255, 0, 152, 58),
                                                    size: 22,
                                                  ),
                                                ],
                                              )
                                            else
                                              Icon(
                                                CupertinoIcons
                                                    .chevron_right_circle,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                size: 22,
                                              )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        );
                      }
                    }
                    return Container();
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  EntityTypes getEntityType(String selectedType) {
    logger.i("SelectedType: $selectedType");
    if (selectedType == "APPLICANT") {
      return EntityTypes.APPLICANT;
    } else if (selectedType == "CO_APPLICANT") {
      return EntityTypes.CO_APPLICANT;
    } else if (selectedType == "GUARANTOR") {
      return EntityTypes.GUARANTOR;
    } else {
      return EntityTypes.LOAN;
    }
  }
}
