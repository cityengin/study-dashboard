import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_dashboard/screens/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('Mặc định: mở rộng 411 hiển thị 1 cột, mở rộng 800 hiển thị 2 cột', (WidgetTester tester) async {
    // 1. Kiểm tra ở chiều rộng 411
    tester.view.physicalSize = const Size(411, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('1 cột'), findsOneWidget);

    // 2. Kiểm tra ở chiều rộng 800
    tester.view.physicalSize = const Size(800, 1000);
    await tester.pumpAndSettle();

    expect(find.textContaining('2 cột'), findsOneWidget);
  });

  testWidgets('Bật mô phỏng và chọn chip mốc nhanh: chip 600 -> 2 cột, chip 360 -> 1 cột', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(411, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Mở bảng điều khiển demo
    await tester.tap(find.text('Bảng điều khiển demo'));
    await tester.pumpAndSettle();

    // Bấm chip 600 (ngưỡng)
    await tester.tap(find.text('600 (ngưỡng)'));
    await tester.pumpAndSettle();

    expect(find.textContaining('2 cột'), findsOneWidget);
    expect(find.textContaining('600 px'), findsWidgets);

    // Bấm chip 360 (điện thoại)
    await tester.tap(find.text('360 (điện thoại)'));
    await tester.pumpAndSettle();

    expect(find.textContaining('1 cột'), findsOneWidget);
    expect(find.textContaining('360 px'), findsWidgets);
  });

  testWidgets('Thao tác thêm môn, xóa môn, kiểm tra trạng thái và giới hạn biên', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(411, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Mở bảng điều khiển demo
    await tester.tap(find.text('Bảng điều khiển demo'));
    await tester.pumpAndSettle();

    // Ban đầu có 6 môn
    expect(find.textContaining('6 môn'), findsWidgets);

    // Bấm Thêm môn -> 7 môn
    await tester.tap(find.byKey(const Key('add_btn')));
    await tester.pumpAndSettle();

    expect(find.textContaining('7 môn'), findsWidgets);

    // Cuộn tới tìm "Môn học mới 1"
    final newCourseFinder = find.text('Môn học mới 1');
    await tester.scrollUntilVisible(
      newCourseFinder,
      100,
      scrollable: find.byType(Scrollable).last,
    );
    expect(newCourseFinder, findsOneWidget);

    // Bấm Xóa môn -> quay lại 6 môn
    await tester.tap(find.byKey(const Key('remove_btn')));
    await tester.pumpAndSettle();
    expect(find.textContaining('6 môn'), findsWidgets);

    // Xóa liên tục về 1 môn (đã có 6 môn, xóa 5 lần còn 1 môn)
    for (int i = 0; i < 5; i++) {
      await tester.tap(find.byKey(const Key('remove_btn')));
      await tester.pumpAndSettle();
    }
    expect(find.textContaining('1 môn'), findsWidgets);

    // Kiểm tra nút Xóa môn bị vô hiệu hóa khi còn 1 môn
    final removeBtn = tester.widget<OutlinedButton>(find.byKey(const Key('remove_btn')));
    expect(removeBtn.onPressed, isNull);

    // Thêm môn lên tối đa 12 môn (đang 1 môn, thêm 11 lần)
    for (int i = 0; i < 11; i++) {
      await tester.tap(find.byKey(const Key('add_btn')));
      await tester.pumpAndSettle();
    }
    expect(find.textContaining('12 môn'), findsWidgets);

    // Kiểm tra nút Thêm môn bị vô hiệu hóa khi đủ 12 môn
    final addBtn = tester.widget<FilledButton>(find.byKey(const Key('add_btn')));
    expect(addBtn.onPressed, isNull);

    // Bấm Đặt lại -> quay về 6 môn
    await tester.tap(find.byKey(const Key('reset_btn')));
    await tester.pumpAndSettle();
    expect(find.textContaining('6 môn'), findsWidgets);
  });

  testWidgets('Bật tên dài: hiển thị hậu tố dài và không xảy ra exception', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(411, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Mở bảng điều khiển
    await tester.tap(find.text('Bảng điều khiển demo'));
    await tester.pumpAndSettle();

    // Bật switch tên dài
    await tester.tap(find.byKey(const Key('long_switch')));
    await tester.pumpAndSettle();

    // Tìm thấy hậu tố tên dài
    expect(
      find.textContaining('học phần nâng cao tự chọn liên ngành kỹ thuật', skipOffstage: false),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });

  const stressTestWidths = [320.0, 411.0, 800.0];
  for (final width in stressTestWidths) {
    testWidgets('Font scale cực đại 2.0 ở rộng $width, bật tên dài và 12 môn không bị overflow', (WidgetTester tester) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Mở bảng điều khiển
      await tester.tap(find.text('Bảng điều khiển demo'));
      await tester.pumpAndSettle();

      // Bật tên dài
      await tester.tap(find.byKey(const Key('long_switch')));
      await tester.pumpAndSettle();

      // Thêm đến 12 môn (đang 6 môn -> thêm 6 lần)
      for (int i = 0; i < 6; i++) {
        await tester.tap(find.byKey(const Key('add_btn')));
        await tester.pumpAndSettle();
      }

      // Kéo font_slider về mức cực đại 2.0
      final fontSliderFinder = find.byKey(const Key('font_slider'));
      tester.widget<Slider>(fontSliderFinder).onChanged?.call(2.0);
      await tester.pumpAndSettle();

      // Xác nhận không có ngoại lệ overflow nào
      expect(tester.takeException(), isNull);
    });
  }
}
