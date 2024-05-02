import 'package:cloud_firestore/cloud_firestore.dart';

class SearchKeywordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Firestore에서 인기 검색어 가져오는 메서드 (상위 20개만)
  Future<List<String>> getTop20KeywordsBySearchCount() async {
    var querySnapshot = await _firestore
        .collection('search_keywords')
        .orderBy('searchCount', descending: true)
        .limit(20) // 상위 20개만 가져오기
        .get();

    return querySnapshot.docs.map((doc) => doc['keyword'] as String).toList();
  }


  // Firestore에서 검색어 가져오는 메서드 (검색 횟수가 많은 순서대로 정렬)
  Future<List<String>> getKeywordsSortedBySearchCount() async {
    var querySnapshot = await _firestore
        .collection('search_keywords')
        .orderBy('searchCount', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => doc['keyword'] as String).toList();
  }

  // Firestore에 검색어 추가하는 메서드
  Future<void> addKeyword(String keyword) async {
    // 검색어가 이미 있는지 확인
    var querySnapshot = await _firestore
        .collection('search_keywords')
        .where('keyword', isEqualTo: keyword)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // 해당 검색어가 없으면 추가
      await _firestore.collection('search_keywords').add({
        'keyword': keyword,
        'searchCount': 1,
      });
    } else {
      // 해당 검색어가 이미 있으면 검색 횟수 증가
      var doc = querySnapshot.docs.first;
      await doc.reference.update({
        'searchCount': FieldValue.increment(1),
      });
    }
  }
}
