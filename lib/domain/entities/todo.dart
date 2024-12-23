enum RecurrenceType { none, daily, weekly, custom }

class Todo {
  final String id;
  final String title;
  final bool isCompleted;
  final RecurrenceType recurrenceType;
  final List<int> recurrenceDays; // 1 = Monday, 7 = Sunday
  final DateTime? lastCompleted;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.recurrenceType = RecurrenceType.none,
    this.recurrenceDays = const [],
    this.lastCompleted,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    RecurrenceType? recurrenceType,
    List<int>? recurrenceDays,
    DateTime? lastCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceDays: recurrenceDays ?? this.recurrenceDays,
      lastCompleted: lastCompleted ?? this.lastCompleted,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      recurrenceType: RecurrenceType.values.firstWhere(
        (e) => e.toString() == json['recurrenceType'],
        orElse: () => RecurrenceType.none,
      ),
      recurrenceDays: List<int>.from(json['recurrenceDays'] ?? []),
      lastCompleted: json['lastCompleted'] != null
          ? DateTime.parse(json['lastCompleted'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'recurrenceType': recurrenceType.toString(),
      'recurrenceDays': recurrenceDays,
      'lastCompleted': lastCompleted?.toIso8601String(),
    };
  }

  // bool get shouldReset {
  //   if (lastCompleted == null || !isCompleted) return false;

  //   final now = DateTime.now();
  //   switch (recurrenceType) {
  //     case RecurrenceType.daily:
  //       return lastCompleted!.day != now.day;
  //     case RecurrenceType.weekly:
  //       return now.difference(lastCompleted!).inDays >= 7;
  //     case RecurrenceType.custom:
  //       if (recurrenceDays.isEmpty) return false;
  //       final currentWeekday = now.weekday;
  //       return recurrenceDays.contains(currentWeekday) &&
  //           lastCompleted!.day != now.day;
  //     case RecurrenceType.none:
  //       return false;
  //   }
  // }

// todo: remove this function, its for testing
  bool get shouldReset {
    // if (lastCompleted == null || !isCompleted) return false;

    final now = DateTime.now();
    switch (recurrenceType) {
      case RecurrenceType.daily:
        // Change from checking days to checking minutes
        // For example, reset every 2 minutes:
        return now.difference(lastCompleted!).inMinutes >= 2;

      case RecurrenceType.weekly:
        // Change from 7 days to 5 minutes for testing
        return now.difference(lastCompleted!).inMinutes >= 5;

      case RecurrenceType.custom:
        if (recurrenceDays.isEmpty) return false;
        // Reset every 3 minutes if it's a selected day
        return now.difference(lastCompleted!).inMinutes >= 3;

      case RecurrenceType.none:
        return false;
    }
  }
}
