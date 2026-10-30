import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_dashboard/screens/demo_lab/demo_lab_screen.dart';
import 'package:study_dashboard/screens/demo_lab/widgets/axis_playground.dart';
import 'package:study_dashboard/screens/demo_lab/widgets/flex_playground.dart';
import 'package:study_dashboard/screens/demo_lab/widgets/overflow_gallery.dart';
import 'package:study_dashboard/screens/demo_lab/widgets/stack_playground.dart';

void main() {
  testWidgets('Khởi chạy DemoLabScreen, chuyển qua các tab và nuốt lỗi có chủ đích ở tab 4', (WidgetTester tester) async {
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
    expect(find.byType(AxisPlayground), findsOneWidget);

    // Tab 2: Expanded/Flexible
    await tester.ensureVisible(find.text('Expanded/Flexible'));
    await tester.tap(find.text('Expanded/Flexible'));
    await tester.pumpAndSettle();
    expect(find.byType(FlexPlayground), findsOneWidget);

    // Tab 3: Stack/Positioned
    await tester.ensureVisible(find.text('Stack/Positioned'));
    await tester.tap(find.text('Stack/Positioned'));
    await tester.pumpAndSettle();
    expect(find.byType(StackPlayground), findsOneWidget);

    // Tab 4: Overflow (chứa lỗi overflow chủ đích để minh họa)
    await tester.ensureVisible(find.text('Overflow'));
    await tester.tap(find.text('Overflow'));
    await tester.pump();
    while (tester.takeException() != null) {}
    await tester.pump(const Duration(milliseconds: 500));
    while (tester.takeException() != null) {}

    expect(find.byType(OverflowGallery), findsOneWidget);
  });

  testWidgets('Thao tác tương tác trên AxisPlayground (Row/Column, alignments, mainAxisSize)', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Scaffold(
          body: SingleChildScrollView(
            child: AxisPlayground(),
          ),
        ),
      ),
    );

    // Ban đầu mặc định là Row
    expect(find.text('Trục chính: ngang →, trục phụ: dọc ↓'), findsOneWidget);
    expect(find.textContaining('Row('), findsOneWidget);

    // Chuyển sang Column
    await tester.tap(find.text('Column'));
    await tester.pumpAndSettle();
    expect(find.text('Trục chính: dọc ↓, trục phụ: ngang →'), findsOneWidget);
    expect(find.textContaining('Column('), findsOneWidget);

    // Chọn mainAxisSize min
    await tester.tap(find.text('min'));
    await tester.pumpAndSettle();
    expect(find.textContaining('mainAxisSize: MainAxisSize.min'), findsOneWidget);

    // Chọn mainAxisAlignment center
    await tester.tap(find.text('center').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('mainAxisAlignment: MainAxisAlignment.center'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Thao tác tương tác trên FlexPlayground (thanh trượt flex A, B và cập nhật tỉ lệ)', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Scaffold(
          body: SingleChildScrollView(
            child: FlexPlayground(),
          ),
        ),
      ),
    );

    // Kiểm tra tỉ lệ ban đầu 1 : 2
    expect(find.text('Tỉ lệ 1 : 2'), findsOneWidget);
    expect(find.text('Cố định\n56px'), findsNWidgets(2));
    expect(find.text('flex 1'), findsNWidgets(2));
    expect(find.text('flex 2'), findsNWidgets(2));

    // Kéo thanh trượt Flex A
    final sliders = find.byType(Slider);
    expect(sliders, findsNWidgets(2));

    await tester.drag(sliders.first, const Offset(100, 0));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('Thao tác tương tác trên StackPlayground (fit, clipBehavior, alignment)', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Scaffold(
          body: SingleChildScrollView(
            child: StackPlayground(),
          ),
        ),
      ),
    );

    expect(find.text('Không Positioned\n(140×120)'), findsOneWidget);
    expect(find.text('Positioned\n(80×60)'), findsOneWidget);
    expect(find.text('NEW'), findsOneWidget);

    // Chuyển fit sang expand
    await tester.tap(find.text('expand'));
    await tester.pumpAndSettle();
    expect(find.textContaining('fit: StackFit.expand'), findsOneWidget);

    // Chuyển clip sang none
    await tester.tap(find.text('Clip.none'));
    await tester.pumpAndSettle();
    expect(find.textContaining('clipBehavior: Clip.none'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  // Kiểm thử độc lập từng case trong thư viện overflowCases
  for (final overflowCase in overflowCases) {
    testWidgets('Kiểm thử độc lập case: ${overflowCase.title}', (WidgetTester tester) async {
      // 1. Pump beforeBuilder một mình: nếu throwsOverflow thì bắt buộc phải ném lỗi overflowed
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Center(
              child: Builder(builder: overflowCase.beforeBuilder),
            ),
          ),
        ),
      );

      if (overflowCase.throwsOverflow) {
        final error = tester.takeException();
        expect(error, isNotNull);
        expect(error.toString(), contains('overflowed'));

        // Nuốt hết các exception còn lại từ frame render
        while (tester.takeException() != null) {}
      }

      // 2. Pump afterBuilder một mình: đảm bảo giải pháp khắc phục triệt để không có bất kỳ exception nào
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Center(
              child: Builder(builder: overflowCase.afterBuilder),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  // Kiểm thử tab 1-3 của DemoLabScreen ở các bề rộng 320, 411, 800 với textScaler 1.3
  const testWidths = [320.0, 411.0, 800.0];

  for (final width in testWidths) {
    testWidgets(
      'Kiểm thử tab 1-3 DemoLabScreen tại bề rộng $width với textScaler 1.3 không bị exception',
      (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(width, 1000),
                textScaler: const TextScaler.linear(1.3),
              ),
              child: const DemoLabScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tab 1: Trục chính/phụ
        expect(tester.takeException(), isNull);

        // Tab 2: Expanded/Flexible
        await tester.ensureVisible(find.text('Expanded/Flexible'));
        await tester.tap(find.text('Expanded/Flexible'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Tab 3: Stack/Positioned
        await tester.ensureVisible(find.text('Stack/Positioned'));
        await tester.tap(find.text('Stack/Positioned'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
