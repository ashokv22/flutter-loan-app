import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/models/bureau_check/bc_check_list_dto.dart';
import 'package:origination/service/bureau_check_service.dart';

class RejectReason extends StatefulWidget {
  const RejectReason({
    super.key,
    required this.id,
    required this.cibilType,
    required this.applicantType,
    required this.controller,
  });

  final int id;
  final TextEditingController controller;
  final String cibilType;
  final CibilType applicantType;

  @override
  State<RejectReason> createState() => _RejectReasonState();
}

class _RejectReasonState extends State<RejectReason> {
  String selectedOption = '';
  Logger logger = Logger();
  bool isLoading = false;
  final bureauService = BureauCheckService();

  void updateValue(newValue, TextEditingController controller) {
    widget.controller.text = newValue;
    logger.i("${widget.id}, ${widget.applicantType.name}, ${widget.cibilType}");
  }

  void saveRejectReason(BuildContext context) async {
    if (widget.controller.text.isEmpty) {
      return logger.i("Please select the option");
    }
    setState(() {
      isLoading = true;
    });
    try {
      bool status = await bureauService.rejectIndividual(widget.id, widget.applicantType, widget.controller.text);
      if (status) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      logger.e(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Reject reason',
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
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Referencecode(label: "Reason", controller: widget.controller, referenceCode: "reject_reason", onChanged: (newValue) => updateValue(newValue, widget.controller), isEditable: true, isReadable: false, isRequired: true,),
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
                saveRejectReason(context);
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
}