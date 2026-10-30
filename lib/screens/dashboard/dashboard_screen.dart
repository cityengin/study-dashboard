import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import 'widgets/dashboard_body.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Dashboard'),
        centerTitle: true,
      ),
      body: const DashboardBody(
        courses: mockCourses,
        deadlines: mockDeadlines,
      ),
    );
  }
}
