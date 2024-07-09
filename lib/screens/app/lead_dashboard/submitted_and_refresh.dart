import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/applicant/entity_state_manager.dart';
import 'package:origination/models/summaries/leads_list_dto.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:origination/service/login_flow_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class SubmittedAndRefresh extends StatefulWidget {
  const SubmittedAndRefresh({
    super.key,
    required this.stage,
  });

  final String stage;

  @override
  State<SubmittedAndRefresh> createState() => _SubmittedAndRefreshState();
}

class _SubmittedAndRefreshState extends State<SubmittedAndRefresh> {
  final Logger logger = Logger();
  final LoanApplicationService applicationService = LoanApplicationService();
  final LoginPendingService loginPendingService = LoginPendingService();

  EntityStateManager? esm;

  List<LeadsListDTO> summaries = [];
  List<bool> isButtonLoading = [];
  bool isLoading = false;

  int getRandomNumber() {
    final Random random = Random();
    return random.nextInt(20) + 1;
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      summaries = await applicationService.getLeadsByStage(widget.stage);
      isButtonLoading = List.filled(summaries.length, false);
    } catch (e) {
      logger.e('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void refreshStatus(int index, int applicantId) async {
    setState(() {
      isButtonLoading[index] = true;
    });
    try {
      esm = await loginPendingService.refreshStatus(applicantId);
      if (esm != null) {
        _showStatusBottomSheet(esm!);
      }
    } catch (e) {
      showSnackBar("There's something wrong with this application!");
    } finally {
      setState(() {
        isButtonLoading[index] = false;
      });
    }
    
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
        ),
    );
  }

  void _showStatusBottomSheet(EntityStateManager esm) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: 200,
          // padding: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(esm.toJson().toString()),
                if (esm.status == "PENDING") ...[
                  const Text("Submitted waitign for Approval"),
                ] else if (esm.status == "SUBMITTED") ...[
                  const Text('Still in submitted')
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submitted List", style: TextStyle(fontSize: 18, textBaseline: TextBaseline.alphabetic)),
      ),
      body: Container(
        decoration: BoxDecoration(
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
                ]),
          color: isDarkTheme ? Colors.black38 : null),
        child: Column(
          children: [
            Expanded(
              child: summaries.isEmpty
                ? const Center(
                    child: Text(
                    'No data found',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ))
                : ListView.builder(
                    itemCount: summaries.length,
                    itemBuilder: (context, index) {
                      final LeadsListDTO applicant = summaries[index];
                      final int randomNumber = getRandomNumber();
                      return Container(
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
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 55,
                                        height: 55,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Image.asset(
                                              'assets/images/female-${randomNumber.toString().padLeft(2, '0')}.jpg',
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              applicant.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: isDarkTheme
                                                    ? Colors.blueAccent[400]
                                                    : const Color.fromARGB(255, 3, 71, 244),
                                                overflow: TextOverflow.ellipsis
                                              ),
                                            ),
                                          ),
                                          Text(
                                            applicant.mobile,
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.displayMedium!.color,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              "ID: ${applicant.id}, AppID:${applicant.applicantId}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context).textTheme.displayMedium!.color,
                                                fontWeight: FontWeight.w400,
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
                                        timeago.format(applicant.createdDate, allowFromNow: true),
                                        style: TextStyle(
                                            color: Theme.of(context).textTheme.displayMedium!.color,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          applicant.model,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).textTheme.displayMedium!.color,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: MaterialButton(
                                  autofocus: false,
                                  onPressed: () {
                                    refreshStatus(index, applicant.id);
                                  },
                                  color: const Color.fromARGB(255, 3, 71, 244),
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: isButtonLoading[index] ? const SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                : const Text(
                                    'Refresh Status',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
