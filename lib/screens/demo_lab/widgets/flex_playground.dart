import 'package:flutter/material.dart';

class FlexPlayground extends StatefulWidget {
  const FlexPlayground({super.key});

  @override
  State<FlexPlayground> createState() => _FlexPlaygroundState();
}

class _FlexPlaygroundState extends State<FlexPlayground> {
  int _flexA = 1;
  int _flexB = 2;

  Widget _buildFixedBox() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Cố định\n56px',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _buildItemContainer({
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: 80,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final codeSnippet = '''// Row A: Expanded (mặc định FlexFit.tight -> ép đầy ô chia)
Row(
  children: [
    Box(width: 56), // Cố định
    Expanded(flex: $_flexA, child: Box(width: 80)),
    Expanded(flex: $_flexB, child: Box(width: 80)),
  ],
)

// Row B: Flexible (FlexFit.loose -> cho phép con giữ width: 80)
Row(
  children: [
    Box(width: 56), // Cố định
    Flexible(fit: FlexFit.loose, flex: $_flexA, child: Box(width: 80)),
    Flexible(fit: FlexFit.loose, flex: $_flexB, child: Box(width: 80)),
  ],
)''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bảng điều khiển thanh trượt chọn flex a và flex b
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Điều chỉnh tỉ lệ phân chia Flex:',
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Tỉ lệ $_flexA : $_flexB',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      'Flex A: $_flexA',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _flexA.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$_flexA',
                      onChanged: (val) {
                        setState(() {
                          _flexA = val.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      'Flex B: $_flexB',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _flexB.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$_flexB',
                      onChanged: (val) {
                        setState(() {
                          _flexB = val.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Hàng A: Minh họa Row với Expanded
        Text(
          'Row A: Dùng Expanded (ép đầy không gian được chia theo tỉ lệ)',
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          height: 72,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _buildFixedBox(),
              const SizedBox(width: 8),
              // [Row + Expanded] Expanded tự động áp đặt FlexFit.tight, buộc con width: 80 dãn chiếm trọn không gian flex
              Expanded(
                flex: _flexA,
                child: _buildItemContainer(
                  label: 'flex $_flexA',
                  color: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 8),
              // [Row + Expanded] Phần tử flex thứ hai cũng bị ép dãn toàn bộ phần không gian còn lại
              Expanded(
                flex: _flexB,
                child: _buildItemContainer(
                  label: 'flex $_flexB',
                  color: theme.colorScheme.secondary,
                  textColor: theme.colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Hàng B: Minh họa Row với Flexible
        Text(
          'Row B: Dùng Flexible loose (giữ width: 80px nếu nhỏ hơn phần chia)',
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          height: 72,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.15),
            border: Border.all(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _buildFixedBox(),
              const SizedBox(width: 8),
              // [Row + Flexible] Flexible với FlexFit.loose cho phép con giữ width: 80 nhỏ hơn không gian flex được chia
              Flexible(
                fit: FlexFit.loose,
                flex: _flexA,
                child: _buildItemContainer(
                  label: 'flex $_flexA',
                  color: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 8),
              // [Row + Flexible] Phần tử loose thứ hai tương tự giữ kích thước mong muốn, để trống không gian thừa
              Flexible(
                fit: FlexFit.loose,
                flex: _flexB,
                child: _buildItemContainer(
                  label: 'flex $_flexB',
                  color: theme.colorScheme.secondary,
                  textColor: theme.colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Đoạn code tương ứng
        Text(
          'Mã nguồn minh họa hai Row:',
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: SelectableText(
            codeSnippet,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
