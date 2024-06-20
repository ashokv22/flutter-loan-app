import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/models/bureau_check/bc_check_list_dto.dart';
import 'package:origination/models/bureau_check/individual.dart';
// import 'package:origination/models/bureau_check/individual.dart';
import 'package:origination/service/bureau_check_service.dart';

class ApproveWithScore extends StatefulWidget {
  const ApproveWithScore({
    super.key,
    required this.id,
    required this.applicantType,
  });

  final int id;
  final CibilType applicantType;

  @override
  State<ApproveWithScore> createState() => _ApproveWithScoreState();
}

class _ApproveWithScoreState extends State<ApproveWithScore> {

  TextEditingController score = TextEditingController();
  bool isLoading = false;
  final bureauService = BureauCheckService();
  final logger = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCibilScore();
  }

  void fetchCibilScore() async {
    setState(() {
      isLoading = true;
    });
    final response = await bureauService.getBureauReport(widget.id);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      try {
        var cibilScore = jsonResponse['result']['cibilData'][0]['cbScore'];
        setState(() {
          score.text = cibilScore;
        });
      } catch (e) {
        logger.e(e);
      }
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Approve score',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          isLoading ?
          const CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 2,
          ) :
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NumberInput(label: "Cibil score", controller: score, onChanged: (newValue) => updateValue(newValue, score), isEditable: true, isReadable: false, isRequired: true,),
              ],
            ),
          ),
          const Expanded(child: SizedBox()), // Add an expanded widget to fill remaining space
          Container(
            width: double.infinity,
            // height: 80.0,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // saveRejectReason(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 71, 244),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              child: isLoading ? const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
  void updateValue(String value, TextEditingController controller) {
    controller.text = value;
  }
}
