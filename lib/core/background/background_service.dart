import 'package:todo_application/core/notifications/notification_service.dart';
import 'package:todo_application/domain/entities/todo.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'checkRecurringTasks':
        await _handleRecurringTasks();
        break;
    }
    return Future.value(true);
  });
}

Future<void> _showNotification(String title, String body) async {
  await NotificationService.showNotification(title, body);
}

Future<void> _handleRecurringTasks() async {
  final prefs = await SharedPreferences.getInstance();
  final String? jsonString = prefs.getString('todos');
  if (jsonString != null) {
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<Todo> todos =
        jsonList.map((json) => Todo.fromJson(json)).toList();
    bool hasChanges = false;

    for (var todo in todos) {
      if (todo.shouldReset) {
        final index = todos.indexWhere((t) => t.id == todo.id);
        if (index != -1) {
          todos[index] = todo.copyWith(
            isCompleted: false,
            lastCompleted: null,
          );
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      final List<Map<String, dynamic>> updatedJsonList =
          todos.map((todo) => todo.toJson()).toList();
      await prefs.setString('todos', json.encode(updatedJsonList));

      // Show notification
      await _showNotification(
          'Tasks Reset', 'Some recurring tasks have been reset.');
    }
  }
}
