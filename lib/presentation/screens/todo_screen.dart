import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/core/notifications/notification_service.dart';
import 'package:todo_application/domain/entities/todo.dart';
import 'package:todo_application/domain/repositories/todo_repository_impl.dart';
import 'package:todo_application/presentation/providers/todo_provider.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // In TodoScreen, add this method
    Future<void> _checkRecurringTasks() async {
      try {
        final todoRepository = context.read<TodoRepositoryImpl>();
        final hasChanges = await todoRepository.checkAndResetRecurringTasks();

        if (hasChanges) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tasks have been reset'),
            ),
          );
          await NotificationService.showNotification(
              'Tasks Reset', 'Some recurring tasks have been reset.');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No tasks needed resetting'),
            ),
          );
          await NotificationService.showNotification(
              'Tasks Check', 'No tasks needed resetting.');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking tasks: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkRecurringTasks,
          )
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return ListTile(
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) => todoProvider.toggleTodo(todo),
                ),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration:
                        todo.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: _buildRecurrenceText(todo),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.repeat),
                      onPressed: () => _showRecurrenceDialog(context, todo),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => todoProvider.deleteTodo(todo.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final textController = TextEditingController();
    RecurrenceType selectedType = RecurrenceType.none;
    List<int> selectedDays = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Todo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Enter todo title',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                DropdownButton<RecurrenceType>(
                  value: selectedType,
                  isExpanded: true,
                  items: RecurrenceType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child:
                          Text(type.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedType = value!);
                  },
                ),
                if (selectedType == RecurrenceType.custom) ...[
                  const SizedBox(height: 16),
                  const Text('Select Days:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...List.generate(7, (index) {
                    final weekday = index + 1;
                    return CheckboxListTile(
                      title: Text([
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                        'Sunday'
                      ][index]),
                      value: selectedDays.contains(weekday),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedDays.add(weekday);
                          } else {
                            selectedDays.remove(weekday);
                          }
                          selectedDays.sort();
                        });
                      },
                    );
                  }),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  // Validate custom recurrence has selected days
                  if (selectedType == RecurrenceType.custom &&
                      selectedDays.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please select at least one day for custom recurrence'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  context.read<TodoProvider>().addTodo(
                        textController.text,
                        recurrenceType: selectedType,
                        recurrenceDays: selectedDays,
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurrenceText(Todo todo) {
    switch (todo.recurrenceType) {
      case RecurrenceType.daily:
        return const Text('Repeats daily');
      case RecurrenceType.weekly:
        return const Text('Repeats weekly');
      case RecurrenceType.custom:
        final days = todo.recurrenceDays
            .map((day) => [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday'
                ][day - 1])
            .join(', ');
        return Text('Repeats on: $days');
      default:
        return const SizedBox.shrink();
    }
  }

  void _showRecurrenceDialog(BuildContext context, Todo todo) {
    RecurrenceType selectedType = todo.recurrenceType;
    List<int> selectedDays = List.from(todo.recurrenceDays);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Set Recurrence'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<RecurrenceType>(
                value: selectedType,
                items: RecurrenceType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedType = value!);
                },
              ),
              if (selectedType == RecurrenceType.custom) ...[
                const SizedBox(height: 16),
                ...List.generate(7, (index) {
                  final weekday = index + 1;
                  return CheckboxListTile(
                    title: Text([
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                      'Sunday'
                    ][index]),
                    value: selectedDays.contains(weekday),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value!) {
                          selectedDays.add(weekday);
                        } else {
                          selectedDays.remove(weekday);
                        }
                      });
                    },
                  );
                }),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<TodoProvider>().updateTodoRecurrence(
                      todo,
                      selectedType,
                      selectedDays,
                    );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
