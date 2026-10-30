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
  bool _longText = false;
  int _nextCourseIndex = 1;

  late List<Course> _courses;
  late List<Deadline> _deadlines;

  @override
  void initState() {
    super.initState();
    // Luôn làm việc trên bản sao danh sách dữ liệu giả định
    _courses = List.of(mockCourses);
    _deadlines = List.of(mockDeadlines);
  }

  void _addCourse() {
    if (_courses.length >= 12) return;
    setState(() {
      _courses.add(
        Course(
          name: 'Môn học mới $_nextCourseIndex',
          credits: 3,
          progress: 0.5,
          score: 8.0,
        ),
      );
      _nextCourseIndex++;
    });
  }

  void _removeCourse() {
    if (_courses.length <= 1) return;
    setState(() {
      _courses.removeLast();
    });
  }

  void _resetAll() {
    setState(() {
      _simulateWidth = false;
      _simWidth = 411.0;
      _fontScale = 1.0;
      _longText = false;
      _courses = List.of(mockCourses);
      _deadlines = List.of(mockDeadlines);
      _nextCourseIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Biến đổi văn bản dài chỉ khi hiển thị, không ghi đè dữ liệu gốc trong state
    final displayedCourses = _longText
        ? _courses
            .map(
              (c) => Course(
                name: '${c.name} — học phần nâng cao tự chọn liên ngành kỹ thuật',
                credits: c.credits,
                progress: c.progress,
                score: c.score,
              ),
            )
            .toList()
        : _courses;

    final displayedDeadlines = _longText
        ? _deadlines
            .map(
              (d) => Deadline(
                title: '${d.title} (nộp báo cáo kèm slide và mã nguồn đầy đủ)',
                courseName: d.courseName,
                daysLeft: d.daysLeft,
              ),
            )
            .toList()
        : _deadlines;

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
              // Bảng điều khiển demo với đầy đủ nút thêm/xóa môn học, text dài và đặt lại
              DemoControlPanel(
                simulateWidth: _simulateWidth,
                simWidth: _simWidth,
                fontScale: _fontScale,
                longText: _longText,
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
                onLongTextChanged: (bool value) {
                  setState(() {
                    _longText = value;
                  });
                },
                onAddCourse: _courses.length < 12 ? _addCourse : null,
                onRemoveCourse: _courses.length > 1 ? _removeCourse : null,
                onReset: _resetAll,
              ),

              // [Expanded] Khung xem trước nhận danh sách môn và deadline (đã biến đổi theo longText nếu bật)
              Expanded(
                child: PreviewFrame(
                  simulate: _simulateWidth,
                  width: _simWidth,
                  fontScale: _fontScale,
                  child: DashboardBody(
                    courses: displayedCourses,
                    deadlines: displayedDeadlines,
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
