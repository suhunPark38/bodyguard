import 'package:flutter/material.dart';


import '../../database/searchHistoryDatabaseHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];
  final SearchHistoryDatabaseHelper _databaseHelper = SearchHistoryDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    List<String> searches = await _databaseHelper.getSearchHistory();
    setState(() {
      _recentSearches = searches;
    });
  }

  void _addRecentSearch(String search) async {
    if (!_recentSearches.contains(search)) {
      setState(() {
        _recentSearches.add(search);
      });
      await _databaseHelper.insertSearch(search);
    }
  }

  void _removeRecentSearch(String search) async {
    setState(() {
      _recentSearches.remove(search);
    });
    await _databaseHelper.deleteSearch(search);
  }

  void _clearAllRecentSearches() async {
    setState(() {
      _recentSearches.clear();
    });
    await _databaseHelper.clearAllSearches();
  }

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('카테고리 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 카테고리 목록 추가
              ListTile(
                title: Text('카테고리 1'),
                onTap: () {
                  // 카테고리 1 선택 시 동작
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('카테고리 2'),
                onTap: () {
                  // 카테고리 2 선택 시 동작
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('카테고리 3'),
                onTap: () {
                  // 카테고리 3 선택 시 동작
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "검색어를 입력하세요",
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
          onChanged: (value) {
            // 검색어가 변경될 때마다 호출되는 콜백 함수
          },
          onSubmitted: (value) {
            // 검색 버튼을 누르거나 키보드의 '완료' 버튼을 눌렀을 때 호출되는 콜백 함수
            _addRecentSearch(value);
          },
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "최근 검색어",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextButton(
              onPressed: () {
                _clearAllRecentSearches();
              },
              child: Text(
                "모두 지우기",
                style: TextStyle(),
              ),
            ),
          ]),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _recentSearches.map((search) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _handleRecentSearchTap(search);
                      },
                      child: Text(
                        search,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _removeRecentSearch(search);
                    },
                  ),
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "인기 검색어",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "더보기",
                  style: TextStyle(),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    return Text(
                      "${index + 1}. 인기 검색어",
                      style: const TextStyle(
                        fontSize: 16,
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
                    return Text(
                      "${index + 6}. 인기 검색어",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              "전체 카테고리",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            IconButton(
              onPressed: () {
                _showCategoryDialog(context);
              },
              icon: Icon(Icons.menu, size: 40,),
            ),
          ]),
        ],
      ),
    );
  }

  void _handleRecentSearchTap(String search) {
    _searchController.text = search;
    print("검색어 '$search'를 탭했습니다.");
  }
}

