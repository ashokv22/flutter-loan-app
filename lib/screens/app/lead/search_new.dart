import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final LoanApplicationService loanService = LoanApplicationService();
  List<ApplicantDTO> searchResults = [];

  void _fetchSearchResults(String query) async {
    List<ApplicantDTO> results = await fetchOptions(query);
    setState(() {
      searchResults = results;
    });
  }

  int getRandomNumber() {
    int min = 1;
    int max = 20;
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  Future<List<ApplicantDTO>> fetchOptions(String query) async {
    return loanService.searchApplicant(query);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: Center(
            child: CupertinoSearchTextField(
              prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
              suffixIcon: const Icon(CupertinoIcons.clear),
              controller: _controller,
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              onChanged: (value) {
              _fetchSearchResults(value); // Fetch results on text change
            },
            onSubmitted: (value) {
              _fetchSearchResults(value); // Fetch results on submit
            },
            autocorrect: true,
            ),
          ),
        ),
        body: Column(
          children: [
            if (searchResults.isEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.history_sharp,
                        size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text("Ashok", style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          // Clear recent searches
                          searchResults.clear();
                        });
                      },
                      icon: const Icon(CupertinoIcons.clear,
                          size: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                ApplicantDTO applicant = searchResults[index];
                int randomNumber = getRandomNumber();
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
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
                              child: Image.asset('assets/images/female-${randomNumber.toString().padLeft(2, '0')}.jpg', fit: BoxFit.cover,)),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                applicant.firstName!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkTheme ? Colors.blueAccent[400] : const Color.fromARGB(255, 3, 71, 244),
                                  // color: Color.fromARGB(255, 3, 71, 244),
                                ),
                              ),
                              Text(applicant.mobile!,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.displayMedium!.color,
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
                                    color: Theme.of(context).textTheme.displayMedium!.color,
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
                            timeago.format(applicant.createdDate!, allowFromNow: true),
                            style: TextStyle(
                              color: Theme.of(context).textTheme.displayMedium!.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          // const SizedBox(height: 10),
                          Text(
                            applicant.model!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.displayMedium!.color,
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}
