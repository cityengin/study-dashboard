import 'package:flutter/material.dart';

class DemoControlPanel extends StatelessWidget {
  final bool simulateWidth;
  final double simWidth;
  final double fontScale;
  final bool longText;
  final int courseCount;
  final int columnCount;
  final double effectiveWidth;
  final ValueChanged<bool> onSimulateWidthChanged;
  final ValueChanged<double> onSimWidthChanged;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<bool> onLongTextChanged;
  final VoidCallback? onAddCourse;
  final VoidCallback? onRemoveCourse;
  final VoidCallback onReset;

  const DemoControlPanel({
    super.key,
    required this.simulateWidth,
    required this.simWidth,
    required this.fontScale,
    required this.longText,
    required this.courseCount,
    required this.columnCount,
    required this.effectiveWidth,
    required this.onSimulateWidthChanged,
    required this.onSimWidthChanged,
    required this.onFontScaleChanged,
    required this.onLongTextChanged,
    required this.onAddCourse,
    required this.onRemoveCourse,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: ExpansionTile(
        initiallyExpanded: false,
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Icon(Icons.tune, color: theme.colorScheme.primary),
        title: const Text(
          'Bảng điều khiển demo',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          'Rộng ${effectiveWidth.round()} px · $columnCount cột · chữ ×${fontScale.toStringAsFixed(1)} · $courseCount môn',
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 8),

          // [Wrap] Tự động xuống dòng Switch và nhãn mô phỏng chiều rộng
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Mô phỏng chiều rộng:',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Switch(
                key: const Key('sim_switch'),
                value: simulateWidth,
                onChanged: onSimulateWidthChanged,
              ),
              Text(
                simulateWidth ? '${simWidth.round()} px' : 'Tắt (chiều rộng thật)',
                style: TextStyle(
                  fontSize: 12,
                  color: simulateWidth ? theme.colorScheme.primary : theme.colorScheme.outline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Slider điều chỉnh chiều rộng mô phỏng (280 - 900)
          Slider(
            key: const Key('width_slider'),
            value: simWidth.clamp(280.0, 900.0),
            min: 280,
            max: 900,
            divisions: 62,
            label: '${simWidth.round()} px',
            onChanged: simulateWidth ? onSimWidthChanged : null,
          ),

          // [Wrap] Tự động xuống dòng 3 ActionChip mốc nhanh tránh tràn layout ở màn hình hẹp (320px)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ActionChip(
                label: const Text('360 (điện thoại)'),
                avatar: const Icon(Icons.phone_android, size: 16),
                onPressed: () {
                  onSimulateWidthChanged(true);
                  onSimWidthChanged(360.0);
                },
              ),
              ActionChip(
                label: const Text('600 (ngưỡng)'),
                avatar: const Icon(Icons.view_column, size: 16),
                onPressed: () {
                  onSimulateWidthChanged(true);
                  onSimWidthChanged(600.0);
                },
              ),
              ActionChip(
                label: const Text('800 (máy tính bảng)'),
                avatar: const Icon(Icons.tablet_android, size: 16),
                onPressed: () {
                  onSimulateWidthChanged(true);
                  onSimWidthChanged(800.0);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // [Wrap] Điều khiển tỷ lệ chữ (font scale 0.8 - 2.0)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Cỡ chữ (Font scale):',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '×${fontScale.toStringAsFixed(1)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          Slider(
            key: const Key('font_slider'),
            value: fontScale.clamp(0.8, 2.0),
            min: 0.8,
            max: 2.0,
            divisions: 12,
            label: '×${fontScale.toStringAsFixed(1)}',
            onChanged: onFontScaleChanged,
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // [Wrap] Điều khiển chuỗi văn bản dài để kiểm thử overflow
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Tên dài (thêm hậu tố văn bản):',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Switch(
                key: const Key('long_switch'),
                value: longText,
                onChanged: onLongTextChanged,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // [Wrap] Tự động xuống dòng các nút thao tác môn học và đặt lại tránh tràn layout (320px)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.tonalIcon(
                key: const Key('add_btn'),
                onPressed: onAddCourse,
                icon: const Icon(Icons.add, size: 16),
                label: Text('Thêm môn ($courseCount/12)'),
              ),
              OutlinedButton.icon(
                key: const Key('remove_btn'),
                onPressed: onRemoveCourse,
                icon: const Icon(Icons.remove, size: 16),
                label: const Text('Xóa môn'),
              ),
              TextButton.icon(
                key: const Key('reset_btn'),
                onPressed: onReset,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Đặt lại'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
