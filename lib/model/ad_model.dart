import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  final String id;
  final String imageUrl;
  final String storeName;

  Ad({required this.id, required this.imageUrl, required this.storeName});

  factory Ad.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Ad(
      id: doc.id,
      imageUrl: doc['imageUrl'],
      storeName: doc['storeName'],
    );
  }
}
