import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:todo_application/domain/entities/todo.dart';
import 'package:todo_application/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final FirebaseFirestore firestore;
  static const String _collection = 'todos';

  TodoRepositoryImpl({required this.firestore});

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final QuerySnapshot querySnapshot =
          await firestore.collection(_collection).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Convert Timestamp to DateTime if lastCompleted exists
        final Timestamp? timestamp = data['lastCompleted'];
        final DateTime? lastCompleted = timestamp?.toDate();

        return Todo(
          id: doc.id,
          title: data['title'],
          isCompleted: data['isCompleted'],
          recurrenceType: RecurrenceType.values.firstWhere(
            (e) => e.toString() == data['recurrenceType'],
            orElse: () => RecurrenceType.none,
          ),
          recurrenceDays: List<int>.from(data['recurrenceDays'] ?? []),
          lastCompleted: lastCompleted,
        );
      }).toList();
    } catch (e) {
      print('Error getting todos: $e');
      return [];
    }
  }

  @override
  Future<void> addTodo(Todo todo) async {
    try {
      final todoData = {
        'title': todo.title,
        'isCompleted': todo.isCompleted,
        'recurrenceType': todo.recurrenceType.toString(),
        'recurrenceDays': todo.recurrenceDays,
        'lastCompleted': todo.lastCompleted != null
            ? Timestamp.fromDate(todo.lastCompleted!)
            : null,
      };

      await firestore.collection(_collection).doc(todo.id).set(todoData);
    } catch (e) {
      print('Error adding todo: $e');
      throw Exception('Failed to add todo');
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      final todoData = {
        'title': todo.title,
        'isCompleted': todo.isCompleted,
        'recurrenceType': todo.recurrenceType.toString(),
        'recurrenceDays': todo.recurrenceDays,
        'lastCompleted': todo.lastCompleted != null
            ? Timestamp.fromDate(todo.lastCompleted!)
            : null,
      };

      await firestore.collection(_collection).doc(todo.id).update(todoData);
    } catch (e) {
      print('Error updating todo: $e');
      throw Exception('Failed to update todo');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      print('Error deleting todo: $e');
      throw Exception('Failed to delete todo');
    }
  }

  // Method to check and reset recurring tasks
  Future<bool> checkAndResetRecurringTasks() async {
    try {
      bool hasChanges = false;
      final todos = await getTodos();

      for (var todo in todos) {
        if (todo.shouldReset) {
          final resetTodo = todo.copyWith(
            isCompleted: false,
            lastCompleted: null,
          );
          await updateTodo(resetTodo);
          hasChanges = true;
        }
      }

      return hasChanges;
    } catch (e) {
      print('Error checking recurring tasks: $e');
      throw Exception('Failed to check recurring tasks');
    }
  }
}
