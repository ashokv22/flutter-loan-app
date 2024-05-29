import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:origination/models/login_flow/sections/application_reject_reason_history.dart';
import 'package:origination/service/login_flow_service.dart';

class Deviations extends StatefulWidget {
  const Deviations({
    super.key,
    required this.applicantId,
    });

  final int applicantId;

  @override
  State<Deviations> createState() => _DeviationsState();
}

class _DeviationsState extends State<Deviations> {

  late Future<List<ApplicationRejectReasonHistory>> _deviationFuture;
  LoginPendingService loginPendingService = LoginPendingService();

  @override
  void initState() {
    super.initState();
    _deviationFuture = getDeviation();
  }

  Future<List<ApplicationRejectReasonHistory>> getDeviation() async {
    return loginPendingService.getDeviations(widget.applicantId);
  }


  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Deviation", style: TextStyle(fontSize: 18))),
      body: Container(
        decoration: BoxDecoration(
            border: isDarkTheme
            ? Border.all(color: Colors.white12, width: 1.0)
            : null,
              gradient: isDarkTheme
                ? null
                : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color.fromRGBO(193, 248, 245, 1),
                  Color.fromRGBO(184, 182, 253, 1),
                  Color.fromRGBO(62, 58, 250, 1),
                ]
              ),
              color: isDarkTheme ? Colors.black38 : null
          ),
        child: Column(
          children: [
            FutureBuilder<List<ApplicationRejectReasonHistory>>(
              future: _deviationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(), // Display spinner while waiting
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final rejectReasons = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: rejectReasons.length,
                      itemBuilder: (BuildContext context, int index) {
                        var rejectReason = rejectReasons[index];
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8.0),
                              border: isDarkTheme
                                  ? Border.all(color: Colors.white12, width: 1.0)
                                  : null,
                              boxShadow: isDarkTheme
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                        offset: const Offset(2, 3),
                                      )
                                    ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Action Required: ${rejectReason.actionRequired}'),
                                Text("Status: \t\t${rejectReason.reasonForRejection}"),
                                Text("Document reject reasons: \t\t${rejectReason.documentRejectionReason}"),
                                Text('Reviwer remarks: \t\t${rejectReason.reviewerRemarks}'),
                                Text('At: \t\t${rejectReason.historyDateTime}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      )
    );
  }
}