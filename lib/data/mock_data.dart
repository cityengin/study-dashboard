import '../models/study_models.dart';

// Dữ liệu giả định danh sách môn học (Ngành Kỹ thuật máy tính)
const List<Course> mockCourses = [
  Course(
    name: 'Kiến trúc máy tính và hợp ngữ',
    credits: 3,
    progress: 0.75,
    score: 8.5,
  ),
  Course(
    name: 'Thiết kế hệ thống nhúng và IoT nâng cao',
    credits: 4,
    progress: 0.60,
    score: 7.8,
  ),
  // Môn có tên rất dài để kiểm thử bố cục xử lý tràn không gian
  Course(
    name: 'Phân tích và thiết kế hệ thống thông tin quản lý doanh nghiệp',
    credits: 4,
    progress: 0.40,
    score: 8.0,
  ),
  // Môn có tên rất dài thứ hai
  Course(
    name: 'Hệ điều hành và lập trình hệ thống phân tán thời gian thực',
    credits: 3,
    progress: 0.85,
    score: 9.0,
  ),
  Course(
    name: 'Xử lý tín hiệu số và ứng dụng',
    credits: 3,
    progress: 0.50,
    score: 7.5,
  ),
  Course(
    name: 'Lập trình thiết bị di động đa nền tảng',
    credits: 3,
    progress: 0.90,
    score: 9.2,
  ),
];

// Dữ liệu giả định danh sách hạn chót nhiệm vụ học tập
const List<Deadline> mockDeadlines = [
  // Mục có tiêu đề rất dài để kiểm thử độ co giãn text
  Deadline(
    title: 'Nộp báo cáo bài tập lớn phân tích thiết kế vi xử lý 32-bit trên kit FPGA',
    courseName: 'Kiến trúc máy tính và hợp ngữ',
    daysLeft: 2,
  ),
  Deadline(
    title: 'Kiểm tra giữa kỳ phần mềm nhúng RTOS',
    courseName: 'Thiết kế hệ thống nhúng và IoT nâng cao',
    daysLeft: 5,
  ),
  Deadline(
    title: 'Nộp mã nguồn đồ án cơ sở dữ liệu',
    courseName: 'Phân tích và thiết kế hệ thống thông tin quản lý doanh nghiệp',
    daysLeft: 7,
  ),
  Deadline(
    title: 'Bài tập lập trình đồng bộ IPC',
    courseName: 'Hệ điều hành và lập trình hệ thống phân tán thời gian thực',
    daysLeft: 10,
  ),
  Deadline(
    title: 'Thực hành đo đáp ứng xung bộ lọc FIR',
    courseName: 'Xử lý tín hiệu số và ứng dụng',
    daysLeft: 14,
  ),
];
