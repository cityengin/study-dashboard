import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'demo_lab/demo_lab_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    DemoLabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [IndexedStack] Quản lý hiển thị nhiều lớp màn hình theo index, giữ nguyên state của từng tab
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science),
            label: 'Demo Lab',
          ),
        ],
      ),
    );
  }
}
