import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/core/background/background_service.dart';
import 'package:todo_application/core/notifications/notification_service.dart';
import 'package:todo_application/domain/repositories/todo_repository_impl.dart';
import 'package:todo_application/presentation/providers/todo_provider.dart';
import 'package:todo_application/presentation/screens/todo_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notifications
  await NotificationService.initialize();

  // Initialize Workmanager
  await Workmanager().initialize(callbackDispatcher);

  // Register periodic task
  await Workmanager().registerPeriodicTask(
    'checkRecurringTasks',
    'checkRecurringTasks',
    frequency: Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      // batteryNotLow: true, // Changed this line
    ),
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );

  // final sharedPreferences = await SharedPreferences.getInstance();
  final todoRepository =
      TodoRepositoryImpl(firestore: FirebaseFirestore.instance);

  // final todoRepository =
  //     TodoRepositoryImpl(sharedPreferences: sharedPreferences);

  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(todoRepository),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoScreen(),
    );
  }
}
