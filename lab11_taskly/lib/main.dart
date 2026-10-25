import 'package:flutter/material.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(TasklyApp());
}

class TasklyApp extends StatelessWidget {
  final TaskRepository repository = TaskRepository();

  TasklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskly',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: TaskListScreen(repository: repository),
    );
  }
}