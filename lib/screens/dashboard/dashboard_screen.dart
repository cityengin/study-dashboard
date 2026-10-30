import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import 'widgets/profile_banner.dart';
import 'widgets/stats_row.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Dashboard'),
        centerTitle: true,
      ),
      // [SingleChildScrollView] Cho phép cuộn trang dashboard linh hoạt tránh lỗi overflow chiều dọc
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProfileBanner(),
            const SizedBox(height: 16),
            // [Row + Expanded] Hàng thẻ thống kê phân bổ theo tỷ lệ 2:1:1
            const StatsRow(
              courses: mockCourses,
              deadlines: mockDeadlines,
            ),
          ],
        ),
      ),
    );
  }
}
