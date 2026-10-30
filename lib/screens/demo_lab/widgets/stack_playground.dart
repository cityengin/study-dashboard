import 'package:flutter/material.dart';

class StackPlayground extends StatefulWidget {
  const StackPlayground({super.key});

  @override
  State<StackPlayground> createState() => _StackPlaygroundState();
}

class _StackPlaygroundState extends State<StackPlayground> {
  Alignment _alignment = Alignment.center;
  StackFit _fit = StackFit.loose;
  Clip _clipBehavior = Clip.hardEdge;
  double _x = 50.0;
  double _y = 50.0;

  static const List<MapEntry<Alignment, String>> _alignmentOptions = [
    MapEntry(Alignment.topLeft, 'Trên - Trái (topLeft)'),
    MapEntry(Alignment.topCenter, 'Trên - Giữa (topCenter)'),
    MapEntry(Alignment.topRight, 'Trên - Phải (topRight)'),
    MapEntry(Alignment.centerLeft, 'Giữa - Trái (centerLeft)'),
    MapEntry(Alignment.center, 'Chính giữa (center)'),
    MapEntry(Alignment.centerRight, 'Giữa - Phải (centerRight)'),
    MapEntry(Alignment.bottomLeft, 'Dưới - Trái (bottomLeft)'),
    MapEntry(Alignment.bottomCenter, 'Dưới - Giữa (bottomCenter)'),
    MapEntry(Alignment.bottomRight, 'Dưới - Phải (bottomRight)'),
  ];

  String _getAlignmentCode(Alignment a) {
    for (final entry in _alignmentOptions) {
      if (entry.key == a) {
        final raw = entry.value.split('(').last.replaceAll(')', '');
        return 'Alignment.$raw';
      }
    }
    return 'Alignment.center';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final generatedCode =
        '''Stack(
  alignment: ${_getAlignmentCode(_alignment)},
  fit: StackFit.${_fit.name},
  clipBehavior: Clip.${_clipBehavior.name},
  children: [
    // 1. Không Positioned (định vị theo Stack.alignment)
    Container(width: 140, height: 120),
    // 2. Positioned(left: ${_x.toStringAsFixed(0)}, top: ${_y.toStringAsFixed(0)})
    Positioned(
      left: ${_x.toStringAsFixed(0)},
      top: ${_y.toStringAsFixed(0)},
      child: Container(width: 80, height: 60),
    ),
    // 3. Badge cố định góc trên phải (vẽ đè lên trước)
    Positioned(
      right: 8,
      top: 8,
      child: Badge("NEW"),
    ),
  ],
)''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dòng lưu ý nguyên lý quan trọng của Stack
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: theme.colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Quy tắc Stack: Con khai báo sau sẽ vẽ đè lên con khai báo trước (Z-index). '
                  'Các con có bọc Positioned sẽ tự quyết định vị trí và bỏ qua Stack.alignment.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Chừa padding quanh khung để Clip.none không bị vẽ đè lên các thành phần xung quanh
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SizedBox(
            height: 220,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                border: Border.all(
                  color: theme.colorScheme.outline,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              // [LayoutBuilder] Dùng để đo lường chiều rộng khung Stack, hỗ trợ giới hạn thanh trượt x
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final maxWidth = constraints.maxWidth;
                  final maxX = maxWidth - 40.0;
                  final minX = -40.0;
                  final clampedX = _x.clamp(minX, maxX);

                  // [Stack + Positioned] Xếp chồng nhiều lớp phần tử theo thứ tự z-index và định vị tọa độ
                  return Stack(
                    // [Stack.alignment] Căn vị trí cho phần tử con không bọc Positioned
                    alignment: _alignment,
                    fit: _fit,
                    // [Stack.clipBehavior] Cắt xén phần tử tràn viền hoặc cho phép hiển thị tràn ra ngoài
                    clipBehavior: _clipBehavior,
                    children: [
                      // 1. Con KHÔNG Positioned (140x120)
                      Container(
                        width: 140,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Không Positioned\n(140×120)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // 2. Con bọc Positioned(left: x, top: y) (80x60)
                      Positioned(
                        left: clampedX,
                        top: _y,
                        child: Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Positioned\n(80×60)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onTertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),

                      // 3. Con bọc Positioned góc trên phải (Badge NEW)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 1. Stack.alignment Dropdown
        Text(
          '1. Stack.alignment (Vị trí con không Positioned):',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<Alignment>(
          isExpanded: true,
          initialValue: _alignment,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: _alignmentOptions.map((opt) {
            return DropdownMenuItem<Alignment>(
              value: opt.key,
              child: Text(opt.value, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _alignment = val;
              });
            }
          },
        ),
        const SizedBox(height: 12),

        // 2. StackFit SegmentedButton
        Text(
          '2. Stack.fit (Quy tắc ép kích thước con):',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        SegmentedButton<StackFit>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: StackFit.loose, label: Text('loose')),
            ButtonSegment(value: StackFit.expand, label: Text('expand')),
          ],
          selected: {_fit},
          onSelectionChanged: (val) {
            setState(() {
              _fit = val.first;
            });
          },
        ),
        const SizedBox(height: 12),

        // 3. ClipBehavior SegmentedButton
        Text(
          '3. clipBehavior (Xử lý phần tử nằm ngoài khung):',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        SegmentedButton<Clip>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: Clip.hardEdge, label: Text('Clip.hardEdge')),
            ButtonSegment(value: Clip.none, label: Text('Clip.none')),
          ],
          selected: {_clipBehavior},
          onSelectionChanged: (val) {
            setState(() {
              _clipBehavior = val.first;
            });
          },
        ),
        const SizedBox(height: 12),

        // 4. Slider x và y
        Text(
          '4. Tọa độ Positioned (hỗ trợ giá trị âm kiểm tra clip):',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final minX = -40.0;
            final maxX = (maxWidth - 40.0).clamp(minX + 1.0, 1000.0);

            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('Left (X): ${_x.toStringAsFixed(0)}'),
                    ),
                    Expanded(
                      child: Slider(
                        value: _x.clamp(minX, maxX),
                        min: minX,
                        max: maxX,
                        onChanged: (val) {
                          setState(() {
                            _x = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('Top (Y): ${_y.toStringAsFixed(0)}'),
                    ),
                    Expanded(
                      child: Slider(
                        value: _y.clamp(-30.0, 190.0),
                        min: -30.0,
                        max: 190.0,
                        onChanged: (val) {
                          setState(() {
                            _y = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),

        // Đoạn code tương ứng
        Text(
          'Mã nguồn Stack tương ứng:',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.6,
            ),
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
