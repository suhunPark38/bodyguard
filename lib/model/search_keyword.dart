class SearchKeyword {
  final String keyword;
  int searchCount;

  SearchKeyword({
    required this.keyword,
    this.searchCount = 0, // 초기 검색 횟수는 0으로 설정
  });

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'searchCount': searchCount,
    };
  }
}