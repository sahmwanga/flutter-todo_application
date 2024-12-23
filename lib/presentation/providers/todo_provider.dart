import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:todo_application/domain/entities/todo.dart';
import 'package:todo_application/domain/repositories/todo_repository.dart';

class TodoProvider with ChangeNotifier {
  final TodoRepository _repository;
  List<Todo> _todos = [];
  Timer? _recurringCheckTimer;

  TodoProvider(this._repository) {
    _loadTodos();
    _startRecurringCheck();
  }

  @override
  void dispose() {
    _recurringCheckTimer?.cancel();
    super.dispose();
  }

  void _startRecurringCheck() {
    // Check for recurring tasks reset every minute
    _recurringCheckTimer = Timer.periodic(Duration(minutes: 1), (_) {
      _checkRecurringTasks();
    });
  }

  Future<void> _checkRecurringTasks() async {
    bool hasChanges = false;
    for (var todo in _todos) {
      if (todo.shouldReset) {
        final updatedTodo = todo.copyWith(
          isCompleted: false,
          lastCompleted: null,
        );
        await _repository.updateTodo(updatedTodo);
        hasChanges = true;
      }
    }
    if (hasChanges) {
      await _loadTodos();
    }
  }

  List<Todo> get todos => _todos;

  Future<void> _loadTodos() async {
    _todos = await _repository.getTodos();
    notifyListeners();
  }

  Future<void> addTodo(
    String title, {
    RecurrenceType recurrenceType = RecurrenceType.none,
    List<int> recurrenceDays = const [],
  }) async {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      recurrenceType: recurrenceType,
      recurrenceDays: recurrenceDays,
    );
    await _repository.addTodo(todo);
    await _loadTodos();
  }

  Future<void> toggleTodo(Todo todo) async {
    final now = DateTime.now();
    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      lastCompleted: !todo.isCompleted ? now : null,
    );
    await _repository.updateTodo(updatedTodo);
    await _loadTodos();
  }

  Future<void> updateTodoRecurrence(
    Todo todo,
    RecurrenceType recurrenceType,
    List<int> recurrenceDays,
  ) async {
    final updatedTodo = todo.copyWith(
      recurrenceType: recurrenceType,
      recurrenceDays: recurrenceDays,
    );
    await _repository.updateTodo(updatedTodo);
    await _loadTodos();
  }

  Future<void> deleteTodo(String id) async {
    await _repository.deleteTodo(id);
    await _loadTodos();
  }

  // Add this method
  Future<List<Todo>> getTodos() async {
    return _repository.getTodos();
  }

  // Add this method
  Future<void> updateTodo(Todo todo) async {
    await _repository.updateTodo(todo);
    await _loadTodos();
  }
}
