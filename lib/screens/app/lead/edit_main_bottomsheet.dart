import 'package:flutter/material.dart';
import 'package:origination/models/summaries/leads_list_dto.dart';
import 'package:origination/screens/app/lead/edit_lead_application.dart';
import 'package:origination/screens/app/login_pending/main_sections/main_sections_data.dart';

class EditMainBottomSheet extends StatelessWidget {
  const EditMainBottomSheet({
    super.key,
    required this.applicant,
  });

  final LeadsListDTO applicant;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Choose stage',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditLead(id: applicant.id, applicantId: int.parse(applicant.applicantId))));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 3, 71, 244),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Icon(Icons.edit_document, size: 44, color: Color.fromARGB(255, 3, 71, 244),),
                        Text("Lead", style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainSectionsData(id: applicant.id, completedSections: 10)));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 0, 129, 5),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Icon(Icons.format_list_bulleted, size: 44, color: Color.fromARGB(
                            255, 0, 129, 5),),
                        Text("Sections", style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
