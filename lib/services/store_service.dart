import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bodyguard/model/store_model.dart';
import 'package:bodyguard/model/store_menu.dart';


class StoreService {
  final CollectionReference _storeCollection = FirebaseFirestore.instance.collection('store');

  Future<void> addStore(Store store) async {
    try {
      await _storeCollection.add(store.toJson());
    } catch (e) {
      print("Error adding store: $e");
    }
  }

  Future<void> updateStore(String storeId, Store newStore) async {
    try {
      await _storeCollection.doc(storeId).update(newStore.toJson());
    } catch (e) {
      print("Error updating store: $e");
    }
  }

  Future<void> deleteStore(String storeId) async {
    try {
      await _storeCollection.doc(storeId).delete();
    } catch (e) {
      print("Error deleting store: $e");
    }
  }

  Stream<List<Store>> getStores() {
    return _storeCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Store.fromJson(doc.id, doc.data() as Map<String, dynamic>?)).toList());
  }

  Stream<List<StoreMenu>> getStoreMenu(String storeId) {
    log("메뉴 받아오기 시작");
    return _storeCollection.doc(storeId).collection('menu').snapshots().map((snapshot) {
      log("Snapshot 데이터 수: ${snapshot.docs.length}");  // Snapshot 내 문서 수 로그

      List<StoreMenu> menus = snapshot.docs.map((doc) {
        StoreMenu menu = StoreMenu.fromJson(doc.id, doc.data());
        log("메뉴 처리: ${menu.menuName}");  // 각 메뉴 이름 로그
        return menu;
      }).toList();

      log("가공된 메뉴 리스트: ${menus.map((m) => m.menuName).join(', ')}");  // 가공된 메뉴 리스트 로그
      return menus;
    });
  }

  Future<StoreMenu?> getMenuById(String storeId, String menuId) async {
    try {
      DocumentSnapshot menuSnapshot = await _storeCollection.doc(storeId).collection('menu').doc(menuId).get();
      if (menuSnapshot.exists) {
        StoreMenu menu = StoreMenu.fromJson(menuSnapshot.id, menuSnapshot.data()! as Map<String, dynamic>);
        return menu;
      } else {
        return null; // 해당 ID의 메뉴가 존재하지 않을 경우 null 반환a
      }
    } catch (e) {
      print("Error getting menu by ID: $e");
      return null; // 에러 발생 시 null 반환
    }
  }


  Future<List<String>> getAllCuisineTypes() async {
    try {
      QuerySnapshot querySnapshot = await _storeCollection.get();
      Set<String> cuisineTypesSet = Set(); // 중복을 허용하지 않는 Set 활용
      for (var doc in querySnapshot.docs) {
        cuisineTypesSet.add(doc['cuisineType'] as String); // 가게 종류를 Set에 추가
      }
      return cuisineTypesSet.toList(); // Set을 List로 변환하여 반환
    } catch (e) {
      print("Error getting all cuisine types: $e");
      return []; // 에러 발생 시 빈 리스트 반환
    }
  }

  Stream<List<Store>> getStoresByCuisineType(String cuisineType)  {
    return _storeCollection.where('cuisineType', isEqualTo: cuisineType)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Store.fromJson(doc.id, doc.data() as Map<String, dynamic>?))
        .toList());
  }
}

