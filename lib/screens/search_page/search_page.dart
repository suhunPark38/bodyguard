import 'package:flutter/material.dart';

import '../../services/search_keyword_service.dart';
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
  List<String> _popularSearches = [];
  final SearchHistoryDatabaseHelper _databaseHelper = SearchHistoryDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _loadPopularSearches();
  }

  Future<void> _loadSearchHistory() async {
    List<String> searches = await _databaseHelper.getSearchHistory();
    setState(() {
      _recentSearches = searches;

    });
  }

  Future<void> _loadPopularSearches() async {
    List<String> popularSearches =
    await SearchKeywordService().getTop20KeywordsBySearchCount();
    setState(() {
      _popularSearches = popularSearches;
      if(_popularSearches.length <20)
        {
          int dummyCount = 20 - _popularSearches.length;
          _popularSearches.addAll(List.generate(dummyCount, (index) => "인기 검색어에요."));
        }

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
          onSubmitted: (value) async{

            // 검색 버튼을 누르거나 키보드의 '완료' 버튼을 눌렀을 때 호출되는 콜백 함수
            _addRecentSearch(value);
            await SearchKeywordService().addKeyword(value);
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
                        _handleSearchTap(search);
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
              const Text(
                "인기 검색어",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {_showMorePopularSearchesDialog(context); },
                child: const Text(
                  "더보기",
                  style: TextStyle(),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _popularSearches.isNotEmpty ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {

                    return
                      GestureDetector(
                    onTap: () {
                    _handleSearchTap(_popularSearches[index]);
                    },
                    child: Text(
                      "${index + 1}. ${_popularSearches[index]}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                      );
                  }),
                ),
              ),
              const SizedBox(width: 20), // 간격 조절
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    return     GestureDetector(
                        onTap: () {
                      _handleSearchTap(_popularSearches[index+5]);
                    },
                    child: Text(
                      "${index + 6}. ${_popularSearches[index+5]}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ));
                  }),
                ),
              ),
            ],
          ): const LinearProgressIndicator(),
          const SizedBox(height: 20),
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

  void _handleSearchTap(String search) {
    _searchController.text = search;
    print("검색어 '$search'를 탭했습니다.");
  }
  void _showMorePopularSearchesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('인기 검색어 (상위 20개)'),
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
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

}

