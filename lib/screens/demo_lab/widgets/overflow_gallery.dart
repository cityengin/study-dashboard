import 'package:flutter/material.dart';
import 'demo_card.dart';

class OverflowCase {
  final String title;
  final String cause;
  final String fix;
  final WidgetBuilder beforeBuilder;
  final WidgetBuilder afterBuilder;
  final bool throwsOverflow;

  const OverflowCase({
    required this.title,
    required this.cause,
    required this.fix,
    required this.beforeBuilder,
    required this.afterBuilder,
    this.throwsOverflow = true,
  });
}

final List<OverflowCase> overflowCases = [
  // Case 1: Row + Text dài
  OverflowCase(
    title: '1. Văn bản dài trong hàng ngang (Row + Text)',
    cause:
        'Row cấp chiều rộng không giới hạn cho các con không bọc Expanded/Flexible. '
        'Chuỗi Text dài (≥ 80 ký tự) sẽ vượt quá giới hạn màn hình gây tràn viền phải.',
    fix:
        'Bọc Text bằng Expanded để giới hạn kích thước theo không gian còn lại của Row, '
        'kết hợp maxLines: 1 và overflow: TextOverflow.ellipsis để hiển thị dấu ba chấm.',
    beforeBuilder: (BuildContext context) {
      return SizedBox(
        width: 240,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Đây là một tiêu đề bài viết học tập rất dài vượt quá bề ngang cho phép của hàng ngang Row',
              ),
            ],
          ),
        ),
      );
    },
    afterBuilder: (BuildContext context) {
      return SizedBox(
        width: 240,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
              SizedBox(width: 8),
              // [Row + Expanded] Bọc Text bằng Expanded để tự co giãn vừa vặn, maxLines 1 và ellipsis tránh tràn
              Expanded(
                child: Text(
                  'Đây là một tiêu đề bài viết học tập rất dài vượt quá bề ngang cho phép của hàng ngang Row',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),

  // Case 2: Column nhiều dòng trong SizedBox cao cố định 140
  OverflowCase(
    title: '2. Danh sách nhiều phần tử trong khung dọc cố định (Column Overflow)',
    cause:
        'Column đặt trong khung cố định (SizedBox cao 140px) không có khả năng cuộn tự động. '
        'Khi tổng chiều cao các dòng con vượt quá 140px sẽ bị tràn chiều dọc.',
    fix:
        'Bọc Column bằng SingleChildScrollView để cho phép cuộn tự do theo trục dọc '
        'khi nội dung con dài hơn không gian hiển thị.',
    beforeBuilder: (BuildContext context) {
      return SizedBox(
        height: 140,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: List.generate(
              6,
              (index) => Container(
                height: 34,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Dòng ${index + 1}: Học phần chuyên ngành (~42px)',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ),
      );
    },
    afterBuilder: (BuildContext context) {
      return SizedBox(
        height: 140,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          // [SingleChildScrollView] Kích hoạt thanh cuộn dọc giúp người dùng cuộn xem toàn bộ các dòng
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                6,
                (index) => Container(
                  height: 34,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Dòng ${index + 1}: Học phần chuyên ngành (~42px)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  ),

  // Case 3: Row chứa 12 Chip
  OverflowCase(
    title: '3. Nhiều thẻ Chip trên một hàng ngang (Row vs Wrap)',
    cause:
        'Row không có khả năng tự ngắt xuống dòng. Khi số lượng Chip lớn (≥ 12 Chip), '
        'tổng chiều rộng các thẻ vượt qua giới hạn bề ngang sẽ gây lỗi tràn màn hình.',
    fix:
        'Thay thế Row bằng widget Wrap. Wrap tự động đẩy các phần tử xuống hàng tiếp theo '
        'với khoảng cách tùy chỉnh qua spacing và runSpacing.',
    beforeBuilder: (BuildContext context) {
      return SizedBox(
        width: 260,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: List.generate(
              12,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Chip(
                  label: Text('Kỳ ${index + 1}'),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ),
        ),
      );
    },
    afterBuilder: (BuildContext context) {
      return SizedBox(
        width: 260,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          // [Wrap] Tự động xuống dòng khi danh sách Chip vượt quá bề rộng khung 260px
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(
              12,
              (index) => Chip(
                label: Text('Kỳ ${index + 1}'),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ),
      );
    },
  ),

  // Case 4: Số lớn cỡ chữ 40 trong SizedBox rộng 120
  OverflowCase(
    title: '4. Số lớn trong khung hiển thị hẹp (Large Number / KPI)',
    cause:
        'Chuỗi số với cỡ chữ lớn 40 ("1.234.567 đ") trong hàng ngang với khung cố định rộng 120px '
        'không thể tự thu nhỏ, dẫn đến tràn khung ngang nghiêm trọng.',
    fix:
        'Bọc Text bằng widget FittedBox(fit: BoxFit.scaleDown). Văn bản sẽ tự động co tỉ lệ '
        'vừa vặn chính xác với bề rộng 120px mà vẫn giữ nguyên định dạng số.',
    beforeBuilder: (BuildContext context) {
      return SizedBox(
        width: 120,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1.234.567 đ',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      );
    },
    afterBuilder: (BuildContext context) {
      return SizedBox(
        width: 120,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          // [FittedBox] Tự động co tỉ lệ số lớn để vừa vặn trong bề rộng hẹp 120px mà không bị tràn
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '1.234.567 đ',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );
    },
  ),
];

class OverflowGallery extends StatelessWidget {
  const OverflowGallery({super.key});

  Widget _buildBadge({
    required String text,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ghi chú quan trọng trên đầu tab
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.onTertiaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sọc vàng đen chỉ hiện ở chế độ debug (flutter run).',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Danh sách các tình huống Overflow
        ...overflowCases.map((c) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DemoCard(
              title: c.title,
              description: 'Nguyên nhân: ${c.cause}\nCách sửa: ${c.fix}',
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final isWide = constraints.maxWidth >= 600;

                  final beforeWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBadge(
                        text: 'TRƯỚC (lỗi overflow)',
                        bgColor: Colors.red.shade100,
                        textColor: Colors.red.shade900,
                        borderColor: Colors.red.shade300,
                      ),
                      // Chừa khoảng trống quanh phần trước để sọc vàng đen không đè lên chữ khác
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 20, right: 16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: c.beforeBuilder(context),
                        ),
                      ),
                    ],
                  );

                  final afterWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBadge(
                        text: 'SAU (đã sửa)',
                        bgColor: Colors.green.shade100,
                        textColor: Colors.green.shade900,
                        borderColor: Colors.green.shade300,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: c.afterBuilder(context),
                        ),
                      ),
                    ],
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: beforeWidget),
                        const SizedBox(width: 16),
                        Expanded(child: afterWidget),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        beforeWidget,
                        const SizedBox(height: 8),
                        afterWidget,
                      ],
                    );
                  }
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}

