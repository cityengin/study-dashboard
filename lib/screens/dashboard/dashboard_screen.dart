import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/study_models.dart';
import 'widgets/dashboard_body.dart';
import 'widgets/demo_control_panel.dart';
import 'widgets/preview_frame.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _simulateWidth = false;
  double _simWidth = 411.0;
  double _fontScale = 1.0;
  late List<Course> _courses;
  late List<Deadline> _deadlines;

  @override
  void initState() {
    super.initState();
    // Luôn làm việc trên bản sao danh sách dữ liệu giả định
    _courses = List.of(mockCourses);
    _deadlines = List.of(mockDeadlines);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Dashboard'),
        centerTitle: true,
      ),
      // [LayoutBuilder] Xác định chiều rộng khả dụng của màn hình để tính toán chiều rộng hiệu lực và số cột hiển thị
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double effectiveWidth = _simulateWidth ? _simWidth : constraints.maxWidth;
          final int columnCount = effectiveWidth >= dashboardWideBreakpoint ? 2 : 1;

          return Column(
            children: [
              // Bảng điều khiển demo độc lập không bị ảnh hưởng bởi font scale của khung xem trước
              DemoControlPanel(
                simulateWidth: _simulateWidth,
                simWidth: _simWidth,
                fontScale: _fontScale,
                courseCount: _courses.length,
                columnCount: columnCount,
                effectiveWidth: effectiveWidth,
                onSimulateWidthChanged: (bool value) {
                  setState(() {
                    _simulateWidth = value;
                  });
                },
                onSimWidthChanged: (double value) {
                  setState(() {
                    _simWidth = value;
                  });
                },
                onFontScaleChanged: (double value) {
                  setState(() {
                    _fontScale = value;
                  });
                },
              ),

              // [Expanded] Khung xem trước chiếm toàn bộ không gian còn lại và áp dụng mô phỏng kích thước, font scale
              Expanded(
                child: PreviewFrame(
                  simulate: _simulateWidth,
                  width: _simWidth,
                  fontScale: _fontScale,
                  child: DashboardBody(
                    courses: _courses,
                    deadlines: _deadlines,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
