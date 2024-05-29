import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/login_flow/sections/related_party/pan_request_dto.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/secondary_kyc/pan_form.dart';
import 'package:origination/service/kyc_service.dart';

import 'PanCardWidget.dart';

class SecondaryKycForm extends StatefulWidget {
  const SecondaryKycForm({
    super.key,
    required this.relatedPartyId,
    required this.type,
  });

  final int relatedPartyId;
  final String type;

  @override
  State<SecondaryKycForm> createState() => _SecondaryKycFormState();
}

class _SecondaryKycFormState extends State<SecondaryKycForm> {
  bool isLoading = false;

  // Controllers
  TextEditingController panNumberController = TextEditingController(text: "BZFPV4605P");
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isPanValidated = false;
  bool validateLoading = false;

  KycService kycService = KycService();
  Future<PanRequestDTO>? panRequestFuture;

  Logger logger = Logger();

  Future<void> checkPan() async {
    setState(() {
      isLoading = true;
    });
    try {
      PanRequestDTO panData = await kycService.validatePan(widget.relatedPartyId, panNumberController.text);
      setData(panData);
        setState(() {
          panRequestFuture = Future.value(panData);
        });
    } catch(e) {
      throw Exception(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setData(PanRequestDTO panData) {
    setState(() {
      if (panNumberController.text.length == 10) {
        nameController.text = panData.name;
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
                            ),
                          ),
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
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const  Icon(
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
                const SizedBox(height: 10),
                const Text("No Manual KYC as of now!", style: TextStyle(fontStyle: FontStyle.italic),),
                const SizedBox(height: 10),
                MaterialButton(
                  height: 40,
                  minWidth: 100,
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => PanCardForm(relatedPartyId: widget.relatedPartyId, type: widget.type)));
                  },
                  color: const Color.fromARGB(255, 6, 139, 26),
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Text('Go Manual'),
                ),
                const SizedBox(height: 150),
                if(isPanValidated)...[FutureBuilder(
                  future: panRequestFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                      if (panData.panStatus == "E") {
                        logger.i("Pan card exists: $panData");
                        return PanCardWidget(
                          panData: panData,
                          isLoading: isLoading,
                          relatedPartyId: widget.relatedPartyId,
                          type: widget.type,
                        );
                      } else if (panData.panStatus.toLowerCase() == "n") {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red[300]),
                          child: const Text("Invalid Pan Number"),
                        );
                      }
                    }
                    return Text(snapshot.error == null ? snapshot.error.toString() : "Unexpected error!");
                  }
                )],
              ],
            ),
          ),
        ));
  }
}
