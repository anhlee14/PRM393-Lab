import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  testWidgets('Empty State: displays "No tasks yet. Add one!"', (tester) async {
    final repo = TaskRepository();

    await tester.pumpWidget(MaterialApp(
      home: TaskListScreen(repository: repo),
    ));

    expect(find.text('No tasks yet. Add one!'), findsOneWidget);
  });

  testWidgets('Add Task: enter text -> tap add -> verify UI updates', (tester) async {
    final repo = TaskRepository();

    await tester.pumpWidget(MaterialApp(
      home: TaskListScreen(repository: repo),
    ));

    // Nhập nội dung
    await tester.enterText(find.byType(TextField), 'Buy Milk');
    // Bấm nút Add
    await tester.tap(find.byIcon(Icons.add));
    // Cập nhật lại UI frame
    await tester.pump();

    expect(find.text('Buy Milk'), findsOneWidget);
    expect(find.text('No tasks yet. Add one!'), findsNothing);
  });

  testWidgets('Multiple Tasks: add two tasks -> verify both visible', (tester) async {
    final repo = TaskRepository();

    await tester.pumpWidget(MaterialApp(
      home: TaskListScreen(repository: repo),
    ));

    // Task 1
    await tester.enterText(find.byType(TextField), 'Task 1');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Task 2
    await tester.enterText(find.byType(TextField), 'Task 2');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });
}