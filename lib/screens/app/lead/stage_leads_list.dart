

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/stage.dart';
import 'package:origination/models/summaries/leads_list_dto.dart';
import 'package:origination/screens/app/lead/edit_lead_application.dart';
import 'package:origination/screens/app/lead/search_new.dart';
import 'package:origination/screens/app/login_pending/login_pending_home.dart';
import 'package:origination/service/loan_application_service.dart';

class StageLeadList extends StatefulWidget {
  final String stage;
  const StageLeadList({
    super.key,
    required this.stage
  });

  @override
  State<StageLeadList> createState() => _StageLeadListState();
}

class _StageLeadListState extends State<StageLeadList> {

  Logger logger = Logger();

  LoanApplicationService applicationService = LoanApplicationService();
  
  int getRandomNumber() {
    int min = 1;
    int max = 20;
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    String stage = widget.stage;
    logger.d(stage);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lead List"),
        actions: [
          IconButton(
            onPressed: () {
              const SearchPage();
            },
            icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
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
            ],
          ),
          color: isDarkTheme ? Colors.black38 : null
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<LeadsListDTO>>(
                future: applicationService.getLeadsByStage(stage),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator()
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    List<LeadsListDTO> summaries = snapshot.data!;
                        if (summaries.isEmpty) {
                          return const SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: Text('No data found',
                              style: TextStyle(
                                fontSize: 20,
                              ),)
                            )
                          );
                        }
                    return ListView.builder(
                    itemCount: summaries.length,
                    itemBuilder: (context, index) {
                      LeadsListDTO applicant = summaries[index];
                      int randomNumber = getRandomNumber();
                      return GestureDetector(
                        onTap: () {
                          if (applicant.status == ApplicationStage.REJECTED.name) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                showCloseIcon: true,
                                elevation: 1,
                                backgroundColor: Colors.black,
                                content: Text('Lead is Rejected.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else if (applicant.status == ApplicationStage.LOGIN_PENDING.name) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPendingHome(id: applicant.id,)));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditLead(id: applicant.id, applicantId: int.parse(applicant.applicantId))));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: isDarkTheme
                              ? Border.all(color: Colors.white12, width: 1.0) // Outlined border for dark theme
                              : null,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: isDarkTheme
                              ? null : [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), //color of shadow
                                spreadRadius: 2, //spread radius
                                blurRadius: 6, // blur radius
                                offset: const Offset(2, 3),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset('assets/images/female-${randomNumber.toString().padLeft(2, '0')}.jpg', fit: BoxFit.cover,)),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        applicant.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                          // color: Color.fromARGB(255, 3, 71, 244),
                                        ),
                                      ),
                                      Text(applicant.mobile,
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.displayMedium!.color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(applicant.dsaName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).textTheme.displayMedium!.color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${applicant.createdDate.year.toString()}-${applicant.createdDate.month.toString().padLeft(2,'0')}-${applicant.createdDate.day.toString().padLeft(2,'0')}",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.displayMedium!.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  // const SizedBox(height: 10),
                                  Text(
                                    applicant.model,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).textTheme.displayMedium!.color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: ShapeDecoration(
                                      gradient: applicant.status == "LEAD" ? const LinearGradient(
                                        colors: [Color(0xFF00CA2C), Color(0xFF00861D)],
                                      ) : applicant.status == "REJECTED" ? const LinearGradient(
                                        colors: [Colors.red, Colors.redAccent]
                                      ) : const LinearGradient(
                                        colors: [Colors.blue, Colors.blueAccent]
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                                      child: Text(
                                        applicant.status,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  );
                  } else {
                    return Container();
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}