import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/store_model.dart';
import '../../providers/diet_data_provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/diet_data_list_view.dart';
import '../../widgets/store_card.dart';
import '../my_home_page/my_home_page.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final List<Store> stores = searchProvider.searchResults;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: const TabBar(
            tabs: [
              Tab(text: '가게'),
              Tab(text: '영양 정보'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            stores.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: stores.length,
                    itemBuilder: (context, index) {
                      Store store = stores[index];
                      return StoreCard(store: store);
                    },
                  )
                : const Center(
                    child: Text('해당하는 가게가 없어요.'),
                  ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: DietDataListView(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
