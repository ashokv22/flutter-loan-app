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
    required this.total,
  });

  final int total;

  @override
  State<LoginPendingHome> createState() => _LoginPendingHomeState();
}

class _LoginPendingHomeState extends State<LoginPendingHome> {

  final loginPendingService = LoginPendingService();
  final _scrollController = ScrollController();
  // Pgination
  int page = 0;
  int defaultPageSize = 10;
  List<LoginPendingProductsDTO> items = [];
  
  var logger = Logger();
  late Future<List<LoginPendingProductsDTO>> pendingProductsFuture;
  final ProductsSharedUtilService _productsSharedUtilService = ProductsSharedUtilService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeServices();
    
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        _fetchNextPage();
      }
    });
  }

  Future<void> refreshLeadsSummary() async {
    final products = await loginPendingService.getPendingProducts(page);
    setState(() {
      items.clear(); // Clear existing items
      items.addAll(products);
      page = 1; // Reset page count
    });
  }

  Future<void> _fetchNextPage() async {
    final nextPage = page + 1;
    final result = await loginPendingService.getPendingProducts(nextPage);

    if (result.isNotEmpty) {
      setState(() {
        logger.wtf("Page length: ${result.length}");
        items.addAll(result);
        page = nextPage; // Update page count
      });
    }
  }

  Future<void> _initializeServices() async {
    pendingProductsFuture = loginPendingService.getPendingProducts(page);
  }

  String getNamesByType(List<Individual> applicants, IndividualType type) {
    List<String> names = applicants
        .where((element) => element.type == type)
        .map((element) => '${element.firstName ?? ''} ${element.middleName ?? ''} ${element.lastName ?? ''}')
        .toList();

    return names.join(', ');
  }

  setProductToShared(int productId, String applicantName, int completedSections) async {
    logger.i("Adding $productId and $applicantName to Shared prefs");
    await _productsSharedUtilService.addPendingProduct(productId: productId, applicantName: applicantName, completedSections: completedSections);
  } 

  double getPercentage(int completedSections, int totalSections) {
    // return (((completedSections.toDouble()/totalSections.toDouble()) * 100).floorToDouble()/100);
    if (totalSections == 0) return 0.0; // Prevent division by zero
    return (completedSections / totalSections * 100).roundToDouble() / 100;
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
                child: SizedBox(
                  height: 45,
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
              ),
              Text("Total: ${widget.total} \t Page: $page \t List size: ${items.length}", textAlign: TextAlign.left,),
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
                      // Add the retrieved products to the global list
                      if (items.isEmpty) {
                        items.addAll(products);
                      }

                      if (items.isEmpty) {
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
                        filteredList = items.where((product) {
                          List<String> firstNames = product.applicants.map((applicant) => applicant.firstName ?? '').toList();
                          return firstNames.any((name) => name.toLowerCase().contains(searchTerm.toLowerCase()));
                        }).toList();
                      } else {
                        filteredList = List.from(items);
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
                        controller: _scrollController,
                        itemCount: filteredList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < filteredList.length) {
                            // Data
                          LoginPendingProductsDTO product = filteredList[index];
                          String applicantName = getNamesByType(product.applicants, IndividualType.APPLICANT);
                          String coApplicantNames = getNamesByType(product.applicants, IndividualType.CO_APPLICANT);
                          String guarantorNames = getNamesByType(product.applicants, IndividualType.GUARANTOR);
                          double percentage =  getPercentage(product.completedSections, product.totalSections);
                            return GestureDetector(
                            onTap: () {
                              setProductToShared(product.id, applicantName, product.completedSections);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MainSectionsData(id: product.id, completedSections: product.completedSections)));
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Please Confirm'),
                                    content: const Text(
                                        "Are you sure you want to delete the lead?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Yes')),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      )
                                    ],
                                  );
                                }
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              padding: const EdgeInsets.all(0.0),
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
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Product: ${product.id}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  product.product,
                                                  style: TextStyle(
                                                    fontSize: 16,
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
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Text(
                                                  '₹${LoanAmountFormatter.transform(product.loanAmount)}',
                                                  style: TextStyle(
                                                    fontSize: 16,
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
                                                        fontSize: 14,
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
                                                          fontSize: 16,
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
                                                        fontSize: 14,
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
                                                          fontSize: 16,
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
                                                        fontSize: 14,
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
                                                          fontSize: 16,
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
                                                Text("Completed: ${product.completedSections}, Total: ${product.totalSections}", 
                                                  style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  LinearProgressIndicator(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: const Radius.circular(50), 
                                      topRight: percentage == 1 ? const Radius.circular(0) : const Radius.circular(0.3),
                                      bottomRight: percentage == 1 ? const Radius.circular(0.5) : const Radius.circular(0.3)
                                    ),
                                    minHeight: 5.0,
                                    value: percentage,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          );
                          } else {
                            if (items.length >= widget.total) {
                              // Display "That's all" message
                              return const Center(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      "You've reached the end!",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Center(child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                  ),
                                ),),
                              );
                            }
                          }
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