class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String priority;
  final bool isCompleted;
  final int userId;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
      userId: map['userId'],
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }

  //for api
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      // ✅ handle backend typo 'priiority'
      priority: json['priority'] ?? json['priiority'] ?? 'Medium',
      isCompleted: json['is_completed'] == true || json['is_completed'] == 1,
      userId: json['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String().split('T')[0], // → "2026-04-20"
      'priority': priority,
      'is_completed': isCompleted,
      'user_id': userId,
    };
  }
}