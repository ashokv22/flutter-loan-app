import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/models/applicant/entity_state_manager.dart';
import 'package:origination/models/login_flow/sections/e_sign/e_sign_urls.dart';
import 'package:origination/models/login_flow/sections/e_sign/invitee_urls.dart';
import 'package:origination/service/entity_state_manager_service.dart';

class ESignRpList extends StatefulWidget {
  const ESignRpList({
    super.key,
    required this.applicantId,
  });

  final int applicantId;

  @override
  State<ESignRpList> createState() => _ESignRpListState();
}

class _ESignRpListState extends State<ESignRpList> {

  final esmService = EntityStateManagerService();
  late Future<EntityStateManager> esmFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeServices();
  }

  Future<void> initializeServices() async {
    await refreshScreen();
  }

  Future<void> refreshScreen() async {
    setState(() {
      esmFuture = esmService.getESMFutureByApplicantId(widget.applicantId);
    });
  }

  int getRandomNumber() {
    final Random random = Random();
    return random.nextInt(20) + 1;
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
            icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Initiate E-Sign Loan Documents", style: TextStyle(fontSize: 16)),
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
            Expanded(child: FutureBuilder(
              future: esmFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                  EntityStateManager esm = snapshot.data;
                  if (esm.esignData == null) {
                    return const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                          child: Text('No Sign Data found!')
                      ),
                    );
                  } else {
                    List<InviteeUrls> esignUrls = serializeESignData(esm);
                    return ListView.builder(
                      itemCount: esignUrls.length,
                      itemBuilder: (BuildContext context, int index) {
                        InviteeUrls item = esignUrls[index];
                        final int randomNumber = getRandomNumber();
                        return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8.0),
                              border: isDarkTheme ? Border.all(color: Colors.white12, width: 1.0) : null,
                              boxShadow: isDarkTheme ? null : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(2, 3),
                                )
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {},
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
                                              Text(
                                                item.name!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: isDarkTheme
                                                        ? Colors.blueAccent[400]
                                                        : const Color.fromARGB(255, 3, 71, 244),
                                                    overflow: TextOverflow.ellipsis
                                                ),
                                              ),
                                              Text(
                                                item.customerType!,
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.displayMedium!.color,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: MaterialButton(
                                      autofocus: false,
                                      onPressed: item.signed! == true ? null : () {
                                        // refreshStatus(index, applicant.id);
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) => ConstrainedBox(
                                              constraints: const BoxConstraints(minHeight: 150),
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width,
                                              ),
                                            )
                                        );
                                      },
                                      color: const Color.fromARGB(255, 6, 139, 26),
                                      // textColor: Colors.white,
                                      disabledColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Text(item.signed! == true ? 'E-Sign Completed' : 'Complete E-Sign for Customer', style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        );
                      },
                    );
                  }
                } else {
                  return Container();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<InviteeUrls> serializeESignData(EntityStateManager esm) {
    if (esm.esignData == null) {
      return [];
    } else {
      try {
        final decodedData = jsonDecode(esm.esignData!) as List<dynamic>;
        final firstDocument = decodedData.first;
        if (firstDocument.containsKey('inviteeUrls')) {
          return (firstDocument['inviteeUrls'] as List<dynamic>)
              .map((invitee) => InviteeUrls.fromJson(invitee))
              .toList();
        } else {
          return [];
        }
      } catch (e) {
        return [];
      }
    }
  }
}
