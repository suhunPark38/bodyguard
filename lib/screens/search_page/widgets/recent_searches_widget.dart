import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/search_provider.dart';
import '../../search_results_page/search_results_page.dart';

class RecentSearchesWidget extends StatelessWidget {
  const RecentSearchesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "최근 검색어",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                searchProvider.clearAllRecentSearches();
              },
              child: const Text(
                "모두 지우기",
                style: TextStyle(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 1.0,
          children: searchProvider.recentSearches
              .map((search) => GestureDetector(
                    onTap: () async {
                      searchProvider.setSearchControllerText(search);
                      searchProvider.submitSearch(search);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchResultsPage(),
                        ),
                      );
                    },
                    child: Chip(
                      label: Text(
                        search,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                      onDeleted: () {
                        searchProvider.removeRecentSearch(search);
                      },
                      deleteIcon: const Icon(
                        Icons.clear,
                        size: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
