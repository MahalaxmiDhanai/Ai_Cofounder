class PlanModel {
  final String id;
  final String userId;
  final String idea;
  final String problem;
  final String audience;
  final String solution;
  final List<String> features;
  final List<String> executionSteps;
  final Map<String, List<String>> dailyTasks;
  final int currentDay;
  final int completedTasksCount;
  final List<String> completedTaskIds;
  final DateTime createdAt;

  PlanModel({
    required this.id,
    required this.userId,
    required this.idea,
    required this.problem,
    required this.audience,
    required this.solution,
    required this.features,
    required this.executionSteps,
    required this.dailyTasks,
    this.currentDay = 1,
    this.completedTasksCount = 0,
    this.completedTaskIds = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'idea': idea,
      'problem': problem,
      'audience': audience,
      'solution': solution,
      'features': features,
      'execution_steps': executionSteps,
      'daily_tasks': dailyTasks.map((key, value) => MapEntry(key, value)),
      'current_day': currentDay,
      'completed_tasks_count': completedTasksCount,
      'completed_task_ids': completedTaskIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PlanModel.fromMap(String id, Map<String, dynamic> map) {
    Map<String, List<String>> parsedTasks = {};
    if (map['daily_tasks'] != null) {
      (map['daily_tasks'] as Map<String, dynamic>).forEach((key, value) {
        parsedTasks[key] = List<String>.from(value);
      });
    }

    return PlanModel(
      id: id,
      userId: map['userId'] ?? '',
      idea: map['idea'] ?? '',
      problem: map['problem'] ?? '',
      audience: map['audience'] ?? '',
      solution: map['solution'] ?? '',
      features: List<String>.from(map['features'] ?? []),
      executionSteps: List<String>.from(map['execution_steps'] ?? []),
      dailyTasks: parsedTasks,
      currentDay: map['current_day'] ?? 1,
      completedTasksCount: map['completed_tasks_count'] ?? 0,
      completedTaskIds: List<String>.from(map['completed_task_ids'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  PlanModel copyWith({
    String? id,
    String? userId,
    String? idea,
    String? problem,
    String? audience,
    String? solution,
    List<String>? features,
    List<String>? executionSteps,
    Map<String, List<String>>? dailyTasks,
    int? currentDay,
    int? completedTasksCount,
    List<String>? completedTaskIds,
    DateTime? createdAt,
  }) {
    return PlanModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      idea: idea ?? this.idea,
      problem: problem ?? this.problem,
      audience: audience ?? this.audience,
      solution: solution ?? this.solution,
      features: features ?? this.features,
      executionSteps: executionSteps ?? this.executionSteps,
      dailyTasks: dailyTasks ?? this.dailyTasks,
      currentDay: currentDay ?? this.currentDay,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  List<String> getTasksForDay(int day) {
    return dailyTasks['day$day'] ?? [];
  }

  int get totalTasks {
    int count = 0;
    dailyTasks.forEach((key, value) {
      count += value.length;
    });
    return count;
  }

  double get completionPercentage {
    if (totalTasks == 0) return 0.0;
    return (completedTasksCount / totalTasks) * 100;
  }
}
