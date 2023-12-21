import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/utils/loan_amount_formatter.dart';
import 'package:origination/core/utils/products_shared_utils.dart';
import 'package:origination/models/bureau_check/individual.dart';
import 'package:origination/models/login_flow/login_pending_products_dto.dart';
import 'package:origination/screens/app/login_pending/main_sections/main_sections_data.dart';
import 'package:origination/service/login_flow_service.dart';

class LoginPendingHome extends StatefulWidget {
  const LoginPendingHome({
    super.key,
  });

  @override
  State<LoginPendingHome> createState() => _LoginPendingHomeState();
}

class _LoginPendingHomeState extends State<LoginPendingHome> {

  final loginPendingService = LoginPendingService();
  var logger = Logger();
  late Future<List<LoginPendingProductsDTO>> pendingProductsFuture;
  final ProductsSharedUtilService _productsSharedUtilService = ProductsSharedUtilService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // refreshLeadsSummary(); // Fetch leads summary on widget initialization
    _initializeServices();
  }

  Future<void> refreshLeadsSummary() async {
    setState(() {
      pendingProductsFuture = loginPendingService.getPendingProducts();
    });
  }

  Future<void> _initializeServices() async {
    await _productsSharedUtilService.initSharedPreferences();
    refreshLeadsSummary(); // Fetch leads summary after initializing SharedPreferences
  }

  String getNamesByType(List<Individual> applicants, IndividualType type) {
    List<String> names = applicants
        .where((element) => element.type == type)
        .map((element) => '${element.firstName ?? ''} ${element.middleName ?? ''} ${element.lastName ?? ''}')
        .toList();

    return names.join(', ');
  }

  setProductToShared(int productId, String applicantName) async {
    logger.i("Adding $productId and $applicantName to Shared prefs");
    await _productsSharedUtilService.addPendingProduct(productId: productId, applicantName: applicantName);
  } 

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Login Pending", style: TextStyle(fontSize: 18)),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear(); // Clear the search text
                          });
                        }
                      ): null,
                      // Add a search icon or button to the search bar
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30))),
                  onChanged: (value) {
                    setState(() {
                      _searchController.value = _searchController.value.copyWith(
                        text: value,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: value.length),
                        ),
                      );
                    });
                  },
                ),
              ),
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
                      List<LoginPendingProductsDTO> filteredList = [];

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

                      // Filter products based on search input
                      if (_searchController.text.isNotEmpty) {
                        String searchTerm = _searchController.text.toLowerCase();
                        filteredList = products.where((product) {
                          List<String> firstNames = product.applicants.map((applicant) => applicant.firstName ?? '').toList();
                          return firstNames.any((name) => name.toLowerCase().contains(searchTerm.toLowerCase()));
                        }).toList();
                      } else {
                        filteredList = List.from(products);
                      }

                      if (filteredList.isEmpty) {
                        return const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: Text(
                              'No matching products found',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          // Data
                          LoginPendingProductsDTO product = filteredList[index];
                          String applicantName = getNamesByType(product.applicants, IndividualType.APPLICANT);
                          String coApplicantNames = getNamesByType(product.applicants, IndividualType.CO_APPLICANT);
                          String guarantorNames = getNamesByType(product.applicants, IndividualType.GUARANTOR);

                          return GestureDetector(
                            onTap: () {
                              setProductToShared(product.id, applicantName);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MainSectionsData(id: product.id)));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Product: ${product.id}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(
                                            product.product,
                                            style: TextStyle(
                                              fontSize: 18,
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
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(
                                            '₹${LoanAmountFormatter.transform(product.loanAmount)}',
                                            style: TextStyle(
                                              fontSize: 20,
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
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Applicant:",
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.displayMedium!.color,
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(width: 50,),
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  applicantName,
                                                  style: TextStyle(
                                                    fontSize: 18,
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
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Co Applicant",
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.displayMedium!.color,
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(width: 30,),
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  coApplicantNames,
                                                  style: TextStyle(
                                                    fontSize: 18,
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
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Guarantor",
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.displayMedium!.color,
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(width: 50,),
                                              SizedBox(
                                                width: 150,
                                                child: 
                                                Text(
                                                  guarantorNames,
                                                  style: TextStyle(
                                                    fontSize: 18,
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