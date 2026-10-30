import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_dashboard/screens/demo_lab/demo_lab_screen.dart';

void main() {
  testWidgets('Khởi chạy DemoLabScreen, hiển thị đủ 4 tab và chuyển đổi mượt mà', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const DemoLabScreen(),
      ),
    );

    // Kiểm tra hiển thị tiêu đề Demo Lab
    expect(find.text('Demo Lab'), findsOneWidget);

    // Kiểm tra thấy đủ 4 tab trên TabBar
    expect(find.text('Trục chính/phụ'), findsOneWidget);
    expect(find.text('Expanded/Flexible'), findsOneWidget);
    expect(find.text('Stack/Positioned'), findsOneWidget);
    expect(find.text('Overflow'), findsOneWidget);

    // Mặc định ở tab 1
    expect(find.text('Nội dung tab Trục chính/phụ'), findsOneWidget);

    // Bấm chuyển sang tab 2: Expanded/Flexible
    await tester.tap(find.text('Expanded/Flexible'));
    await tester.pumpAndSettle();
    expect(find.text('Nội dung tab Expanded/Flexible'), findsOneWidget);

    // Bấm chuyển sang tab 3: Stack/Positioned
    await tester.tap(find.text('Stack/Positioned'));
    await tester.pumpAndSettle();
    expect(find.text('Nội dung tab Stack/Positioned'), findsOneWidget);

    // Bấm chuyển sang tab 4: Overflow
    await tester.tap(find.text('Overflow'));
    await tester.pumpAndSettle();
    expect(find.text('Nội dung tab Overflow'), findsOneWidget);

    // Xác nhận không có lỗi xảy ra
    expect(tester.takeException(), isNull);
  });
}
