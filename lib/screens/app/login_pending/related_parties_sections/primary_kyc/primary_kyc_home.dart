import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryKycHome extends StatefulWidget {
  const PrimaryKycHome({
    super.key,
    required this.applicationId,
    required this.relatedPartyId,
  });

  final int applicationId;
  final int relatedPartyId;

  @override
  State<PrimaryKycHome> createState() => _PrimaryKycHomeState();
}

class _PrimaryKycHomeState extends State<PrimaryKycHome> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Primary Kyc"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Aadhar", style: Theme.of(context).textTheme.headlineSmall),
                    CupertinoSwitch(
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                    Text("Voter Id", style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                          Future.delayed(Duration.zero, () {
                            _showConfirmSheet(context);
                          });
                        },
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
  
  void _showConfirmSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child:  Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text("You have selected Aadhar", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                  const Text("Once Kyc mode selected, it cannot be changed in future. Please confirm before going further!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: const Color.fromARGB(255, 3, 71, 244),
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Text('Continue'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}