import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/repositories/task_repository.dart';
import 'package:taskly/screens/task_list_screen.dart';

void main() {
  testWidgets('Full flow: Add -> Open detail -> Edit -> Save -> Verify in list', (tester) async {
    final repo = TaskRepository();

    await tester.pumpWidget(MaterialApp(
      home: TaskListScreen(repository: repo),
    ));

    // 1. Thêm "Original title"
    await tester.enterText(find.byType(TextField), 'Original title');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Original title'), findsOneWidget);

    // 2. Chạm vào task để mở màn hình chi tiết
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();

    // 3. Sửa tiêu đề thành "Updated title"
    await tester.enterText(find.byKey(const Key('detailTitleField')), 'Updated title');

    // 4. Bấm Save và quay lại
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // 5. Kiểm tra màn hình chính đã đổi sang "Updated title"
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}