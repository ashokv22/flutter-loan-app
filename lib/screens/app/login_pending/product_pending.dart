import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/login_flow/sections/loan_application_entity.dart';
import 'package:origination/screens/app/login_pending/related_parties.dart';
import 'package:origination/screens/app/login_pending/section_screen_empty.dart';
import 'package:origination/service/login_flow_service.dart';

class ProductPending extends StatefulWidget {
  const ProductPending({super.key});

  @override
  State<ProductPending> createState() => _ProductPendingState();
}

class _ProductPendingState extends State<ProductPending> {

  final loginPendingService = LoginPendingService();
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Details"),
      ),
      body: Container(
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
                future: loginPendingService.getSectionMaster("MainSection"),
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
                      return ListView.builder(
                        itemCount: entity.loanSections.length,
                        itemBuilder: (context, index) {
                          LoanSection section = entity.loanSections[index];
                          String title = section.sectionName;
                          return GestureDetector(
                            onTap: () {
                              if (section.sectionName == "Applicant") {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RelatedParties()));
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SectionScreenEmpty(title: title,)));
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              padding: const EdgeInsets.all(16.0),
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
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    CupertinoIcons.chevron_right_circle_fill,
                                    color: Theme.of(context).iconTheme.color,)
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
              )
            )
          ],
        ),
      ),
    );
  }
}