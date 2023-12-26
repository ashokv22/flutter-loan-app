import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/text_input.dart';

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
  TextEditingController panNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  late DateTime _selectedDate;
  bool isPanValidated = false;
  bool validateLoading = false;

    void handleDateChanged(String newValue) {
    DateTime selectedDateTime = DateFormat('yyyy-MM-dd').parse(newValue);
    setState(() {
      _selectedDate = selectedDateTime;
    });
  }

  void checkPan() async {
    setState(() {
      validateLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      validateLoading = false;
    });
    setData();                     
  }

  void setData() {
    setState(() {
      if (panNumberController.text.length == 10) {
        nameController.text = "Ashok V";
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
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
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
            ]
          ),
          color: isDarkTheme ? Colors.black38 : null
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Secondary KYC", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    Text("Mode: Manual", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 30,),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: NumberInput(label: "PAN", controller: panNumberController, onChanged: (value) {}, isEditable: true, isReadable: false)),
                        const SizedBox(width: 5,),
                        Container(
                          height: 50,
                          width: 50,
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
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.search, color: Colors.white,),
                            onPressed: () {
                              checkPan();
                            },
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isPanValidated == true,
                      replacement: Container(),
                      child: Column(
                        children: [
                          const SizedBox(height: 10,),
                          TextInput(label: "Name", controller: nameController, onChanged: (value) {}, isEditable: true, isReadable: false),
                          const SizedBox(height: 10,),
                          TextInput(label: "Father Name", controller: fatherNameController, onChanged: (value) {}, isEditable: true, isReadable: false),
                          const SizedBox(height: 10,),
                          DatePickerInput(label: "Date of birth", controller: dobController, onChanged: (newValue) => handleDateChanged(newValue), isEditable: true, isReadable: false),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: MaterialButton(
                        onPressed: () {
                          // save();
                        },
                        color: const Color.fromARGB(255, 3, 71, 244),
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: isLoading
                          ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Save'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
      )
    );
  }
}