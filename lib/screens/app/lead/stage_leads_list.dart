import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/stage.dart';
import 'package:origination/models/summaries/leads_list_dto.dart';
import 'package:origination/screens/app/lead/edit_lead_application.dart';
import 'package:origination/screens/app/lead/search_new.dart';
import 'package:origination/screens/app/lead_dashboard/rework.dart';
// import 'package:origination/screens/app/login_pending/login_pending_home.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  
  Set<int> selectedIds = Set<int>();

  void toggleSelection(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  // Helper function to check if an item is selected
  bool isItemSelected(int id) {
    return selectedIds.contains(id);
  }

  int getRandomNumber() {
    int min = 1;
    int max = 20;
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  void deleteLead(int id) async {
    logger.e("Request to delete lead for id: $id");
    try {
      applicationService.deleteLead(id);
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uh oh! There\'s something wrong!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    String stage = widget.stage;
    logger.d(stage);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lead List", style: TextStyle(fontSize: 18, textBaseline: TextBaseline.alphabetic)),
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
        //   gradient: isDarkTheme
        // ? null // No gradient for dark theme, use a single color
        // : const LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [
        //       Colors.white,
        //       Color.fromRGBO(193, 248, 245, 1),
        //       Color.fromRGBO(184, 182, 253, 1),
        //       Color.fromRGBO(62, 58, 250, 1),
        //     ],
        //   ),
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
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        key: Key(applicant.toString()),
                        onDismissed: (direction) {
                          deleteLead(applicant.id);
                          ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("${applicant.name} Deleted!")));
                        },
                        background: Container(
                            color: Colors.red,
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        child: GestureDetector(
                          onLongPress: () {
                            toggleSelection(applicant.id);
                          },
                          onTap: () {
                            if (applicant.status == ApplicationStage.REJECTED.name) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                customSnackBar(isDarkTheme, "Lead is Rejected ${applicant.id}"),
                              );
                            } else if (applicant.status == "SUBMITTED") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                customSnackBar(isDarkTheme, "Lead is Submitted ${applicant.id}"),
                              );
                            } else if (applicant.status == "REWORK") {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Rework(id: applicant.id)));
                            } else if (applicant.status == ApplicationStage.LOGIN_PENDING.name) {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPendingHome()));
                              // Edit Login Pending Leads
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditLead(id: applicant.id, applicantId: int.parse(applicant.applicantId))));
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditLead(id: applicant.id, applicantId: int.parse(applicant.applicantId))));
                            }
                          },
                          child: Container(
                            // margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            margin: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
                            padding: const EdgeInsets.all(8.0),
                            color: selectedIds.contains(applicant.id) ? Colors.blue.withOpacity(0.3) : null,
                            // decoration: BoxDecoration(
                            //   color: Theme.of(context).cardColor,
                            //   border: isDarkTheme
                            //     ? Border.all(color: Colors.white12, width: 1.0) // Outlined border for dark theme
                            //     : null,
                            //   borderRadius: BorderRadius.circular(8.0),
                            //   boxShadow: isDarkTheme
                            //     ? null : [
                            //     BoxShadow(
                            //       color: Colors.grey.withOpacity(0.5), //color of shadow
                            //       spreadRadius: 2, //spread radius
                            //       blurRadius: 6, // blur radius
                            //       offset: const Offset(2, 3),
                            //     )
                            //   ],
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    if (!isItemSelected(applicant.id))
                                      GestureDetector(
                                        onTap: () {
                                          toggleSelection(applicant.id);
                                        },
                                        child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: Image.asset('assets/images/female-${randomNumber.toString().padLeft(2, '0')}.jpg', fit: BoxFit.cover,)),
                                        ),
                                      )
                                    else
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: SizedBox(
                                          width: 55,
                                          height: 55,
                                          child: Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          applicant.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                            // color: Color.fromARGB(255, 3, 71, 244),
                                          ),
                                        ),
                                        Text(applicant.mobile,
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.displayMedium!.color,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            // applicant.dsaName,
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    // const SizedBox(height: 10),
                                    Text(
                                      applicant.model,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).textTheme.displayMedium!.color,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // const SizedBox(height: 10),
                                    Container(
                                      decoration: ShapeDecoration(
                                        gradient: applicant.status == "LEAD" ? const LinearGradient(
                                          colors: [Color(0xFF00CA2C), Color(0xFF00861D)],
                                        ) : applicant.status == "REJECTED" ? const LinearGradient(
                                          colors: [Colors.red, Colors.redAccent]
                                        ) : applicant.status == "SUBMITTED" ? const LinearGradient(
                                          colors: [Colors.deepPurple, Colors.deepPurpleAccent]
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
                                            fontSize: 8,
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

  SnackBar customSnackBar(bool isDarkTheme, String text) {
    final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    // Remove any existing snackbars
    scaffoldMessenger.removeCurrentSnackBar();

    final animationController = AnimationController(
      vsync: ScaffoldMessenger.of(context),
      duration: const Duration(milliseconds: 500),
    );
    animationController.forward();
    return SnackBar(
    showCloseIcon: true,
    elevation: 1,
    content: AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Row(
          children: <Widget>[
            Icon(Icons.info_outline, color: isDarkTheme ? Colors.black : Colors.white,),
            const SizedBox(width: 5,),
            Text(text),
          ],
        );
      },
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: isDarkTheme ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.7),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
  }
}