import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/login_flow/sections/document_upload/document_specification.dart';
import 'package:origination/models/login_flow/sections/loan_application_entity.dart';
import 'package:origination/screens/app/bureau/screens/bureau_check_list.dart';
import 'package:origination/screens/app/login_pending/main_sections/deviations.dart';
import 'package:origination/screens/app/login_pending/main_sections/document_upload/document_upload_main.dart';
import 'package:origination/screens/app/login_pending/main_sections/helper_widgets/submit_dialog.dart';
import 'package:origination/screens/app/login_pending/main_sections/section_data.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/related_parties.dart';
import 'package:origination/service/login_flow_service.dart';

class Rework extends StatefulWidget {
  const Rework({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<Rework> createState() => _ReworkState();
}

class _ReworkState extends State<Rework> {

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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentUploadMain(id: widget.id, selectedType: EntityTypes.LOAN.name,)));
                                      } 
                                      else if (section.sectionName == "CheckList") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => BureauCheckList(id: widget.id,)));  
                                      }
                                      else if (section.sectionName == "Deviation") {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Deviations(applicantId: widget.id,)));  
                                      }
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
                                            Row(
                                              children: [
                                                const Icon(
                                                  CupertinoIcons.checkmark_alt_circle_fill,
                                                  color: Color.fromARGB(255, 0, 152, 58),
                                                  size: 22,  
                                                ),
                                                const SizedBox(width: 10,),
                                                InkWell(
                                                  onTap: () {},
                                                  child: const HeroIcon(
                                                    HeroIcons.trash,
                                                    color: Colors.red,
                                                    size: 22, 
                                                  ),
                                                ),
                                              ],
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: MaterialButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context, 
                                          builder: (context) => ConstrainedBox(
                                            constraints: const BoxConstraints(minHeight: 150),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width, 
                                              child: SubmitDialog(loanApplicationId: widget.id)
                                            ),
                                          )
                                        );
                                    },
                                    color: const Color.fromARGB(255, 6, 139, 26),
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: const Text('Update Loan'),
                                  ),
                                ),
                              ),
                            ),
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