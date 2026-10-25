import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({super.key, required this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _inputController = TextEditingController();

  void _addTask() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        widget.repository.addTask(
          Task(id: DateTime.now().millisecondsSinceEpoch.toString(), title: text),
        );
        _inputController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.repository.tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Taskly')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task name...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text('No tasks yet. Add one!'),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        title: Text(task.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.repository.deleteTask(task.id);
                            });
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(
                                task: task,
                                onSave: (newTitle) {
                                  setState(() {
                                    widget.repository.updateTask(task.id, newTitle);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}