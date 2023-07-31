import 'package:flutter/material.dart';
import 'package:origination/core/widgets/reference_code.dart';

class RejectReason extends StatefulWidget {
  const RejectReason({super.key});

  @override
  State<RejectReason> createState() => _RejectReasonState();
}

class _RejectReasonState extends State<RejectReason> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Reject reason'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Container(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Referencecode(label: "Reason", controller: TextEditingController(), referenceCode: "reject_reason", onChanged: (newValue){}),
                  ],
                ),
              ),
          ),
          const Expanded(child: SizedBox()), // Add an expanded widget to fill remaining space
          Container(
            width: double.infinity,
            height: 80.0,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 71, 244),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              child: const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}