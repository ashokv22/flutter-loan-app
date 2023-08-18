import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/utils/loan_amount_formatter.dart';
import 'package:origination/models/bureau_check/individual.dart';
import 'package:origination/models/login_flow/login_pending_products_dto.dart';
import 'package:origination/screens/app/login_pending/product_pending.dart';
import 'package:origination/service/login_flow_service.dart';

class LoginPendingHome extends StatefulWidget {
  const LoginPendingHome({
    super.key,
    // required this.id
  });

  // int id;

  @override
  State<LoginPendingHome> createState() => _LoginPendingHomeState();
}

class _LoginPendingHomeState extends State<LoginPendingHome> {

  final loginPendingService = LoginPendingService();
  var logger = Logger();
  late Future<List<LoginPendingProductsDTO>> pendingProductsFuture;

  @override
  void initState() {
    super.initState();
    refreshLeadsSummary(); // Fetch leads summary on widget initialization
  }

  Future<void> refreshLeadsSummary() async {
    setState(() {
      pendingProductsFuture = loginPendingService.getPendingProducts();
      logger.wtf(pendingProductsFuture.then((value) => value));
    });
  }

  String getNamesByType(List<Individual> applicants, IndividualType type) {
    List<String> names = applicants
        .where((element) => element.type == type)
        .map((element) => '${element.firstName ?? ''} ${element.middleName ?? ''} ${element.lastName ?? ''}')
        .toList();

    return names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Login Pending"),
      ),
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
              // Container(
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //       colors: [
              //         Color.fromARGB(255, 40, 39, 39),
              //         Color.fromARGB(255, 53, 51, 51),
              //         Color.fromARGB(255, 40, 38, 38),
              //         Color.fromARGB(255, 20, 18, 18),
              //       ]
              //     ),
              //   ),
              //   child: const Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.all(16.0),
              //         child: Text(
              //           'Hello Ashok\nDCB00123',
              //           style: TextStyle(
              //             color: Colors.white, 
              //             fontSize: 20),
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(16.0),
              //         child: Text(
              //           textAlign: TextAlign.right,
              //           'Jayanagar Branch\nKarnataka',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 20,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: FutureBuilder<List<LoginPendingProductsDTO>>(
                  future: pendingProductsFuture,
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
                      List<LoginPendingProductsDTO> products = snapshot.data!;
                      if (products.isEmpty) {
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
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          // Data
                          LoginPendingProductsDTO product = products[index];
                          String applicantName = getNamesByType(product.applicants, IndividualType.APPLICANT);
                          String coApplicantNames = getNamesByType(product.applicants, IndividualType.CO_APPLICANT);
                          String guarantorNames = getNamesByType(product.applicants, IndividualType.GUARANTOR);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductPending()));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              padding: const EdgeInsets.all(16.0),
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Product",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(
                                            product.product,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Text("Loan Amount",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(
                                            '₹${LoanAmountFormatter.transform(product.loanAmount)}',
                                            style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.w900,
                                              color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Applicant:",
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.displayMedium!.color,
                                                  fontSize: 20,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(width: 50,),
                                              Text(
                                                applicantName,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Co Applicant",
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.displayMedium!.color,
                                                  fontSize: 20,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(width: 25,),
                                              Text(
                                                coApplicantNames,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Guarantor",
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.displayMedium!.color,
                                                  fontSize: 20,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(width: 50,),
                                              SizedBox(
                                                width: 250,
                                                child: Text(
                                                  guarantorNames,
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                    color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                                  ),
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      );
                    } else {
                      return Container();
                    }
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}