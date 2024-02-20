import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/login_flow/sections/loan_application_entity.dart';
import 'package:origination/screens/app/bureau/screens/bureau_check_list.dart';
// import 'package:origination/screens/app/login_pending/main_sections/document_upload.dart';
// import 'package:origination/screens/app/login_pending/main_sections/land_and_crop_details.dart';
// import 'package:origination/screens/app/login_pending/number_advanced.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/related_parties.dart';
import 'package:origination/screens/app/login_pending/main_sections/section_data.dart';
import 'package:origination/screens/app/login_pending/typeahead_test.dart';
import 'package:origination/service/login_flow_service.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../consent/consent_screen.dart';

class MainSectionsData extends StatefulWidget {
  const MainSectionsData({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<MainSectionsData> createState() => _MainSectionsDataState();
}

class _MainSectionsDataState extends State<MainSectionsData> {

  final loginPendingService = LoginPendingService();
  late Future<LoanApplicationEntity> leadsSummaryFuture;
  var logger = Logger();
  bool isSectionsSaved = true;
  bool isFinished = false;

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
      leadsSummaryFuture = loginPendingService.getSectionMaster(widget.id, "All");
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Details", style: TextStyle(fontSize: 16)),
      ),
      body: RefreshIndicator(
        onRefresh: refreshScreen,
        child: Container(
          decoration: BoxDecoration(
            border: isDarkTheme
            ? Border.all(color: Colors.white12, width: 1.0) // Outlined border for dark theme
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
                ]
              ),
              color: isDarkTheme ? Colors.black38 : null
            ),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: leadsSummaryFuture,
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
                      LoanApplicationEntity entity = snapshot.data!;
                      if (entity.loanSections.isEmpty) {
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
                      else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: entity.loanSections.length,
                                itemBuilder: (context, index) {
                                  LoanSection section = entity.loanSections[index];
                                  String title = section.sectionName;
                                  if (section.status == "PENDING") { 
                                    if (title == "Applicant" || title == "Deviation" || title == "InsuranceDetails" || title == "DocumentUpload") {
                                      // isSectionsSaved = true;
                                    }else {
                                      isSectionsSaved = false;
                                    }
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      if (section.sectionName == "Applicant") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => RelatedParties(id: widget.id,)));
                                      }
                                      else if (section.sectionName == "DocumentUpload") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TypeaheadTest()));  
                                      } 
                                      // else if (section.sectionName == "DocumentUpload") {
                                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => const DocumentUpload()));  
                                      // } 
                                      else if (section.sectionName == "CheckList") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => BureauCheckList(id: widget.id,)));  
                                      }
                                      // else if (section.sectionName == "LandAndCropDetails") {
                                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => LandAndCropDetials(id: widget.id, displayTitle: section.displayTitle, sectionName: section.sectionName,)));  
                                      // }
                                      else {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SectionScreenEmpty(id: widget.id, title: title,)));
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 0.50,
                                              strokeAlign: BorderSide.strokeAlignOutside,
                                              color: isDarkTheme
                                                ? Colors.white70
                                                : Colors.black87
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            section.displayTitle,
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.displayMedium!.color,
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (section.status == "COMPLETED")
                                            const Icon(
                                              CupertinoIcons.checkmark_alt_circle_fill,
                                              color: Color.fromARGB(255, 0, 152, 58),
                                              size: 22,  
                                            )
                                          else
                                            Icon(
                                              CupertinoIcons.chevron_right_circle,
                                              color: Theme.of(context).iconTheme.color,
                                              size: 22,  
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                            // const Spacer(),
                            isSectionsSaved ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SwipeableButtonView(
                                  buttonText: "Swipe to Save Loan",
                                  buttonWidget: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                  ),
                                  activeColor: const Color(0xFF009C41),
                                  isFinished: isFinished,
                                  onWaitingProcess: () {
                                    Future.delayed(const Duration(seconds: 2), () {
                                      setState(() {
                                        isFinished = true;
                                      });
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ConsentScreen(id: widget.id),));
                                    });
                                  },
                                  onFinish: () {}
                                ),
                              ),
                            ) : Container(),
                          ],
                        );
                      }
                    }
                    return Container();
                  }
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}