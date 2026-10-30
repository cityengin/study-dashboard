import 'package:flutter/material.dart';
import 'widgets/demo_card.dart';

class DemoLabScreen extends StatelessWidget {
  const DemoLabScreen({super.key});

  Widget _buildTabWrapper({required Widget child}) {
    // [ConstrainedBox] Giới hạn bề rộng tối đa 720px giúp nội dung tập trung, không bị dàn trải trên màn hình lớn
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        // [SingleChildScrollView] Đảm bảo cuộn linh hoạt theo chiều dọc, tránh lỗi tràn nội dung
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // [DefaultTabController + TabBarView] Điều hướng 4 phân hệ demo, cố định vuốt ngang để không xung đột thanh trượt
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Demo Lab'),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Trục chính/phụ'),
              Tab(text: 'Expanded/Flexible'),
              Tab(text: 'Stack/Positioned'),
              Tab(text: 'Overflow'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildTabWrapper(
              child: const DemoCard(
                title: 'Trục chính và Trục phụ',
                description: 'Thử nghiệm tương tác bố cục với Row và Column.',
                child: SizedBox(
                  height: 120,
                  child: Center(child: Text('Nội dung tab Trục chính/phụ')),
                ),
              ),
            ),
            _buildTabWrapper(
              child: const DemoCard(
                title: 'Expanded và Flexible',
                description: 'So sánh cơ chế phân chia không gian giữa Expanded và Flexible.',
                child: SizedBox(
                  height: 120,
                  child: Center(child: Text('Nội dung tab Expanded/Flexible')),
                ),
              ),
            ),
            _buildTabWrapper(
              child: const DemoCard(
                title: 'Stack và Positioned',
                description: 'Khám phá xếp chồng lớp giao diện và căn chỉnh tọa độ.',
                child: SizedBox(
                  height: 120,
                  child: Center(child: Text('Nội dung tab Stack/Positioned')),
                ),
              ),
            ),
            _buildTabWrapper(
              child: const DemoCard(
                title: 'Thư viện lỗi Overflow',
                description: 'Các tình huống tràn không gian phổ biến và giải pháp khắc phục.',
                child: SizedBox(
                  height: 120,
                  child: Center(child: Text('Nội dung tab Overflow')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
