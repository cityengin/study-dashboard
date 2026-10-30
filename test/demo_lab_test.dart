import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_dashboard/screens/demo_lab/demo_lab_screen.dart';
import 'package:study_dashboard/screens/demo_lab/widgets/axis_playground.dart';
import 'package:study_dashboard/screens/demo_lab/widgets/flex_playground.dart';
import 'package:study_dashboard/screens/demo_lab/widgets/stack_playground.dart';

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

    // Mặc định ở tab 1 và chứa AxisPlayground
    expect(find.byType(AxisPlayground), findsOneWidget);

    // Bấm chuyển sang tab 2: Expanded/Flexible
    await tester.tap(find.text('Expanded/Flexible'));
    await tester.pumpAndSettle();
    expect(find.byType(FlexPlayground), findsOneWidget);

    // Bấm chuyển sang tab 3: Stack/Positioned
    await tester.tap(find.text('Stack/Positioned'));
    await tester.pumpAndSettle();
    expect(find.byType(StackPlayground), findsOneWidget);

    // Bấm chuyển sang tab 4: Overflow
    await tester.tap(find.text('Overflow'));
    await tester.pumpAndSettle();
    expect(find.text('Nội dung tab Overflow'), findsOneWidget);

    // Xác nhận không có lỗi xảy ra
    expect(tester.takeException(), isNull);
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
    await tester.tap(find.text('min (ôm khít các con)'));
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
    await tester.tap(find.text('expand (ép tràn)'));
    await tester.pumpAndSettle();
    expect(find.textContaining('fit: StackFit.expand'), findsOneWidget);

    // Chuyển clip sang none
    await tester.tap(find.text('none (cho phép tràn)'));
    await tester.pumpAndSettle();
    expect(find.textContaining('clipBehavior: Clip.none'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
