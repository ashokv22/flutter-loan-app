import 'package:flutter/material.dart';
import 'package:origination/core/utils/loan_amount_formatter.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/screens/app/lead/edit_lead_application.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class LastLead extends StatefulWidget {
  const LastLead({
    super.key,
    required this.applicationService,
  });

  final LoanApplicationService applicationService;

  @override
  State<LastLead> createState() => _LastLeadState();
}

class _LastLeadState extends State<LastLead> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0, bottom: 5),
          child: Row(
            children: [
              Text(
                "New Lead",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.history,
                size: 30,
                color: Color.fromARGB(255, 59, 38, 247),
              )
            ],
          ),
        ),
        FutureBuilder(
            future: widget.applicationService.getLastApplicant(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              } else if (snapshot.hasData) {
                List<ApplicantDTO> leads = snapshot.data!;
                if (leads.isEmpty) {
                  return const Center(
                    child: Text("List Empty"),
                  );
                } else {
                  ApplicantDTO lead = leads[0];
                  double loanAmount =
                      lead.loanAmount == null ? 0.0 : lead.loanAmount!;
                  DateTime createdDate = lead.createdDate == null
                      ? DateTime.now()
                      : lead.createdDate!;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditLead(id: lead.id!, applicantId: int.parse(lead.applicantId!))));
                    },
                    child: Container(
                      width: 120,
                      height: 100,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      // padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: isDarkTheme
                            ? Border.all(
                                color: Colors.white12,
                                width: 1.0) // Outlined border for dark theme
                            : null,
                        boxShadow: isDarkTheme
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), //color of shadow
                                  spreadRadius: 2, //spread radius
                                  blurRadius: 6, // blur radius
                                  offset: const Offset(2, 3),
                                )
                              ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/new.png',
                              height: 35,
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${lead.firstName}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(lead.mobile!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                                Text(
                                    '₹${LoanAmountFormatter.transform(loanAmount)}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                Flexible(
                                    child: Text(
                                        timeago.format(createdDate,
                                            allowFromNow: true),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                return const Center(child: Text("No Lead found"));
              }
            }),
      ],
    );
  }
}
