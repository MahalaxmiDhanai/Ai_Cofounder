import 'package:get/get.dart';
import '../models/plan_model.dart';
import '../services/ai_service.dart';
import '../services/firebase_service.dart';

class PlanController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService(
  );
  final AIService _aiService;

  PlanController({required String openaiApiKey})
      : _aiService = AIService(apiKey: openaiApiKey);

  final _plan = Rxn<PlanModel>();
  final _isLoading = false.obs;
  final _error = Rxn<String>();
  final _userName = ''.obs;
  final _completedTasksForCurrentDay = <String, bool>{}.obs;

  PlanModel? get plan => _plan.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  String get userName => _userName.value;
  Map<String, bool> get completedTasksForCurrentDay =>
      Map.unmodifiable(_completedTasksForCurrentDay);

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _isLoading.value = true;
      await _firebaseService.signInAnonymously();

      final name = await _firebaseService.getUserName();
      if (name != null) {
        _userName.value = name;
      }

      final currentPlan = await _firebaseService.getCurrentPlan();
      if (currentPlan != null && currentPlan.currentDay <= 7) {
        _plan.value = currentPlan;
        _loadCompletedTasksForCurrentDay(currentPlan);
      }
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> setUserName(String name) async {
    _isLoading.value = true;
    try {
      await _firebaseService.saveUserName(name);
      _userName.value = name;
    } catch (e) {
      _error.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> generatePlan(String idea) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final userId = _firebaseService.userId;
      if (userId == null) throw Exception('User not authenticated');

      final newPlan =
          await _aiService.generatePlan(idea: idea, userId: userId);

      final planId = await _firebaseService.savePlan(newPlan);

      _plan.value = newPlan.copyWith(id: planId);
      _loadCompletedTasksForCurrentDay(_plan.value!);
    } catch (e) {
      _error.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  void toggleTaskCompletion(String taskId) {
    if (_completedTasksForCurrentDay.containsKey(taskId)) {
      _completedTasksForCurrentDay[taskId] =
          !_completedTasksForCurrentDay[taskId]!;
    } else {
      _completedTasksForCurrentDay[taskId] = true;
    }
    _completedTasksForCurrentDay.refresh();
  }

  bool isTaskCompleted(String taskId) {
    return _completedTasksForCurrentDay[taskId] ?? false;
  }

  int get completedTasksTodayCount {
    return _completedTasksForCurrentDay.values.where((v) => v).length;
  }

  int get totalTasksToday {
    if (_plan.value == null) return 0;
    return _plan.value!.getTasksForDay(_plan.value!.currentDay).length;
  }

  Future<void> markDayComplete() async {
    if (_plan.value == null) return;

    _isLoading.value = true;

    try {
      final currentPlan = _plan.value!;
      final newDay = currentPlan.currentDay + 1;

      List<String> completedIds = [];
      _completedTasksForCurrentDay.forEach((key, value) {
        if (value) completedIds.add(key);
      });

      int totalCompleted = (currentPlan.completedTaskIds.length) +
          _completedTasksForCurrentDay.values.where((v) => v).length;

      await _firebaseService.completeDay(
        currentPlan.id,
        newDay,
        completedIds,
        totalCompleted,
      );

      _plan.value = currentPlan.copyWith(
        currentDay: newDay,
        completedTasksCount: totalCompleted,
      );

      _loadCompletedTasksForCurrentDay(_plan.value!);
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void _loadCompletedTasksForCurrentDay(PlanModel plan) {
    _completedTasksForCurrentDay.clear();
    final tasks = plan.getTasksForDay(plan.currentDay);
    for (int i = 0; i < tasks.length; i++) {
      String taskId = 'day${plan.currentDay}_task$i';
      _completedTasksForCurrentDay[taskId] =
          plan.completedTaskIds.contains(taskId);
    }
  }

  List<String> getCurrentDayTasks() {
    if (_plan.value == null) return [];
    return _plan.value!.getTasksForDay(_plan.value!.currentDay);
  }

  Future<void> startNewIdea() async {
    _plan.value = null;
    _completedTasksForCurrentDay.clear();
  }

  void clearError() {
    _error.value = null;
  }
}
