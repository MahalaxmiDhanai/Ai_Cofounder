import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plan_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  User? get currentUser => _auth.currentUser;

  String? get userId => _auth.currentUser?.uid;

  Future<void> saveUserName(String name) async {
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String?> getUserName() async {
    if (userId == null) return null;

    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['name'] as String?;
  }

  Future<String> savePlan(PlanModel plan) async {
    if (userId == null) throw Exception('User not authenticated');

    final docRef =
        await _firestore.collection('plans').add(plan.toMap());

    return docRef.id;
  }

  Future<void> updatePlan(String planId, Map<String, dynamic> data) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('plans').doc(planId).update(data);
  }

  Future<PlanModel?> getCurrentPlan() async {
    if (userId == null) return null;

    final querySnapshot = await _firestore
        .collection('plans')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    final doc = querySnapshot.docs.first;
    return PlanModel.fromMap(doc.id, doc.data());
  }

  Future<List<PlanModel>> getAllPlans() async {
    if (userId == null) return [];

    final querySnapshot = await _firestore
        .collection('plans')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => PlanModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> completeDay(String planId, int day, List<String> completedTaskIds, int totalCompleted) async {
    await updatePlan(planId, {
      'current_day': day,
      'completed_task_ids': completedTaskIds,
      'completed_tasks_count': totalCompleted,
    });
  }

  Future<void> deletePlan(String planId) async {
    await _firestore.collection('plans').doc(planId).delete();
  }
}
