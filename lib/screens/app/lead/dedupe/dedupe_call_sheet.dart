import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:origination/models/applicant/dedupe/dedupe_dto.dart';
import 'package:origination/service/implementation/dedupe_service.dart';

class DedupeCallSheet extends StatefulWidget {
  const DedupeCallSheet({super.key, required this.dedupeDTO});

  final DedupeDTO dedupeDTO;

  @override
  _DedupeCallSheetState createState() => _DedupeCallSheetState();
}

class _DedupeCallSheetState extends State<DedupeCallSheet> {
  
  bool showMessage = false;
  bool showError = false;
  String errorMessage = '';
  int apiCallCounter = 0;
  Timer? timer;
  Timer? apiTimer;
  String? requestUUID;

  int maxAttempts = 8;
  int remainingAttempts = 8;
  int seconds = 0;

  final logger = Logger();
  final dedupeService = DedupeService();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initialApiCall();
  }

  @override
  void dispose() {
    timer?.cancel();
    apiTimer?.cancel();
    super.dispose();
  }

  Future<void> _initialApiCall() async {
    try {
      final response = await dedupeService.dedupeInit(widget.dedupeDTO);
      if (response.statusCode == 200) {
        logger.v('Initial API call successful');
        final responseData = response.body;
        requestUUID = jsonDecode(responseData)['requestUuid'];

        // Start the timer for subsequent calls
        _startApiCallTimer();
      } else {
        logger.e('Initial API call failed: ${response.body}');
        setState(() {
          showError = true;
          errorMessage = 'Initial API call failed';
        });
      }
    } catch (e) {
      logger.e('Initial API call error: $e');
      setState(() {
        showError = true;
        errorMessage = 'Initial API call error: $e';
      });
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        seconds += 1;
      });
    });
  }

  void _startApiCallTimer() {
    timer = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      if (apiCallCounter < maxAttempts && requestUUID != null) {
        _subsequentApiCall(requestUUID!);
        apiCallCounter++;
        setState(() {
          remainingAttempts--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  // void _startTimer() {
  //   timer = Timer.periodic(const Duration(seconds: 15), (Timer timer) {
  //     if (apiCallCounter < 8 && requestUUID != null) {
  //       _subsequentApiCall(requestUUID!);
  //       apiCallCounter++;
  //     } else {
  //       timer.cancel();
  //     }
  //   });
  // }

  Future<void> _subsequentApiCall(String requestUUID) async {
    try {
      final response = await dedupeService.dedupeStatus(requestUUID);

      if (response.statusCode == 200) {
        logger.v('Customer exists, stopping further API calls, ${jsonDecode(response.body)}');
        setState(() {
          showMessage = true;
          showError = false;
        });
        timer?.cancel();
        apiTimer?.cancel();
      } else if (response.statusCode == 400) {
        logger.v('Subsequent API call returned 400, continuing retries');
        // No UI update needed, just continue retrying
      } else {
        logger.e('Subsequent API call failed: ${response.body}');
        setState(() {
          showMessage = false;
          showError = true;
          errorMessage = 'Subsequent API call failed';
        });
      }
    } catch (e) {
      logger.e('Subsequent API call error: $e');
      setState(() {
        showMessage = false;
        showError = true;
        errorMessage = 'Subsequent API call error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 250.0,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Attempts/Remaining: $apiCallCounter/$remainingAttempts',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Text(
                    '$seconds',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              Spacer(),
              Lottie.asset(
                'assets/animations/loading_dedupe.json',
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
              if (showMessage)
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Customer exists in the system!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              if (showError)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (!showMessage && !showError)
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'This is taking longer than expected, please wait!',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
