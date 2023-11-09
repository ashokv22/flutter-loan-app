import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/secondary_kyc/form_60.dart';
import 'package:origination/screens/app/login_pending/related_parties_sections/secondary_kyc/secondary_kyc_form.dart';

class SecondaryKycHome extends StatefulWidget {
  const SecondaryKycHome({
    super.key,
    required this.relatedPartyId,
    });

  final int relatedPartyId;

  @override
  State<SecondaryKycHome> createState() => _SecondaryKycHomeState();
}

class _SecondaryKycHomeState extends State<SecondaryKycHome> {
  
  Logger logger = Logger();
  bool _value = false;

  void redirect() {
    print(_value == false ? "PAN":"Form 60");
    if (_value == false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SecondaryKycForm(relatedPartyId: widget.relatedPartyId,)));
    }
    else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Form60(relatedPartyId: widget.relatedPartyId,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Secondary Kyc", style: TextStyle(fontSize: 18)),
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
              Text("Select KYC Type", style: Theme.of(context).textTheme.headlineSmall,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("PAN", style: Theme.of(context).textTheme.headlineSmall,),
                    CupertinoSwitch(
                      value: _value, 
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          // print(_value == false ? "PAN":"Form 60");
                        });
                      }),
                    Text("Form 60", style: Theme.of(context).textTheme.headlineSmall,),
                  ],
                ),
              ),
            const Text("Once Kyc mode selected, it cannot be changed in future. Please confirm before going further!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
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
                          redirect();
                        },
                        color: const Color.fromARGB(255, 3, 71, 244),
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child:  Text('Continue'),
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