import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:origination/models/login_flow/sections/accounting_details/repayment_schedule_dto.dart';
import 'package:origination/service/login_flow_service.dart';

class RepaymentScheduleSheet extends StatefulWidget {
  const RepaymentScheduleSheet({
    super.key,
    required this.applicantId, 
    required this.loginPendingService
  });
  
  final int applicantId;
  final LoginPendingService loginPendingService;

  @override
  State<RepaymentScheduleSheet> createState() => _RepaymentScheduleSheetState();
}

class _RepaymentScheduleSheetState extends State<RepaymentScheduleSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: FutureBuilder(
        future: widget.loginPendingService.getRepaymentScheduleForLead(widget.applicantId), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<RepaymentScheduleDTO> data = snapshot.data!;
            if (data.isEmpty) {
              return const Center(child: Text('No repayment schedules found.'));
            } else {
              return Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 5.0,
                      columns: const [
                        DataColumn(label: Text('Installment', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Start Date', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('EMI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Opening Balance', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Closing Balance', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Principal', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Interest', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                      ],
                      rows: data.map((schedule) => _buildDataRow(schedule)).toList(),
                    ),
                  ),
                ),
              );
            }
          }
          return Container();
        }),
    );
  }

  DataRow _buildDataRow(RepaymentScheduleDTO schedule) {
    return DataRow(
      cells: [
        DataCell(Text(schedule.installmentNumber.toString(), style: TextStyle(fontSize: 10))),
        DataCell(Text(DateFormat('yyyy-MM-dd').format(schedule.startDate), style: TextStyle(fontSize: 10))),
        DataCell(Text(schedule.emiAmount.toStringAsFixed(2), style: TextStyle(fontSize: 10))),
        DataCell(Text(schedule.openingBalance.toStringAsFixed(2), style: TextStyle(fontSize: 10))),
        DataCell(Text(schedule.closingBalance.toStringAsFixed(2), style: TextStyle(fontSize: 10))),
        DataCell(Text(schedule.principleComponent.toStringAsFixed(2), style: TextStyle(fontSize: 10))),
        DataCell(Text(schedule.interestComponent.toStringAsFixed(2), style: TextStyle(fontSize: 10))),
      ],
    );
  }

}