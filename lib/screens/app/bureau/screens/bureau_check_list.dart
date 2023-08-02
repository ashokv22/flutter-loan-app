import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/models/bureau_check/individual.dart';
import 'package:origination/screens/widgets/reject_reason.dart';
import 'package:origination/service/bureau_check_service.dart';

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
  final TextEditingController rejectReason = TextEditingController();

  Future<void> refreshLeadsSummary() async {
  setState(() {
    
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Bureau Check"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshLeadsSummary,
        child: Container(
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
              Expanded(
                child: FutureBuilder(
                  future: bureauService.getIndividuals(widget.id),
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
                    List<Individual> data  =snapshot.data!;
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
                        Individual individual = data[index];
                        IndividualType type = individual.type!;
                        String name = "${individual.firstName} ${individual.lastName}";
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
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
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            // color: Color.fromARGB(255, 3, 71, 244),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (individual.status == ApplicantDeclarationStatus.PENDING)
                                      Row(
                                        children: [
                                          IconButton(
                                            color: const Color.fromARGB(255, 3, 71, 244),
                                            onPressed: () {},
                                            icon: const Icon(Icons.edit)),
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
                                if (individual.status == ApplicantDeclarationStatus.PENDING)
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
                                          onPressed: () {}, 
                                          child: const Text("Accept", style: TextStyle(color: Color.fromRGBO(22, 163, 74, 1))),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return RejectReason(id: individual.id!, cibilType: "INDIVIDUAL", applicantType: type, controller: rejectReason);
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
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: MaterialButton(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30.0),
                    //     ),
                    //     color: const Color.fromARGB(255, 3, 71, 244),
                    //     textColor: Colors.white,
                    //     padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //     onPressed: () {
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => CoApplicantGuarantor(id: widget.id)));
                    //     },
                    //     height: 50,
                    //     child: const Text(
                    //       "Add Co Applicant/Guarantor",
                    //       style: TextStyle(
                    //         fontSize: 16
                    //       ),
                    //       ),
                    //     ),
                    // ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          side: const BorderSide(
                            color: Colors.white, // Border color same as the solid button color
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        onPressed: () {
                          // Add your action here
                        },
                        child: const Text(
                          "Proceed",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Text color same as the solid button color
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
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