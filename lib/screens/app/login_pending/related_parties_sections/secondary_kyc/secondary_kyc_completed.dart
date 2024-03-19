import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/login_flow/sections/related_party/secondary_kyc_dto.dart';
import 'package:origination/service/kyc_service.dart';

class SecondaryKycCompleted extends StatefulWidget {
  const SecondaryKycCompleted({
    super.key, 
    required this.relatedPartyId
  });

  final int relatedPartyId;

  @override
  State<SecondaryKycCompleted> createState() => _SecondaryKycCompletedState();
}

class _SecondaryKycCompletedState extends State<SecondaryKycCompleted> {

  Logger logger = Logger();

  KycService kycService = KycService();
  late Future<SecondaryKYCDTO> panRequestFuture;
  
  Future<SecondaryKYCDTO> _fetchSecondaryKyc(int relatedPartyId) async {
    return await kycService.getSecondaryKyc(relatedPartyId.toString());
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
              ]
            ),
            color: isDarkTheme ? Colors.black38 : null
          ),
          child: FutureBuilder(
            future: _fetchSecondaryKyc(widget.relatedPartyId),
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
                  child: Text('Error: ${snapshot.error}', style: const TextStyle(fontSize: 14),),
                );
              } else if (snapshot.hasData) {
                SecondaryKYCDTO result = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: isDarkTheme
                            ? Border.all(color: Colors.white12, width: 1.0) // Outlined border for dark theme
                            : null,
                          boxShadow: isDarkTheme
                            ? null : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), //color of shadow
                              spreadRadius: 2, //spread radius
                              blurRadius: 6, // blur radius
                              offset: const Offset(2, 3),
                            )
                          ],
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
                                Text(result.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 18)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Father Name:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                                ),
                                const SizedBox(width: 5),
                                Text(result.fatherName!, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Date of Birth:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                                ),
                                const SizedBox(width: 5),
                                Text('${result.dateOfBirth!.year}/${result.dateOfBirth!.month}/${result.dateOfBirth!.day}', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            }
          ),
      ),
    );
  }
}