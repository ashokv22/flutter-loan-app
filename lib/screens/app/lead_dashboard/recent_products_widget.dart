import 'package:flutter/material.dart';
import 'package:origination/screens/app/login_pending/main_sections/main_sections_data.dart';
import 'package:origination/core/utils/products_shared_utils.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RecentProductsWidget extends StatefulWidget {
  const RecentProductsWidget({
    super.key, 
    required this.productUtilService
  });

  final ProductsSharedUtilService productUtilService;

  @override
  State<RecentProductsWidget> createState() => _RecentProductsWidgetState();
}

class _RecentProductsWidgetState extends State<RecentProductsWidget> {
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await widget.productUtilService.initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    "Top Applications",  
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(width: 5,),
                  Icon(Icons.history)
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.value(widget.productUtilService.getLastInteractedProducts()), // Wrap the result in Future.value
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<Map<String, dynamic>> lastInteractedProducts = snapshot.data!;
                    if (lastInteractedProducts.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text('No last interacted products found'),
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: lastInteractedProducts.length,
                      itemBuilder: (context, index) {
                        final product = lastInteractedProducts[index];
                        return Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration (
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            // gradient: isDarkTheme
                            //   ? null : const LinearGradient (
                            //   begin: Alignment(-0.99, 0.16),
                            //   end: Alignment(0.99, -0.16),
                            //   colors: [Color(0xFF0029FF), Color.fromARGB(255, 57, 76, 246)],
                            // ),
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
                          margin: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "Product id: ${product['productId']}", 
                                    style: TextStyle(
                                      // color: Colors.white,
                                      color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Applicant: ${product['applicantName']}", 
                                    style: TextStyle(
                                      color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainSectionsData(id: product['productId'])));
                                  },
                                ),
                            ),
                              Container(
                                width: 40, // Adjust the width as needed
                                margin: const EdgeInsets.only(right: 20),
                                child: CircularPercentIndicator(
                                  percent: 0.7,
                                  radius: 28, // Adjust the radius as needed
                                  animation: true,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: const Color(0xFF00861D),
                                  lineWidth: 6.0,
                                  center: const Text("70%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),)
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No last interacted products found'),
                    );
                  }
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}
