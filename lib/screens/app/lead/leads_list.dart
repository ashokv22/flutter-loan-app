import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/screens/app/lead/edit_lead_application.dart';
import 'package:origination/service/loan_application_service.dart';

class LeadsList extends StatefulWidget {
  const LeadsList({super.key});

  @override
  State<LeadsList> createState() => _LeadsListState();
}

class _LeadsListState extends State<LeadsList> {

  Logger logger = Logger();

  int getRandomNumber() {
    int min = 0;
    int max = 20;
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  LoanApplicationService applicationService = LoanApplicationService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color.fromRGBO(193, 248, 245, 1),
              Color.fromRGBO(184, 182, 253, 1),
              Color.fromRGBO(62, 58, 250, 1),
            ]
          ),
        ),
        child: Column(
          children: [
            // Container(
            //   color: Colors.black,
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 30.0, bottom: 15, left: 5, right: 10),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             IconButton(
            //               onPressed: () {
            //                 Scaffold.of(context).openDrawer();
            //               },
            //               icon: const Icon(Icons.menu, color: Colors.white),
            //             ),
            //             const Text(
            //               'Hello Ashok\nDCB00123',
            //               style: TextStyle(
            //                 color: Colors.white, 
            //                 fontSize: 20),
            //             ),
            //           ],
            //         ),
            //         const Text(
            //           textAlign: TextAlign.right,
            //           'Jayanagar Branch\nKarnataka',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 20,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Expanded(
              child: FutureBuilder<List<ApplicantDTO>>(
                future: applicationService.getLeads(),
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
                    List<ApplicantDTO> summaries = snapshot.data!;
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
                      ApplicantDTO applicant = summaries[index];
                      String name = "${applicant.firstName!} ${applicant.lastName!}";
                      int randomNumber = getRandomNumber();
                      return GestureDetector(
                        onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditLead(id: int.parse(applicant.applicantId!))));
                              },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
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
                                        name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(255, 3, 71, 244),
                                        ),
                                      ),
                                      const Text("9916315365",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Text("DSA Name",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                                  const Text(
                                    '29/06/2023',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    decoration: ShapeDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF00CA2C), Color(0xFF00861D)],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                      child: Text(
                                        'PRE LEAD',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
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