import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:origination/models/applicant/entity_state_manager.dart';
import 'package:origination/models/login_flow/sections/e_sign/e_sign_urls.dart';
import 'package:origination/service/login_flow_service.dart';

class ESignStatusSheet extends StatefulWidget {
  const ESignStatusSheet({
    super.key,
    required this.applicantId,
  });
  
  final int applicantId;

  @override
  State<ESignStatusSheet> createState() => _ESignStatusSheetState();
}

class _ESignStatusSheetState extends State<ESignStatusSheet> {

  final LoginPendingService loginPendingService = LoginPendingService();
  late Future<EntityStateManager> esmFuture;
  bool isLoading = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshStatus();
  }

  Future<void> refreshStatus() async {
    // await Future.delayed(const Duration(seconds: 2));
    setState(() {
      esmFuture = loginPendingService.refreshStatus(widget.applicantId);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
      height: 300.0,
      width: double.infinity,
      child: FutureBuilder(future: esmFuture, builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Lottie.asset(
                    'assets/animations/loading_dedupe.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                    repeat: false
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Lottie.asset(
                'assets/animations/failed_animation.json',
                width: 100,
                height: 100,
                fit: BoxFit.fill,
                repeat: false
              ),
            ),
          );
        } else if (snapshot.hasData) {
            EntityStateManager esm = snapshot.data;
            var esignData = serializeESignData(esm);
            if (esm.esignData == null || esm.esignData!.isEmpty) {
              return const SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text('No Sign Data found!', style: TextStyle(color: Colors.red))
                ),
              );
            } else {
              var esignData = serializeESignData(esm);
              return _buildBody(esignData);
            }
          }
          return const Text('Error');
      }),
    );


    return Container(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
        height: 300.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Lottie.asset(
                      'assets/animations/failed_animation.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                      repeat: false
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Oh no, E-Sign Verification is failed!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Wanna check again, click below button!',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: MaterialButton(
                autofocus: false,
                onPressed: () {},
                color: const Color.fromARGB(255, 6, 139, 26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: const Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        )
    );
  }

  Widget _buildBody(ESignUrls esignData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (esignData.status! == "Not Initiated") ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Lottie.asset(
                    'assets/animations/failed_animation.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                    repeat: false
                ),
              )
            ] else if (esignData.status! == "Pending") ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Lottie.asset(
                    'assets/animations/failed_animation.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                    repeat: false
                ),
              )
            ] else if (esignData.status! == "Completed") ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Lottie.asset(
                    'assets/animations/failed_animation.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                    repeat: false
                ),
              )
            ] else if (esignData.status! == "Expired") ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Lottie.asset(
                    'assets/animations/failed_animation.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                    repeat: false
                ),
              )
            ],
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Oh no, E-Sign Verification is failed!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Wanna check again, click below button!',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: MaterialButton(
            autofocus: false,
            onPressed: () {},
            color: const Color.fromARGB(255, 6, 139, 26),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }

  ESignUrls serializeESignData(EntityStateManager esm) {
    if (esm.esignData == null) {
      return ESignUrls();
    } else {
      try {
        final decodedData = jsonDecode(esm.esignData!) as List<dynamic>;
        return decodedData.first;
      } catch (e) {
        return ESignUrls();
      }
    }
  }

}
