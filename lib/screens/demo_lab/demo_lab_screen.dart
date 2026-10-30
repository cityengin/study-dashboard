import 'package:flutter/material.dart';
import 'widgets/axis_playground.dart';
import 'widgets/demo_card.dart';
import 'widgets/flex_playground.dart';
import 'widgets/stack_playground.dart';

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
                title: 'Trục chính và Trục phụ (Main Axis & Cross Axis)',
                description:
                    'Tương tác trực tiếp với các thuộc tính định vị và đo lường kích thước của Row và Column.',
                child: AxisPlayground(),
              ),
            ),
            _buildTabWrapper(
              child: const DemoCard(
                title: 'Expanded và Flexible (Tight vs Loose Constraints)',
                description:
                    'So sánh trực quan giữa việc ép đầy không gian (tight) của Expanded và giữ kích thước nội tại (loose) của Flexible.',
                child: FlexPlayground(),
              ),
            ),
            _buildTabWrapper(
              child: const DemoCard(
                title: 'Stack và Positioned (Xếp chồng và Tọa độ)',
                description:
                    'Khám phá thứ tự vẽ xếp lớp z-index, vị trí con không Positioned theo alignment, và hiệu ứng clipBehavior với tọa độ âm.',
                child: StackPlayground(),
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
