import 'package:bodyguard/screens/search_page/widgets/categories_widget.dart';
import 'package:bodyguard/screens/search_page/widgets/popular_searches_widget.dart';
import 'package:bodyguard/screens/search_page/widgets/recent_searches_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/diet_data_provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../widgets/custom_search_bar.dart';
import '../my_home_page/my_home_page.dart';
import '../search_results_page/search_results_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: CustomSearchBar(
          controller: searchProvider.searchController,
          hintText: "검색어를 입력하세요",
          onChanged: (value) {
            // 검색어가 변경될 때마다 호출되는 콜백 함수
          },
          onSubmitted: (value) async {
            if (value.trim().isNotEmpty) {
              Provider.of<DietDataProvider>(context, listen: false)
                  .fetchDietData(value);
              searchProvider.submitSearch(value);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchResultsPage(),
                ),
              );
              searchProvider.addRecentSearch(value);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('검색어를 입력하세요.'),
                ),
              );
            }
          },
          onPressed: () {
            searchProvider.setSearchControllerText('');
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Provider.of<ShoppingProvider>(context, listen: false)
                  .setCurrentShoppingTabIndex(0);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(
                    initialIndex: 3,
                  ),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await searchProvider.loadPopularSearches();
        },
        child: ListView(
          children: const [
            RecentSearchesWidget(),
            PopularSearchesWidget(),
            CategoriesWidget(),
          ],
        ),
      ),
    );
  }
}
