import 'package:bodyguard/screens/search_page/widgets/categories_widget.dart';
import 'package:bodyguard/screens/search_page/widgets/popular_searches_widget.dart';
import 'package:bodyguard/screens/search_page/widgets/recent_searches_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../services/search_keyword_service.dart';
import '../my_home_page/my_home_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40.0,
          child: TextField(
            controller: searchProvider.searchController,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "검색어를 입력하세요",
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchProvider.setSearchControllerText('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              // 검색어가 변경될 때마다 호출되는 콜백 함수
            },
            onSubmitted: (value) async {
              await searchProvider.addRecentSearch(value);
              await SearchKeywordService().addKeyword(value);
            },
          ),
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
          padding: const EdgeInsets.all(16.0),
          children: [
            RecentSearchesWidget(),
            PopularSearchesWidget(),
            CategoriesWidget(),
          ],
        ),
      ),
    );
  }
}
