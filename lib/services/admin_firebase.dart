

import 'package:cloud_firestore/cloud_firestore.dart';

class AdminFirebase{

  Stream<List<Map<String, String>>> QNA() {
    return FirebaseFirestore.instance.collection('QNA').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'Question': data['Question'] as String,
          'Answer': data['Answer'] as String
        };
      }).toList();
    });
  }

  Stream<List<Map<String, String>>> announcement() {
    return FirebaseFirestore.instance.collection('Announcement').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'Title': data['Title'] as String,
          'Content': data['Content'] as String
        };
      }).toList();
    });
  }

  Stream<List<Map<String, String>>> tos() {
    return FirebaseFirestore.instance.collection('TOS').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'Term': data['Term'] as String,
          'Policy': data['Policy'] as String
        };
      }).toList();
    });
  }


  Stream<List<Map<String, String>>> appInstructions() {
    return FirebaseFirestore.instance.collection('AppInstructions').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'Title': data['Title'] as String,
          'Text': data['Text'] as String
        };
      }).toList();
    });
  }


}