import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/diet_data_provider.dart';
import '../../../providers/search_provider.dart';
import '../../more_popular_searches_page/more_popular_searches_page.dart';
import '../../search_results_page/search_results_page.dart';

class PopularSearchesWidget extends StatelessWidget {
  const PopularSearchesWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "인기 검색어",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MorePopularSearchesPage(),
                    ),
                  );
                },
                child: const Text(
                  "더보기",
                  style: TextStyle(),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    min(5, searchProvider.popularSearches.length),
                        (index) {
                      if (index < searchProvider.popularSearches.length) {
                        return GestureDetector(
                          onTap: () {
                            _handleSearchTap(
                                context, searchProvider.popularSearches[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                Text(
                                  "${index + 1}  ",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    searchProvider.popularSearches[index],
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    min(5, searchProvider.popularSearches.length),
                        (index) {
                      final int rightColumnIndex = index + 5;
                      if (rightColumnIndex <
                          searchProvider.popularSearches.length) {
                        return GestureDetector(
                          onTap: () {
                            _handleSearchTap(
                                context,
                                searchProvider.popularSearches[
                                rightColumnIndex]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                Text(
                                  "${rightColumnIndex + 1}  ",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    searchProvider.popularSearches[
                                    rightColumnIndex],
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Future<void> _handleSearchTap(BuildContext context, String search) async {
    Provider.of<DietDataProvider>(context, listen: false)
        .fetchDietData(search);
    final searchProvider =
    Provider.of<SearchProvider>(context, listen: false);
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
