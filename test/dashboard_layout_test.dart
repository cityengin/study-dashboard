import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_dashboard/data/mock_data.dart';
import 'package:study_dashboard/screens/dashboard/widgets/dashboard_body.dart';

void main() {
  const testWidths = [320.0, 411.0, 800.0];

  for (final width in testWidths) {
    testWidgets(
      'Kiểm thử bố cục DashboardBody tại chiều rộng $width với textScaler 1.3 không bị overflow',
      (WidgetTester tester) async {
        // Cấu hình kích thước viewport cho tester
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        // Bọc MaterialApp với MediaQuery có textScaler 1.3
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(width, 1000),
                textScaler: const TextScaler.linear(1.3),
              ),
              child: const Scaffold(
                body: DashboardBody(
                  courses: mockCourses,
                  deadlines: mockDeadlines,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Kiểm tra không có bất kỳ exception nào (không tràn màn hình overflow)
        expect(tester.takeException(), isNull);
      },
    );
  }
}
