import 'package:flutter/material.dart';
import '../database/search_history_database.dart';
import '../model/store_model.dart';
import '../services/search_keyword_service.dart';
import '../services/store_service.dart';

class SearchProvider with ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];
  List<String> _popularSearches = [];
  List<String> _cuisineTypes = [];

  final SearchHistoryDatabase _database = SearchHistoryDatabase();
  bool _isListViewVisible = true;

  TextEditingController get searchController => _searchController;
  List<String> get recentSearches => _recentSearches;
  List<String> get popularSearches => _popularSearches;
  List<String> get cuisineTypes => _cuisineTypes;
  bool get isListViewVisible => _isListViewVisible;

  SearchProvider() {
    _loadSearchHistory();
    loadPopularSearches();
    _loadCuisineTypes();
  }

  Future<void> _loadSearchHistory() async {
    _recentSearches = await _database.getSearchHistory();
    notifyListeners();
  }

  Future<void> loadPopularSearches() async {
    _popularSearches =
    await SearchKeywordService().getTop20KeywordsBySearchCount();
    if (_popularSearches.length < 20) {
      int dummyCount = 20 - _popularSearches.length;
      _popularSearches.addAll(List.generate(dummyCount, (index) => "인기 검색어"));
    }
    notifyListeners();
  }

  Future<void> _loadCuisineTypes() async {
    _cuisineTypes = await StoreService().getAllCuisineTypes();
    notifyListeners();
  }

  Future<void> addRecentSearch(String search) async {
    if (!_recentSearches.contains(search)) {
      _recentSearches.add(search);
      notifyListeners();
      await _database.insertSearch(search);
    }
  }

  Future<void> removeRecentSearch(String search) async {
    _recentSearches.remove(search);
    notifyListeners();
    await _database.deleteSearch(search);
  }

  Future<void> clearAllRecentSearches() async {
    _recentSearches.clear();
    notifyListeners();
    await _database.clearAllSearches();
  }

  void setSearchControllerText(String text) {
    _searchController.text = text;
    notifyListeners();
  }

  void toggleListViewVisibility() {
    _isListViewVisible = !_isListViewVisible;
    notifyListeners();
  }
}
