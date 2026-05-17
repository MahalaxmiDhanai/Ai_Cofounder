import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveIdea(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('ideas').add(data);
    } catch (e) {
      print('Firestore Error: $e');
    }
  }
}
