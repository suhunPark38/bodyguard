import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bodyguard/model/storeModel.dart';

import '../model/menuModel.dart';

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

  Stream<List<Menu>> getStoreMenu(String storeId) {
    return _storeCollection.doc(storeId).collection('menu').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Menu.fromJson(doc.data() as Map<String, dynamic>?)).toList());
  }
}

