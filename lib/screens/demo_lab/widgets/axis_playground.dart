import 'package:flutter/material.dart';

class AxisPlayground extends StatefulWidget {
  const AxisPlayground({super.key});

  @override
  State<AxisPlayground> createState() => _AxisPlaygroundState();
}

class _AxisPlaygroundState extends State<AxisPlayground> {
  bool _isRow = true;
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.start;
  CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.start;
  MainAxisSize _mainAxisSize = MainAxisSize.max;

  Widget _buildColorBox({
    required String text,
    required double width,
    required double height,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: width,
      height: height,
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
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  List<Widget> _buildBoxes(ThemeData theme) {
    return [
      _buildColorBox(
        text: '1',
        width: 48,
        height: 40,
        color: theme.colorScheme.primary,
        textColor: theme.colorScheme.onPrimary,
      ),
      _buildColorBox(
        text: '2',
        width: 64,
        height: 72,
        color: theme.colorScheme.secondary,
        textColor: theme.colorScheme.onSecondary,
      ),
      _buildColorBox(
        text: '3',
        width: 40,
        height: 56,
        color: theme.colorScheme.tertiary,
        textColor: theme.colorScheme.onTertiary,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final axisExplanation = _isRow
        ? 'Trục chính: ngang →, trục phụ: dọc ↓'
        : 'Trục chính: dọc ↓, trục phụ: ngang →';

    final generatedCode = '''${_isRow ? 'Row' : 'Column'}(
  mainAxisAlignment: MainAxisAlignment.${_mainAxisAlignment.name},
  crossAxisAlignment: CrossAxisAlignment.${_crossAxisAlignment.name},
  mainAxisSize: MainAxisSize.${_mainAxisSize.name},
  children: const [
    Box(48×40),
    Box(64×72),
    Box(40×56),
  ],
)''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dòng thông tin giải thích hướng trục trực quan
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 18,
                color: theme.colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  axisExplanation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // [Row / Column] Khung demo cố định cao 200, viền mỏng, DecoratedBox màu nhạt bao quanh hiển thị diện tích thật
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          // [Align + DecoratedBox] Đặt sát góc trên trái và bọc nền để quan sát rõ kích thước thật khi mainAxisSize.min
          child: Align(
            alignment: Alignment.topLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isRow
                  ? Row(
                      mainAxisAlignment: _mainAxisAlignment,
                      crossAxisAlignment: _crossAxisAlignment,
                      // [MainAxisSize] Xác định không gian của Row theo trục ngang
                      mainAxisSize: _mainAxisSize,
                      children: _buildBoxes(theme),
                    )
                  : Column(
                      mainAxisAlignment: _mainAxisAlignment,
                      crossAxisAlignment: _crossAxisAlignment,
                      // [MainAxisSize] Xác định không gian của Column theo trục dọc
                      mainAxisSize: _mainAxisSize,
                      children: _buildBoxes(theme),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Bộ điều khiển: Chọn Row hoặc Column
        Text(
          '1. Loại bố cục (Layout Type):',
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: true,
              label: Text('Row'),
              icon: Icon(Icons.table_rows_outlined),
            ),
            ButtonSegment(
              value: false,
              label: Text('Column'),
              icon: Icon(Icons.view_column_outlined),
            ),
          ],
          selected: {_isRow},
          onSelectionChanged: (val) {
            setState(() {
              _isRow = val.first;
            });
          },
        ),
        const SizedBox(height: 12),

        // Bộ điều khiển: mainAxisSize
        Text(
          '2. mainAxisSize (Kích thước trục chính):',
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        SegmentedButton<MainAxisSize>(
          segments: const [
            ButtonSegment(
              value: MainAxisSize.max,
              label: Text('max (chiếm trọn không gian)'),
            ),
            ButtonSegment(
              value: MainAxisSize.min,
              label: Text('min (ôm khít các con)'),
            ),
          ],
          selected: {_mainAxisSize},
          onSelectionChanged: (val) {
            setState(() {
              _mainAxisSize = val.first;
            });
          },
        ),
        const SizedBox(height: 12),

        // Bộ điều khiển: mainAxisAlignment
        Text(
          '3. mainAxisAlignment (Căn chỉnh trục chính):',
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            MainAxisAlignment.start,
            MainAxisAlignment.end,
            MainAxisAlignment.center,
            MainAxisAlignment.spaceBetween,
            MainAxisAlignment.spaceAround,
            MainAxisAlignment.spaceEvenly,
          ].map((alignment) {
            final isSelected = _mainAxisAlignment == alignment;
            return ChoiceChip(
              label: Text(alignment.name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _mainAxisAlignment = alignment;
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),

        // Bộ điều khiển: crossAxisAlignment
        Text(
          '4. crossAxisAlignment (Căn chỉnh trục phụ):',
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CrossAxisAlignment.start,
            CrossAxisAlignment.end,
            CrossAxisAlignment.center,
            CrossAxisAlignment.stretch,
          ].map((alignment) {
            final isSelected = _crossAxisAlignment == alignment;
            return ChoiceChip(
              label: Text(alignment.name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _crossAxisAlignment = alignment;
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Đoạn code tương ứng với cấu hình đang chọn
        Text(
          'Mã nguồn minh họa:',
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
            generatedCode,
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

