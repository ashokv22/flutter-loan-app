import 'package:flutter/material.dart';
import 'package:origination/service/loan_application_service.dart';

class SearchLead extends SearchDelegate {

  final LoanApplicationService loanService = LoanApplicationService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildListView(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildListView(query);
  }

  Widget _buildListView(String query) {
    return FutureBuilder(
      future: _fetchSearchResults(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found.'));
        } else {
          List<String>? matchQuery = snapshot.data;
          return ListView.builder(
            itemCount: matchQuery!.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              return ListTile(
                title: Text(result),
              );
            },
          );
        }
      },
    );
  }

  Future<List<String>> _fetchSearchResults(String query) async {
    // final results = await loanService.searchLeads(query);
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

}