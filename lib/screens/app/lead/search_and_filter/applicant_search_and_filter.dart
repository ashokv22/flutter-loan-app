import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/applicant/applicant_search_specification.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/screens/app/lead/edit_lead_application.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'filter_sheet.dart';

class ApplicantSearchAndFilter extends StatefulWidget {
  const ApplicantSearchAndFilter({super.key});

  @override
  State<ApplicantSearchAndFilter> createState() =>
      _ApplicantSearchAndFilterState();
}

class _ApplicantSearchAndFilterState extends State<ApplicantSearchAndFilter> {
  final TextEditingController _searchController = TextEditingController();
  String sortBy = 'Newest First'; // Selected sort option
  String sortDirection = "ASC";

  final logger = Logger();

  //controllers
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _ownedByController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  //Service
  final LoanApplicationService loanApplicationService = LoanApplicationService();

  // State to store search results
  List<ApplicantDTO> _applicants = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    searchApplicants();
    _branchController.addListener(_onControllerChanged);
    _mobileNumberController.addListener(_onControllerChanged);
    _ownedByController.addListener(_onControllerChanged);
    _genderController.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _branchController.removeListener(_onControllerChanged);
    _mobileNumberController.removeListener(_onControllerChanged);
    _ownedByController.removeListener(_onControllerChanged);
    _genderController.removeListener(_onControllerChanged);
    _searchController.dispose();
    _branchController.dispose();
    _mobileNumberController.dispose();
    _ownedByController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    searchApplicants();
    setState(() {});
  }

  Future<void> searchApplicants() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final searchSpec = ApplicantSearchSpecification(
      firstName: _searchController.text.isNotEmpty ? _searchController.text : null,
      branch: _branchController.text.isNotEmpty ? _branchController.text : null,
      mobile: _mobileNumberController.text.isNotEmpty ? _mobileNumberController.text : null,
      ownedBy: _ownedByController.text.isNotEmpty ? _ownedByController.text : null,
      gender: _genderController.text.isNotEmpty ? _genderController.text : null,
    );

    logger.d(searchSpec.toJson());

    try {
      final results = await loanApplicationService.searchSpecificationApplicant(searchSpec, sortDirection);
      setState(() {
        _applicants = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load results';
      });
    }
  }

  void _clearAllFilters() {
    _branchController.clear();
    _mobileNumberController.clear();
    _ownedByController.clear();
    _genderController.clear();
    // Call setState to rebuild the UI with cleared controllers
    setState(() {});
  }

  int getRandomNumber() {
    int min = 1;
    int max = 20;
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(isDarkTheme),
          _buildApplicantsList(),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isDarkTheme) {
    return SizedBox(
      height: 145,
      child: Container(
        padding: const EdgeInsets.only(top: 30.0),
        decoration: BoxDecoration(
            gradient: isDarkTheme
                ? null // No gradient for dark theme, use a single color
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                        Color.fromRGBO(128, 126, 250, 1.0),
                        Colors.white,
                      ]),
            color: isDarkTheme ? Colors.black38 : Colors.white60),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(CupertinoIcons.arrow_left, color: isDarkTheme ? Colors.white70 : Colors.black),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          fillColor: isDarkTheme ? Colors.black : Colors.white70,
                          filled: true,
                          hintText: 'Search...',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w300),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _onControllerChanged();
                                    });
                                  })
                              : null,
                          prefixIcon: IconButton(
                            icon: const Icon(CupertinoIcons.search, size: 20),
                            onPressed: () {},
                          ),
                          contentPadding: const EdgeInsets.all(6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onChanged: (value) {
                          _onControllerChanged();
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => _showSortBySheet(context),
                      child: Chip(
                        label: Row(children: [
                          Text('Sort By',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: isDarkTheme ? Colors.white70 : Colors.black
                            )
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: isDarkTheme ? Colors.white70 : Colors.black)
                        ]),
                        backgroundColor: isDarkTheme ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          side: BorderSide(color: isDarkTheme ? Colors.white70 : Colors.black12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilterSheet(
                              branchController: _branchController,
                              mobileNumberController: _mobileNumberController,
                              ownedByController: _ownedByController,
                              genderController: _genderController,
                              clearAllFilters: _clearAllFilters,
                              isDarkTheme: isDarkTheme
                            )
                          ),
                        );
                      },
                      child: Chip(
                        label: Row(
                          children: [
                            HeroIcon(
                              HeroIcons.adjustmentsHorizontal,
                              size: 18, color: isDarkTheme ? Colors.white70 : Colors.black
                            ),
                            Text(
                              'Filter',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: isDarkTheme ? Colors.white70 : Colors.black
                              ),
                            )
                          ],
                        ),
                        backgroundColor: isDarkTheme ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            side: BorderSide(color: isDarkTheme ? Colors.white70 : Colors.black12)),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantsList() {
    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _applicants.isEmpty ?
                const Center(child: Text( "No Leads found!"),)
                : ListView.builder(
                  itemCount: _applicants.length,
                  itemBuilder: (context, index) {
                    ApplicantDTO applicant = _applicants[index];
                    int randomNumber = getRandomNumber();
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditLead(id: applicant.id!, applicantId: int.parse(applicant.applicantId!))));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        'assets/images/female-${randomNumber.toString().padLeft(2, '0')}.jpg',
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      applicant.firstName!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 3, 71, 244),
                                      ),
                                    ),
                                    Text(
                                      applicant.mobile!,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .color,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        // applicant.dsaName,
                                        "ID: ${applicant.id}, AppID:${applicant.applicantId}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .color,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  timeago.format(applicant.createdDate!,
                                      allowFromNow: true),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    applicant.model!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).textTheme.displayMedium!.color,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showSortBySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    'SORT BY',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Newest First',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Radio(
                            value: 'Newest First',
                            groupValue: sortBy,
                            onChanged: (value) {
                              modalSetState(() {
                                sortBy = value as String;
                              });
                              setState(() {
                                sortBy = value as String;
                                sortDirection = "DESC";
                              });
                              _onControllerChanged();
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Oldest First',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Radio(
                            value: 'Oldest First',
                            groupValue: sortBy,
                            onChanged: (value) {
                              modalSetState(() {
                                sortBy = value as String;
                              });
                              setState(() {
                                sortBy = value as String;
                                sortDirection = "ASC";
                              });
                              _onControllerChanged();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
