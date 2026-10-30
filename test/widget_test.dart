import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_dashboard/main.dart';

void main() {
  testWidgets('Khởi chạy ứng dụng và chuyển tab giữa Dashboard và Demo Lab', (WidgetTester tester) async {
    // Khởi chạy ứng dụng
    await tester.pumpWidget(const MyApp());

    // Xác nhận thấy thanh NavigationBar
    expect(find.byType(NavigationBar), findsOneWidget);

    // Mặc định thấy tiêu đề AppBar của Dashboard
    expect(find.text('Study Dashboard'), findsOneWidget);

    // Chuyển sang tab Demo Lab bằng cách bấm icon Demo Lab
    await tester.tap(find.byIcon(Icons.science_outlined));
    await tester.pumpAndSettle();

    // Xác nhận đã chuyển sang màn hình Demo Lab (tìm thấy chữ Demo Lab trong Scaffold)
    expect(find.text('Demo Lab'), findsWidgets);
  });
}
