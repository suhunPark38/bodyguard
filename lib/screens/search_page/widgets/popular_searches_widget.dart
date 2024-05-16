import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/search_provider.dart';

class PopularSearchesWidget extends StatelessWidget {
  @override
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
              "인기 검색어",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                _showMorePopularSearchesDialog(context, searchProvider);
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
// 왼쪽 열: 인기 검색어 순위 1부터 5까지
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    min(5, searchProvider.popularSearches.length), (index) {
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
                            Text(
                              searchProvider.popularSearches[index],
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(); // Return an empty SizedBox if index is out of bounds
                  }
                }),
              ),
            ),

// 오른쪽 열: 인기 검색어 순위 6부터 10까지
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    min(5, searchProvider.popularSearches.length), (index) {
                  final int rightColumnIndex = index + 5;
                  if (rightColumnIndex <
                      searchProvider.popularSearches.length) {
                    return GestureDetector(
                      onTap: () {
                        _handleSearchTap(context,
                            searchProvider.popularSearches[rightColumnIndex]);
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
                            Text(
                              searchProvider.popularSearches[rightColumnIndex],
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(); // Return an empty SizedBox if index is out of bounds
                  }
                }),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  void _handleSearchTap(BuildContext context, String search) {
    Provider.of<SearchProvider>(context, listen: false)
        .setSearchControllerText(search);
    print("검색어 '$search'를 탭했습니다.");
  }

  void _showMorePopularSearchesDialog(
      BuildContext context, SearchProvider searchProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('인기 검색어 (상위 20개)'),
          content: SingleChildScrollView(
            child: Column(
              children: searchProvider.popularSearches.map((search) {
                return ListTile(
                  title: Text(search),
                  onTap: () {
                    _handleSearchTap(context, search);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
