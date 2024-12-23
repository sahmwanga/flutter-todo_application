// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// import 'package:todo_application/domain/entities/todo.dart';
// import 'package:todo_application/domain/repositories/todo_repository.dart';

// class TodoRepositoryImpl implements TodoRepository {
//   final SharedPreferences sharedPreferences;
//   final FirebaseFirestore firestore;
//   static const String _key = 'todos';

//   TodoRepositoryImpl({required this.sharedPreferences});

//   @override
//   Future<List<Todo>> getTodos() async {
//     final String? jsonString = sharedPreferences.getString(_key);
//     if (jsonString != null) {
//       final List<dynamic> jsonList = json.decode(jsonString);
//       return jsonList
//           .map((json) => Todo(
//                 id: json['id'],
//                 title: json['title'],
//                 isCompleted: json['isCompleted'],
//                 lastCompleted: json['lastCompleted'],
//               ))
//           .toList();
//     }
//     return [];
//   }

//   @override
//   Future<void> addTodo(Todo todo) async {
//     final todos = await getTodos();
//     todos.add(todo);
//     await _saveTodos(todos);
//   }

//   @override
//   Future<void> updateTodo(Todo todo) async {
//     final todos = await getTodos();
//     final index = todos.indexWhere((t) => t.id == todo.id);
//     if (index != -1) {
//       todos[index] = todo;
//       await _saveTodos(todos);
//     }
//   }

//   @override
//   Future<void> deleteTodo(String id) async {
//     final todos = await getTodos();
//     todos.removeWhere((todo) => todo.id == id);
//     await _saveTodos(todos);
//   }

//   Future<void> _saveTodos(List<Todo> todos) async {
//     // Convert each Todo to JSON using the toJson method
//     final List<Map<String, dynamic>> jsonList =
//         todos.map((todo) => todo.toJson()).toList();

//     // Save the JSON list as a string in sharedPreferences
//     await sharedPreferences.setString(_key, json.encode(jsonList));
//   }
// }
