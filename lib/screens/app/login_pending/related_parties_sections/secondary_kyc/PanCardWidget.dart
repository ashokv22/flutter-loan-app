import 'package:flutter/material.dart';
import 'package:origination/models/login_flow/sections/related_party/pan_request_dto.dart';
import 'package:origination/models/login_flow/sections/related_party/secondary_kyc_dto.dart';
import 'package:origination/service/kyc_service.dart';

class PanCardWidget extends StatefulWidget {
  const PanCardWidget({
    super.key,
    required this.panData,
    required this.isLoading,
    required this.relatedPartyId,
    required this.type
  });

  final PanRequestDTO panData;
  final bool isLoading;
  final int relatedPartyId;
  final String type;

  @override
  State<PanCardWidget> createState() => _PanCardWidgetState();
}

class _PanCardWidgetState extends State<PanCardWidget> {

  bool isLoading = false;
  bool isError = false;
  
  KycService kycService = KycService();
  void save() async {
    setState(() {
      isLoading = true;
    });
    SecondaryKYCDTO secondaryKYCDTO = SecondaryKYCDTO(
      id: null,
      isVerified: true,
      name: widget.panData.name,
      fatherName: widget.panData.fatherName,
      dateOfBirth: null,
      panNumber: widget.panData.panNo,
      relatedPartyId: widget.relatedPartyId,
    );
    try {
      await kycService.saveSecondaryKyc(widget.type, secondaryKYCDTO);
      setState(() {
        isLoading = false;
      });
      showMessage("Secondary KYC saved successfully!");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showMessage(e.toString());
    }
  }
  void showMessage(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
  }



  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withAlpha(100),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
            color: Colors.white.withOpacity(0.4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                    const Text(
                      "Name:",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                    const SizedBox(width: 5),
                    Text(widget.panData.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Father Name:",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                    SizedBox(width: 5),
                    Text("NA",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date of Birth:",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                    SizedBox(width: 5),
                    Text("NA",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        save();
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
