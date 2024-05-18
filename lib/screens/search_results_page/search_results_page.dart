import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../map.dart';
import '../../model/store_model.dart';
import '../../providers/search_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../widgets/store_card.dart';
import '../my_home_page/my_home_page.dart';
import '../store_menu_page/store_menu_page.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    List<Store> stores = searchProvider.searchResults;
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
              searchProvider.submitSearch(value);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchResultsPage(),
                ),
              );
              searchProvider.addRecentSearch(value);
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
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          Store store = stores[index];
          return StoreCard(store: store);
        },
      ),
    );
  }
}
