import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/search_provider.dart';
import '../../providers/diet_data_provider.dart';
import '../search_results_page/search_results_page.dart';

class MorePopularSearchesPage extends StatelessWidget {
  const MorePopularSearchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('인기 검색어'),
      ),
      body: searchProvider.popularSearches.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: searchProvider.popularSearches.length,
                itemBuilder: (context, index) {
                  final search = searchProvider.popularSearches[index];
                  return Column(
                    children: [
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.teal,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(search),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 15),
                          onTap: () {
                            _handleSearchTap(context, search);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Future<void> _handleSearchTap(BuildContext context, String search) async {
    Provider.of<DietDataProvider>(context, listen: false).fetchDietData(search);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.setSearchControllerText(search);
    searchProvider.submitSearch(search);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchResultsPage(),
      ),
    );
    searchProvider.addRecentSearch(search);
  }
}
