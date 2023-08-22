import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/service/loan_application_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final LoanApplicationService loanService = LoanApplicationService();
  List<NameValueDTO> searchResults = [];

  void _fetchSearchResults(String query) async {
    List<NameValueDTO> results = await fetchOptions(query);
    setState(() {
      searchResults = results;
    });
  }

  Future<List<NameValueDTO>> fetchOptions(String query) async {
    return loanService.searchReferenceCodes("manufacturer", query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.arrow_left,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(
            child: CupertinoSearchTextField(
              suffixIcon: const Icon(CupertinoIcons.clear),
              controller: _controller,
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
                var result = searchResults[index];
                return ListTile(
                  title: Text(result.name!), // Display the appropriate property
                );
              },
                  ),
            ),
          ],
        )
    );
  }

  // Future<List<NameValueDTO>> fetchOptions(String query) async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   return [];
  // }
}