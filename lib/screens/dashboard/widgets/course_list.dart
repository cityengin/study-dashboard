import 'package:flutter/material.dart';
import '../../../models/study_models.dart';

class CourseList extends StatelessWidget {
  final List<Course> courses;

  const CourseList({
    super.key,
    required this.courses,
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
          // Tiêu đề danh sách môn học bọc Expanded tránh tràn hàng ngang
          Row(
            children: [
              Icon(Icons.auto_stories_outlined, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Môn học & Tiến độ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${courses.length} môn',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          for (int i = 0; i < courses.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _buildCourseItem(context, courses[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildCourseItem(BuildContext context, Course course) {
    final theme = Theme.of(context);

    // [Row + Expanded] Xử lý bố cục thẻ môn học: tên môn dài được co giãn và ellipsis, thanh tiến độ kéo giãn theo không gian còn lại
    return Row(
      children: [
        // Avatar hiển thị số tín chỉ
        CircleAvatar(
          radius: 18,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            '${course.credits}TC',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // [Column trong Expanded] Tên môn xử lý maxLines 1 + ellipsis, thanh tiến độ kéo giãn tự do
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: course.progress,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    course.progress >= 0.8
                        ? Colors.green
                        : course.progress >= 0.5
                            ? theme.colorScheme.primary
                            : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Cột hiển thị điểm học phần
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${course.score.toStringAsFixed(1)} đ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
