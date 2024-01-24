import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:origination/main.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/models/bureau_check/bc_check_list_dto.dart';
import 'package:origination/screens/widgets/reject_reason.dart';
import 'package:origination/service/bureau_check_service.dart';
import 'package:origination/service/loan_application_service.dart';

import 'coapplicant_guarantor_form.dart';

class BureauCheckList extends StatefulWidget {
  const BureauCheckList({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<BureauCheckList> createState() => _BureauCheckListState();
}

class _BureauCheckListState extends State<BureauCheckList> {

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final bureauService = BureauCheckService();
  final loanApplicationService = LoanApplicationService();
  late Future<List<CheckListDTO>> checkListFuture;
  final TextEditingController rejectReason = TextEditingController();
  bool pendingReports = true;
  bool pendingReportsLoading = false;
  bool proceedLoading = false;
  bool rejectLoading = false;
  bool approveLoading = false;

  @override
  void initState() {
    super.initState();
    refreshLeadsSummary(); // Fetch leads summary on widget initialization
  }

  Future<void> refreshLeadsSummary() async {
    setState(() {
      checkListFuture = bureauService.getAllCheckLists(widget.id);
      checkListFuture.then((checkList) {
        if (checkList.any((check) => check.status == "PENDING")) {
          setState(() {
            print("Before: $pendingReports");
            pendingReports = true;
            print("After: $pendingReports");
          });
        } else {
          print("No pending found: $pendingReports");
          pendingReports = false;
        }
      });
    });
  }

  void updateStage() async {
    try {
      setState(() {
        proceedLoading = true;
      });
      bureauService.loginPending(widget.id);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      setState(() {
        proceedLoading = false;
      });
      displayError();
    }
  }

  void generateReports() async {
    setState(() {
      pendingReportsLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      pendingReports = false;
      bureauService.generateReports(widget.id);
      pendingReportsLoading = false;
      // refreshLeadsSummary();
    });
  }

  void approveCibil(int id, CibilType type) async {
    try {
      setState(() {
        approveLoading = true;
      });
      await loanApplicationService.approveCibil(id, type.name, 800);
      setState(() {
        approveLoading = false;
      });
      refreshLeadsSummary();
    } catch(e) {
      displayError();
    }
  }

  void displayError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Something went wrong, Please try again!.'),
        duration: Duration(seconds: 2),
      ),
    );
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
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Bureau Check", style: TextStyle(fontSize: 18)),
      ),
      body: RefreshIndicator(
        onRefresh: refreshLeadsSummary,
        child: Container(
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
              ]
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: checkListFuture,
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
                    List<CheckListDTO> data  =snapshot.data!;
                    if (data.isEmpty) {
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
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        CheckListDTO checkList = data[index];
                        CibilType type = checkList.type;
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8.0),
                              border: isDarkTheme
                                      ? Border.all(color: Colors.white12, width: 1.0) // Outlined border for dark theme
                                      : null,
                              boxShadow: isDarkTheme
                                ? null // No gradient for dark theme, use a single color
                                : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), //color of shadow
                                  spreadRadius: 2, //spread radius
                                  blurRadius: 6, // blur radius
                                  offset: const Offset(2, 3),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(type.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          checkList.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            // color: Color.fromARGB(255, 3, 71, 244),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (checkList.status == ApplicantDeclarationStatus.PENDING.name)
                                      Row(
                                        children: [
                                          IconButton(
                                            color: const Color.fromARGB(255, 3, 71, 244),
                                            onPressed: () {},
                                            icon: pendingReports == true ? const Icon(Icons.edit) : const Icon(Icons.visibility_rounded)) ,
                                        ],
                                      )
                                    else if (checkList.status == ApplicantDeclarationStatus.APPROVED.name)
                                      Row(
                                        children: [
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
                                                'Approved',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    else 
                                      Row(
                                        children: [
                                          Container(
                                            decoration: ShapeDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color.fromARGB(255, 249, 33, 33), Color.fromARGB(255, 193, 3, 3)],
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                              child: Text(
                                                'Rejected',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  ],
                                ), 
                                if (checkList.status == ApplicantDeclarationStatus.PENDING.name)
                                  Row(
                                    children: [
                                      
                                      Expanded(
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(width: 2, color: Colors.green), // Green border
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Please Confirm'),
                                                  content: Text(
                                                      "Are you sure you want to Approve ${checkList.name}?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        approveCibil(checkList.id, type);
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Yes')),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('No'),
                                                    )
                                                  ],
                                                );
                                              }
                                            );
                                          }, 
                                          child: approveLoading ? const SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                          : const Text("Approve", style: TextStyle(color: Color.fromRGBO(22, 163, 74, 1))),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return RejectReason(id: checkList.id, cibilType: "INDIVIDUAL", applicantType: type, controller: rejectReason);
                                              },
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(width: 2, color: Colors.red), // Red border
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: const Text('Reject',style: TextStyle(color: Colors.red),),
                                        ),
                                      )
                                    ],
                                  )
                                else 
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(width: 2, color: Colors.blue), // Green border
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                          ),
                                          onPressed: () {}, 
                                          child: const Text("View Report", style: TextStyle(color: Colors.blue),)
                                        ),
                                      ),
                                    ],
                                  )
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
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Visibility(
                      visible: pendingReports == true,
                      replacement: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            side: BorderSide(
                              color: isDarkTheme ? Colors.blue : Colors.white, // Border color same as the solid button color
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: () {
                            updateStage();
                          },
                          child: proceedLoading ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                            : Text("Proceed", style: TextStyle(fontSize: 16, color: isDarkTheme ? Colors.blue : Colors.white),),
                        ),
                      ),
                      child: SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: const Color.fromARGB(255, 2, 161, 23),
                        textColor: Colors.white,
                        onPressed: () {
                          generateReports();
                        },
                        child: pendingReportsLoading ? const SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                          : Text("Generate Reports", style: TextStyle(fontSize: 16, color: isDarkTheme ? Colors.blue : Colors.white),),
                      ),
                    ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: const Color.fromARGB(255, 249, 33, 33),
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Please Confirm'),
                                content: const Text(
                                    "Are you sure you want to reject the lead?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes')),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
                                  )
                                ],
                              );
                            }
                          );
                        },
                        height: 50,
                        child: const Text(
                          "Reject Lead",
                          style: TextStyle(
                            fontSize: 16
                          ),
                          ),
                        ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 130.0),
        child: SpeedDial(
          buttonSize: const Size(56, 56),
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: const Color.fromARGB(255, 3, 71, 244),
          foregroundColor: Colors.white,
          activeBackgroundColor: Colors.black,
          activeForegroundColor: Colors.white,
          visible: true,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => {},
          onClose: () => {},
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.group_add),
              backgroundColor: const Color.fromARGB(255, 3, 71, 244),
              foregroundColor: Colors.white,
              label: 'Commercial',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
              ),
              labelBackgroundColor: Colors.black,
              labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
              onTap: () => {},
              onLongPress: () {},
            ),
            SpeedDialChild( //speed dial child
              child: const Icon(Icons.person_add),
              backgroundColor: const Color.fromARGB(255, 3, 71, 244),
              foregroundColor: Colors.white,
              label: 'Co Applicant / Guarantor',
              labelBackgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
              ),
              labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CoApplicantGuarantor(id: widget.id)));
              },
              onLongPress: () {},
            ),
            //add more menu item childs here
          ],
        ),
      ),
    );
  }
}