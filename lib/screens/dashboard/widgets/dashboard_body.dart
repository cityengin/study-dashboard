import 'package:flutter/material.dart';
import '../../../models/study_models.dart';
import 'course_list.dart';
import 'deadline_list.dart';
import 'profile_banner.dart';
import 'stats_row.dart';

class DashboardBody extends StatelessWidget {
  final List<Course> courses;
  final List<Deadline> deadlines;

  const DashboardBody({
    super.key,
    required this.courses,
    required this.deadlines,
  });

  @override
  Widget build(BuildContext context) {
    // [LayoutBuilder] CHỈ dùng constraints.maxWidth từ LayoutBuilder để điều hướng bố cục responsive, KHÔNG dùng MediaQuery.size
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isWideScreen = constraints.maxWidth >= 600;

        // [SingleChildScrollView] Cho phép cuộn trang linh hoạt tránh lỗi tràn không gian chiều dọc
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner thông tin sinh viên chiếm toàn bộ chiều rộng
              const ProfileBanner(),
              const SizedBox(height: 16),

              // Hàng thẻ thống kê chiếm toàn bộ chiều rộng
              StatsRow(
                courses: courses,
                deadlines: deadlines,
              ),
              const SizedBox(height: 16),

              // Bố cục phân nhánh theo độ rộng màn hình (ngưỡng 600)
              if (!isWideScreen) ...[
                // Dưới 600: Xếp dọc 1 cột (Môn học rồi đến Hạn chót)
                CourseList(courses: courses),
                const SizedBox(height: 16),
                DeadlineList(deadlines: deadlines),
              ] else ...[
                // [Row + Expanded] Từ 600 trở lên: Phân chia 2 cột với tỷ lệ flex 3 (Môn học) và flex 2 (Hạn chót)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: CourseList(courses: courses),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: DeadlineList(deadlines: deadlines),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
