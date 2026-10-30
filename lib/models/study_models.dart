// Model dữ liệu cho ứng dụng Study Dashboard

class Course {
  final String name;
  final int credits;
  final double progress; // Tiến độ học tập từ 0.0 đến 1.0
  final double score; // Điểm học phần

  const Course({
    required this.name,
    required this.credits,
    required this.progress,
    required this.score,
  });
}

class Deadline {
  final String title;
  final String courseName;
  final int daysLeft; // Số ngày còn lại

  const Deadline({
    required this.title,
    required this.courseName,
    required this.daysLeft,
  });
}
