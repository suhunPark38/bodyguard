import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();


}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = []; // 최근 검색어 리스트
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
        title: Text('Search'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TextField(
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
                // 모든 최근 검색어를 삭제하는 기능 추가
                _clearAllRecentSearches();
              },
              child: Text(
                "모두 지우기",
                style: TextStyle(),
              ),
            ),
          ]),
          SizedBox(height: 10),
          // 최근 검색어 표시
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _recentSearches.map((search) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 최근 검색어를 탭할 경우 동작
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
                      // 해당 검색어를 삭제하는 기능 추가
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
            IconButton(onPressed: () {_showCategoryDialog(context);}, icon: Icon( Icons.menu,size: 40,)),

          ]),
        ],
      ),
    );
  }

  // 최근 검색어를 추가하는 함수
  void _addRecentSearch(String search) {
    setState(() {
      if (!_recentSearches.contains(search)) {
        _recentSearches.add(search);
      }
    });
  }

  // 최근 검색어를 탭했을 때 동작하는 함수
  void _handleRecentSearchTap(String search) {
    // 검색어를 검색어 입력 필드에 설정
    _searchController.text = search;
    // 이곳에 최근 검색어를 탭했을 때의 동작을 구현
    print("검색어 '$search'를 탭했습니다.");
  }

  // 최근 검색어를 삭제하는 함수
  void _removeRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  // 모든 최근 검색어를 삭제하는 함수
  void _clearAllRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }
}
