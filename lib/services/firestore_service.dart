import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveIdea(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('ideas').add(data);
    } catch (e) {
      debugPrint('Firestore Save Error: $e');
    }
  }

  Future<void> saveChat(String userId, String message, String response) async {
    try {
      await _firestore.collection('chats').add({
        'userId': userId,
        'message': message,
        'response': response,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Firestore Chat Save Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getIdeas(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('ideas')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((d) => d.data()).toList();
    } catch (e) {
      debugPrint('Firestore Fetch Error: $e');
      return [];
    }
  }

  Future<void> saveGoal(Map<String, dynamic> goal) async {
    try {
      await _firestore.collection('goals').add(goal);
    } catch (e) {
      debugPrint('Firestore Goal Save Error: $e');
    }
  }

  Stream<QuerySnapshot> getGoalsStream(String userId) {
    return _firestore
        .collection('goals')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
