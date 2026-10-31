import 'package:flutter/material.dart';
import '../../../models/study_models.dart';

class DeadlineList extends StatelessWidget {
  final List<Deadline> deadlines;

  const DeadlineList({
    super.key,
    required this.deadlines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề danh sách hạn chót bọc Expanded tránh tràn hàng ngang
          Row(
            children: [
              Icon(Icons.assignment_outlined, color: theme.colorScheme.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Nhiệm vụ & Hạn chót',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${deadlines.length} mục',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          for (int i = 0; i < deadlines.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _buildDeadlineItem(context, deadlines[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(BuildContext context, Deadline deadline) {
    final theme = Theme.of(context);
    final isUrgent = deadline.daysLeft <= 3;

    // [Row + Expanded + Flexible] Tiêu đề chiếm flex 2, Chip bọc Flexible (flex 1) + FittedBox để tự co tỷ lệ khi chữ phóng to cực đại (font scale 2.0)
    return Row(
      children: [
        // Tiêu đề bọc Expanded với ellipsis tránh tràn hàng
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deadline.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                deadline.courseName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // [Flexible + FittedBox] Chip hiển thị số ngày bọc trong Flexible và FittedBox để co nhỏ vừa vặn không gian
        Flexible(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Chip(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide.none,
              backgroundColor: isUrgent
                  ? theme.colorScheme.errorContainer
                  : theme.colorScheme.secondaryContainer,
              label: Text(
                'Còn ${deadline.daysLeft} ngày',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isUrgent
                      ? theme.colorScheme.onErrorContainer
                      : theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
