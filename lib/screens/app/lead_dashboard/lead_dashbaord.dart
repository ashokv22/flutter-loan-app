import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/utils/loan_amount_formatter.dart';
import 'package:origination/core/utils/products_shared_utils.dart';
import 'package:origination/models/stage.dart';
import 'package:origination/models/summaries/dashboard_summary.dart';
import 'package:origination/screens/app/lead/new_lead.dart';
import 'package:origination/screens/app/lead/search_new.dart';
import 'package:origination/screens/app/lead/stage_leads_list.dart';
import 'package:origination/screens/app/lead_dashboard/submitted_and_refresh.dart';
import 'package:origination/screens/app/login_pending/login_pending_home.dart';
import 'package:origination/screens/pages/profile/profile_screen.dart';
import 'package:origination/screens/widgets/side_menu.dart';
import 'package:origination/service/auth_service.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:heroicons/heroicons.dart';
import 'package:marquee/marquee.dart';

import 'last_lead.dart';
import 'recent_products_widget.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ProductsSharedUtilService productUtilService = ProductsSharedUtilService();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await refreshLeadsSummary();
  }

  Future<void> refreshLeadsSummary() async {
    setState(() {
      leadsSummaryFuture = applicationService.getLeadsSummary();
    });
  }

  int _selectedItemIndex = 0;

  void _onDrawerItemClicked(int index) {
    setState(() {
      _selectedItemIndex = index;
    });
    Navigator.pop(context);
    // Navigate to the corresponding page based on the selected index
  switch (index) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LeadDashboard()),
      );
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewLead()),
      );
      break;
    case 2:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      );
      break;
    case 3:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
      break;
    // Add cases for other menu items if needed
  }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: SideMenu(
        selectedItemIndex: _selectedItemIndex,
        onItemClicked: _onDrawerItemClicked,
      ),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(45, 46, 46, 1),
                  Color.fromRGBO(14, 15, 15, 1)
                ],
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
                    Row(
                      children: [
                        Builder(
                          builder: (context) {
                            return IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: const HeroIcon(HeroIcons.bars3CenterLeft, color: Colors.white),
                            );
                          }
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 18,
                              child: Marquee(
                                text: "Hello ${userInfo['name']} ",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 20.0,
                                velocity: 70.0,
                                pauseAfterRound: const Duration(seconds: 1),
                                numberOfRounds: 1,
                                accelerationDuration: const Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: const Duration(milliseconds: 500),
                                decelerationCurve: Curves.linear,
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              child: Text(
                                "${userInfo['branchData']['branchCode']}",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        textAlign: TextAlign.right,
                        "${userInfo['branchData']['city']} \n${userInfo['branchData']['state']}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
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
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: FutureBuilder<List<DashBoardSummaryDTO>>(
                  future: applicationService.getLeadsSummary(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(child: CircularProgressIndicator()),
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
                              child: Text('No data found', style: TextStyle(fontSize: 20,))
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: summaries.length,
                        itemBuilder: (context, index) {
                          DashBoardSummaryDTO summary = summaries[index];
                          // if (summary.count <= 0) {
                          //   return Container();                            
                          // }
                          // else {
                            return GestureDetector(
                              onTap: () {
                                if (summary.stage.toLowerCase() == "login pending") {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPendingHome(total: summary.count)));
                                } else if (summary.stage == ApplicationStage.SUBMITTED.name) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubmittedAndRefresh(stage: summary.stage)));
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => StageLeadList(stage: summary.stage)));
                                }
                              },
                              child: leadItem(context, isDarkTheme, summary),
                            );
                          // }
                        },
                      );
                    } else {
                      return Container(); // Placeholder widget when no data is available
                    }
                  },
                ),
              ),
              LastLead(applicationService: applicationService),
              RecentProductsWidget(productUtilService: productUtilService),
            ],
          ),
        ),
      ),
    );
  }

  Container leadItem(
    BuildContext context, bool isDarkTheme, DashBoardSummaryDTO summary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        border: isDarkTheme
          ? Border.all(
              color: Colors.white12,
              width: 1.0) // Outlined border for dark theme
          : null,
        boxShadow: isDarkTheme
          ? null
          : [
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
              SizedBox(
                width: 220,
                child: Text(
                  summary.stage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkTheme
                        ? Colors.blueAccent[400]
                        : const Color.fromARGB(255, 3, 71, 244),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "Total ${summary.count}",
                style: TextStyle(
                  fontSize: 12,
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
                    fontSize: 16,
                    color: Theme.of(context).textTheme.displayLarge!.color,
                    fontWeight: FontWeight.w600),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }
}