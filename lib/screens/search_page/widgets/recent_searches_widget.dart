import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/search_provider.dart';


class RecentSearchesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
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
              child: Text(
                "모두 지우기",
                style: TextStyle(),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 1.0,
          children: searchProvider.recentSearches
              .map((search) => GestureDetector(
            onTap: () {
              searchProvider.setSearchControllerText(search);
            },
            child: Chip(
              label: Text(
                search,
                style: TextStyle(fontSize: 12.0),
              ),
              onDeleted: () {
                searchProvider.removeRecentSearch(search);
              },
              deleteIcon: Icon(
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
        SizedBox(height: 20),
      ],
    );
  }
}
