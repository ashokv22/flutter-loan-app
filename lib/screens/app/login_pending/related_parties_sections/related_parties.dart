import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:origination/core/widgets/dropdown.dart';
import 'package:origination/core/widgets/custom/related_parties_dropdown.dart';
import 'package:origination/models/bureau_check/bc_check_list_dto.dart';
import 'package:origination/models/login_flow/sections/loan_application_entity.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/primary_kyc/primary_kyc_home.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/secondary_kyc/secondary_kyc_home.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/section_data_rp.dart';
import 'package:origination/service/bureau_check_service.dart';
import 'package:origination/service/login_flow_service.dart';

class RelatedParties extends StatefulWidget {
  const RelatedParties({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<RelatedParties> createState() => _RelatedPartiesState();
}

class _RelatedPartiesState extends State<RelatedParties> {

  final loginPendingService = LoginPendingService();
  final bureauCheckService = BureauCheckService();
  var logger = Logger();

  String selectedType = "APPLICANT";
  late int relatedPartyId = 0;
  TextEditingController controller = TextEditingController();
  // List<CheckListDTO> applicantsData = [];
  late LoanApplicationEntity sectionsData;
  late List<String> options = [];

  @override
  void initState() {
    super.initState();
    // initializeApplicantsAndSections();
  }

  // Future<void> initializeApplicantsAndSections() async {
  //   sectionsData = await _fetchLoanSection("MainSection");
  //   setState(() {});
  // }

  Future<LoanApplicationEntity> _fetchLoanSection(String sectionName) async {
    return await loginPendingService.getSectionMaster(relatedPartyId, selectedType);
  }

  Future<List<CheckListDTO>> initializeApplicants() async {
    return await bureauCheckService.getAllCheckLists(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Related Parties", style: TextStyle(fontSize: 16),),
      ),
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  padding: const EdgeInsets.all(8.0),
                  child: RelatedPartiedsDropdown(
                    label: "Related Parties",
                    controller: controller,
                    id: widget.id,
                    onChanged: (newValue) => updateFieldValue(newValue!),
                  )
                ),
                Expanded(
                  child: buildSectionsWidget()
                ),
              ],
            ),
      ),
    );
  }

  Widget buildSectionsWidget() {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder(
      future: _fetchLoanSection(selectedType),
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
          } else {
            return ListView.builder(
              itemCount: entity.loanSections.length,
              itemBuilder: (context, index) {
                LoanSection section = entity.loanSections[index];
                return GestureDetector(
                  onTap: () {
                    if (section.sectionName == "PrimaryKYC") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PrimaryKycHome(applicationId: widget.id, relatedPartyId: relatedPartyId,)));
                    }
                    else if (section.sectionName == "SecondaryKYC") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SecondaryKycHome(relatedPartyId: relatedPartyId,)));
                    }
                    else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SectionScreenRP(id: relatedPartyId, entitySubType: selectedType, title: section.sectionName,)));
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
          );
        }
      }
      return Container();
    }
    );
  }

  void updateFieldValue(String newValue) async {
    logger.i(newValue);
    setState(() {
      selectedType = newValue.split(" - ").first;
      relatedPartyId = int.parse(newValue.split(" - ").last);
    });
    sectionsData = await _fetchLoanSection(selectedType);
  }
}