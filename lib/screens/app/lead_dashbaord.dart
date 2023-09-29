import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/utils/loan_amount_formatter.dart';
import 'package:origination/models/summaries/dashboard_summary.dart';
import 'package:origination/screens/app/lead/stage_leads_list.dart';
import 'package:origination/service/auth_service.dart';
// import 'package:origination/screens/widgets/products.dart';
import 'package:origination/service/loan_application_service.dart';

class LeadDashboard extends StatefulWidget {
  const LeadDashboard({super.key});

  @override
  _LeadDashboardState createState() => _LeadDashboardState();
}

class _LeadDashboardState extends State<LeadDashboard> {

  final applicationService = LoanApplicationService();
  var logger = Logger();
  late Future<List<DashBoardSummaryDTO>> leadsSummaryFuture;
  final AuthService athService = AuthService();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    refreshLeadsSummary(); // Fetch leads summary on widget initialization
  }

  Future<void> refreshLeadsSummary() async {
    setState(() {
      leadsSummaryFuture = applicationService.getLeadsSummary(); // Fetch leads summary data
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: refreshLeadsSummary,
        child: Container(
          decoration: BoxDecoration(
            gradient: isDarkTheme
              ? null // No gradient for dark theme, use a single color
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                // color: Colors.black,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 40, 39, 39),
                      Color.fromARGB(255, 53, 51, 51),
                      Color.fromARGB(255, 40, 38, 38),
                      Color.fromARGB(255, 20, 18, 18),
                    ]
                  ),
                ),                
                child: FutureBuilder(
                  future: athService.getLoggedUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    }
                    var userInfo = snapshot.data ?? {};
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Hello ${userInfo['name']}\n${userInfo['branchData']['branchCode']}",
                            style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            textAlign: TextAlign.right,
                            "${userInfo['branchData']['branch']} Branch\n${userInfo['branchData']['city']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
                  Expanded(
                    child: FutureBuilder<List<DashBoardSummaryDTO>>(
                      future: applicationService.getLeadsSummary(),
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
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          List<DashBoardSummaryDTO> summaries = snapshot.data!;
                          if (summaries.isEmpty) {
                            return const SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                child: Text('No data found',
                                style: TextStyle(
                                  fontSize: 20,
                                ),)
                              )
                            );
                          }
                          return ListView.builder(
                            itemCount: summaries.length,
                            itemBuilder: (context, index) {
                              DashBoardSummaryDTO summary = summaries[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => StageLeadList(stage: summary.stage)));
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            summary.stage,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                            ),
                                          ),
                                          Text("Total ${summary.count}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context).textTheme.displaySmall!.color,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${LoanAmountFormatter.transform(summary.loanAmount)}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context).textTheme.displayLarge!.color,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          const Icon(Icons.chevron_right),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Container(); // Placeholder widget when no data is available
                        }
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showModalBottomSheet(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return const Products();
      //       },
      //     );
      //   },
      //   backgroundColor: const Color.fromARGB(255, 3, 71, 244),
      //   elevation: 5.0,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
