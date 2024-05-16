import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_provider.dart';
import '../../services/search_keyword_service.dart';
import '../../database/search_history_database.dart';
import '../../services/store_service.dart';
import '../store_list_page/store_list_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];
  List<String> _popularSearches = [];
  final SearchHistoryDatabase _database = SearchHistoryDatabase();

  List<String> _cuisineTypes = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _loadPopularSearches();
    _loadCuisineTypes();
  }

  Future<void> _loadSearchHistory() async {
    List<String> searches = await _database.getSearchHistory();
    setState(() {
      _recentSearches = searches;
    });
  }

  Future<void> _loadPopularSearches() async {
    List<String> popularSearches =
        await SearchKeywordService().getTop20KeywordsBySearchCount();
    setState(() {
      _popularSearches = popularSearches;
      if (_popularSearches.length < 20) {
        int dummyCount = 20 - _popularSearches.length;
        _popularSearches
            .addAll(List.generate(dummyCount, (index) => "인기 검색어에요."));
      }
    });
  }

  Future<void> _loadCuisineTypes() async {
    List<String> cuisineTypes = await StoreService().getAllCuisineTypes();
    setState(() {
      _cuisineTypes = cuisineTypes;
    });
  }

  void _addRecentSearch(String search) async {
    if (!_recentSearches.contains(search)) {
      setState(() {
        _recentSearches.add(search);
      });
      await _database.insertSearch(search);
    }
  }

  void _removeRecentSearch(String search) async {
    setState(() {
      _recentSearches.remove(search);
    });
    await _database.deleteSearch(search);
  }

  void _clearAllRecentSearches() async {
    setState(() {
      _recentSearches.clear();
    });
    await _database.clearAllSearches();
  }

  Widget _buildRecentSearchChip(String search) {
    return GestureDetector(
      onTap: () {
        _searchController.text = search;
      },
      child: Chip(
        label: Text(
          search,
          style: const TextStyle(fontSize: 12.0),
        ),
        onDeleted: () {
          _removeRecentSearch(search);
        },
        deleteIcon: const Icon(
          Icons.clear,
          size: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: "검색어를 입력하세요",
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
          onChanged: (value) {
            // 검색어가 변경될 때마다 호출되는 콜백 함수
          },
          onSubmitted: (value) async {
            // 검색 버튼을 누르거나 키보드의 '완료' 버튼을 눌렀을 때 호출되는 콜백 함수
            _addRecentSearch(value);
            await SearchKeywordService().addKeyword(value);
          },
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadPopularSearches();
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "최근 검색어",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _clearAllRecentSearches();
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
              spacing: 8.0, // 간격
              runSpacing: 1.0, // 간격
              children: _recentSearches.map(_buildRecentSearchChip).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "인기 검색어",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showMorePopularSearchesDialog(context);
                  },
                  child: const Text(
                    "더보기",
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _popularSearches.isNotEmpty
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                _handleSearchTap(_popularSearches[index]);
                              },
                              child: Text(
                                "${index + 1}. ${_popularSearches[index]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 20), // 간격 조절
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                _handleSearchTap(_popularSearches[index + 5]);
                              },
                              child: Text(
                                "${index + 6}. ${_popularSearches[index + 5]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  )
                : const LinearProgressIndicator(),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "메뉴 카테고리",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _cuisineTypes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_cuisineTypes[index]),
                  leading: const Icon(Icons.info),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Provider.of<ShoppingProvider>(context, listen: false)
                        .setCurrentStoreTabIndex(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreListPage(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearchTap(String search) {
    _searchController.text = search;
    print("검색어 '$search'를 탭했습니다.");
  }

  void _showMorePopularSearchesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('인기 검색어 (상위 20개)'),
          content: SingleChildScrollView(
            child: Column(
              children: _popularSearches.map((search) {
                return ListTile(
                  title: Text(search),
                  onTap: () {
                    _handleSearchTap(search);
                    Navigator.pop(context); // 다이얼로그를 닫음
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그를 닫음
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
