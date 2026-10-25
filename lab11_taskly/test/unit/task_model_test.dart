import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task_model.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Default completed value should be false', () {
      // Arrange & Act
      final task = Task(id: '1', title: 'Learn Testing');

      // Assert
      expect(task.isCompleted, false);
    });

    test('toggle() switches true <-> false', () {
      // Arrange
      final task = Task(id: '1', title: 'Learn Testing');

      // Act 1: false -> true
      task.toggle();
      // Assert 1
      expect(task.isCompleted, true);

      // Act 2: true -> false
      task.toggle();
      // Assert 2
      expect(task.isCompleted, false);
    });
  });
}