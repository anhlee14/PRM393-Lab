import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  testWidgets('Navigation from TaskList to TaskDetail verification', (tester) async {
    final repo = TaskRepository();
    // Khởi tạo sẵn 1 task trong repository
    repo.addTask(Task(id: '100', title: 'Test Navigation'));

    await tester.pumpWidget(MaterialApp(
      home: TaskListScreen(repository: repo),
    ));

    // Nhấp vào task đã tạo
    await tester.tap(find.text('Test Navigation'));
    // Chờ quá trình hoạt ảnh chuyển trang kết thúc hoàn toàn
    await tester.pumpAndSettle();

    // Xác thực AppBar tiêu đề "Task Detail"
    expect(find.text('Task Detail'), findsOneWidget);

    // Xác thực TextField chứa Key 'detailTitleField'
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}