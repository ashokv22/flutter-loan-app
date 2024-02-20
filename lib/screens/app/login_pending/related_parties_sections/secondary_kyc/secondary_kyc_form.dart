import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:origination/models/login_flow/sections/related_party/pan_request_dto.dart';
import 'package:origination/service/kyc_service.dart';

import 'PanCardWidget.dart';

class SecondaryKycForm extends StatefulWidget {
  const SecondaryKycForm({
    super.key,
    required this.relatedPartyId,
  });

  final int relatedPartyId;

  @override
  State<SecondaryKycForm> createState() => _SecondaryKycFormState();
}

class _SecondaryKycFormState extends State<SecondaryKycForm> {
  bool isLoading = false;

  // Controllers
  TextEditingController panNumberController =
      TextEditingController(text: "BZFPV4605P");
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isPanValidated = false;
  bool validateLoading = false;

  KycService kycService = KycService();
  late Future<PanRequestDTO> panRequestFuture;

  void checkPan() async {
    setState(() {
      validateLoading = true;
    });
    panRequestFuture =
        kycService.validatePan(widget.relatedPartyId, panNumberController.text);
    setState(() {
      validateLoading = false;
    });
    panRequestFuture.then((value) => {setData(value)});
  }

  void setData(PanRequestDTO panData) {
    setState(() {
      if (panNumberController.text.length == 10) {
        nameController.text = "${panData.firstname} ${panData.lastname}";
        fatherNameController.text = "Venkateshappa";
        dobController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
        isPanValidated = true;
      }
    });
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
          title: const Text("PAN", style: TextStyle(fontSize: 18)),
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
                        ]),
              color: isDarkTheme ? Colors.black38 : null),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: panNumberController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              hintText: "Pan Number",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          )),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 3, 71, 244),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              icon: validateLoading
                                  ? const SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  checkPan();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 150),
                isPanValidated
                    ? FutureBuilder(
                        future: panRequestFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData) {
                            PanRequestDTO panData = snapshot.data!;
                            if (panData.exist.toLowerCase() == "e") {
                              return PanCardWidget(
                                panData: panData,
                                isLoading: isLoading,
                              );
                            } else if (panData.exist.toLowerCase() == "n") {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red[300]),
                                child: const Text("Invalid Pan Number"),
                              );
                            }
                          }
                          return Container();
                        })
                    : Container(),
              ],
            ),
          ),
        ));
  }
}
