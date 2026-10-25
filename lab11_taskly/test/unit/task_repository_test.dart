import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/repositories/task_repository.dart';

void main() {
  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('Test addTask()', () {
      // Arrange
      final task = Task(id: '1', title: 'New Task');

      // Act
      repository.addTask(task);

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'New Task');
    });

    test('Test deleteTask()', () {
      // Arrange
      final task = Task(id: '1', title: 'Task to delete');
      repository.addTask(task);

      // Act
      repository.deleteTask('1');

      // Assert
      expect(repository.tasks.isEmpty, true);
    });

    test('Test updateTask()', () {
      // Arrange
      final task = Task(id: '1', title: 'Old Title');
      repository.addTask(task);

      // Act
      repository.updateTask('1', 'Updated Title');

      // Assert
      expect(repository.tasks.first.title, 'Updated Title');
    });
  });
}