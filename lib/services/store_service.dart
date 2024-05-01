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
}

