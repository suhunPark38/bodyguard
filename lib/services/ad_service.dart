import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ad_model.dart';

class AdService {
  final CollectionReference _adCollection = FirebaseFirestore.instance.collection('ad');

  Future<void> addAd(String imageUrl, String storeName) async {
    try {
      await _adCollection.add({
        'imageUrl': imageUrl,
        'storeName': storeName,
      });
    } catch (e) {
      print('Error adding ad: $e');
      throw e;
    }
  }

  Future<List<Ad>> fetchAds() async {
    try {
      QuerySnapshot querySnapshot = await _adCollection.get();
      return querySnapshot.docs.map((doc) => Ad.fromDocumentSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching ads: $e');
      throw e;
    }
  }
}
