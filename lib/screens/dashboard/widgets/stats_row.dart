import 'package:flutter/material.dart';
import '../../../models/study_models.dart';

class StatsRow extends StatelessWidget {
  final List<Course> courses;
  final List<Deadline> deadlines;

  const StatsRow({
    super.key,
    required this.courses,
    required this.deadlines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Tính toán số liệu trực tiếp từ danh sách truyền vào constructor
    int totalCredits = 0;
    double weightedScoreSum = 0;
    for (final course in courses) {
      totalCredits += course.credits;
      weightedScoreSum += course.score * course.credits;
    }
    final double gpa = totalCredits > 0 ? weightedScoreSum / totalCredits : 0.0;
    final int upcomingDeadlines = deadlines.where((d) => d.daysLeft <= 7).length;

    return Row(
      children: [
        // [Row + Expanded] Thẻ GPA chiếm flex 2 (gấp đôi không gian các thẻ còn lại)
        Expanded(
          flex: 2,
          child: _StatCard(
            title: 'GPA trung bình',
            value: '${gpa.toStringAsFixed(2)} / 10',
            icon: Icons.school_outlined,
            cardColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
            contentColor: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 8),

        // [Row + Expanded] Thẻ Tổng tín chỉ chiếm flex 1
        Expanded(
          flex: 1,
          child: _StatCard(
            title: 'Tổng tín chỉ',
            value: '$totalCredits',
            icon: Icons.menu_book_outlined,
            cardColor: theme.colorScheme.secondaryContainer.withValues(alpha: 0.7),
            contentColor: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(width: 8),

        // [Row + Expanded] Thẻ Hạn chót sắp tới chiếm flex 1
        Expanded(
          flex: 1,
          child: _StatCard(
            title: 'Hạn chót ≤7d',
            value: '$upcomingDeadlines',
            icon: Icons.timer_outlined,
            cardColor: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.7),
            contentColor: theme.colorScheme.onTertiaryContainer,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color cardColor;
  final Color contentColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.cardColor,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: contentColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: contentColor),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),

          // [FittedBox] Tự động co tỉ lệ số lớn để không bao giờ bị overflow khi thẻ hẹp
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: contentColor,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Nhãn tiêu đề dùng maxLines và ellipsis để tránh tràn chữ
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: contentColor.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
