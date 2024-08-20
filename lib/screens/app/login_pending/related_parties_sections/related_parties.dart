import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:logger/logger.dart';
// import 'package:origination/core/widgets/dropdown.dart';
import 'package:origination/core/widgets/custom/related_parties_dropdown.dart';
import 'package:origination/models/bureau_check/bc_check_list_dto.dart';
import 'package:origination/models/login_flow/sections/document_upload/document_specification.dart';
import 'package:origination/models/login_flow/sections/loan_application_entity.dart';
import 'package:origination/models/login_flow/sections/related_party/primary_kyc_dto.dart';
import 'package:origination/models/login_flow/sections/related_party/secondary_kyc_dto.dart';
import 'package:origination/screens/app/login_pending/main_sections/document_upload.dart';
import 'package:origination/screens/app/login_pending/main_sections/document_upload/document_upload_main.dart';
import 'package:origination/screens/app/login_pending/main_sections/helper_widgets/confirm_delete_sheet.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/primary_kyc/primary_kyc_home.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/secondary_kyc/secondary_kyc_home.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/section_data_rp.dart';
import 'package:origination/service/bureau_check_service.dart';
import 'package:origination/service/kyc_service.dart';
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
  KycService kycService = KycService();

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

  Future<SecondaryKYCDTO> getSecondaryKyc(int relatedPartyId) async {
    return await kycService.getSecondaryKyc(relatedPartyId.toString());
  }

  Future<PrimaryKycDTO> getPrimaryKyc(int relatedPartyId) async {
    return await kycService.getPrimaryKyc(relatedPartyId.toString());
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
                      if (section.status == "COMPLETED") {
                        aadharCardSheet(context, section);
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PrimaryKycHome(applicationId: widget.id, relatedPartyId: relatedPartyId, type: selectedType,)));
                      }
                    }
                    else if (section.sectionName == "SecondaryKYC") {
                      if (section.status == "COMPLETED") {
                        panCardSheet(context, section);
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SecondaryKycHome(relatedPartyId: relatedPartyId, type: selectedType)));
                      }
                    }
                    else if (section.sectionName == "RelatedPartyDocumentUpload") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentUpload(id: relatedPartyId, category: DocumentCategory.APPLICANT, entityType: EntityTypes.APPLICANT,)));
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
                      SizedBox(
                        width: 250,
                        child: Text(
                          section.displayTitle,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.displayMedium!.color,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ConfirmDeleteSheet(
                                          onDeleted: () {
                                            _fetchLoanSection(selectedType);
                                          },
                                          loanApplicationId: relatedPartyId,
                                          section: section
                                      )),
                                );
                              },
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
          );
        }
      }
      return Container();
    }
    );
  }

  Future<dynamic> panCardSheet(BuildContext context, LoanSection section) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (context) {
        return SizedBox(
          height: 250,
          child: FutureBuilder(
            future: getSecondaryKyc(relatedPartyId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sit tight while we fetch the Data for PAN no: ${section.id!}"),
                        const SizedBox(height: 10),
                        const CircularProgressIndicator(),
                      ],
                    )
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Uh oh! Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                SecondaryKYCDTO result = snapshot.data!;
                logger.wtf(result.toJson());
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      const Text(
                        "Pan Details",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Lucida Sans',
                            fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Name:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                          const SizedBox(width: 5),
                          Text(result.name, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Father Name:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                          const SizedBox(width: 5),
                          Text(result.fatherName!, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Date of Birth:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                          const SizedBox(width: 5),
                          Text(result.dateOfBirth != null ? '${result.dateOfBirth!.year}/${result.dateOfBirth!.month}/${result.dateOfBirth!.day}' : 'null', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18))
                        ],
                      ),
                        const SizedBox(height: 10),
                      // ignore: unnecessary_null_comparison
                      result.isVerified != null ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Is Verified:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                          const SizedBox(width: 5),
                          Text(result.isVerified.toString().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                        ],
                      ) : Container(),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }
          ),
        );
      }
    );
  }

  Future<dynamic> aadharCardSheet(BuildContext context, LoanSection section) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (context) {
        return SizedBox(
          height: 300,
          child: FutureBuilder(
            future: getPrimaryKyc(relatedPartyId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sit tight while we fetch the Data for PAN no: ${section.id!}"),
                        const SizedBox(height: 10),
                        const CircularProgressIndicator(),
                      ],
                    )
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                PrimaryKycDTO result = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      const Text(
                        "Aadhaar Details Details",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Lucida Sans',
                            fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      if (result.photoBase64 != null) ...[
                        Image.memory(const Base64Decoder().convert(result.photoBase64!), width: 60, fit: BoxFit.contain,),
                      ] else ...[
                        const Text("Manual Aadhaar"),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Name:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                          const SizedBox(width: 5),
                          Text(result.name, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (result.fatherName != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Father Name:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                            const SizedBox(width: 5),
                            Text(result.fatherName!, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (result.yearOfBirth != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Date of Birth:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                            const SizedBox(width: 5),
                            if (result.yearOfBirth!.isNotEmpty)...[
                              Text(result.yearOfBirth!, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                            ] else ...[
                              Text(result.dateOfBirth!, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                            ]
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Address:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
                          const SizedBox(width: 5),
                          Flexible(child: Text(result.address, overflow: TextOverflow.visible, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14))),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }
          ),
        );
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