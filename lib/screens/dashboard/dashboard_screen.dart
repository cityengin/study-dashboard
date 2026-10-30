import 'package:flutter/material.dart';
import 'widgets/profile_banner.dart';

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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileBanner(),
          ],
        ),
      ),
    );
  }
}
