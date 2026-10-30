# Study Dashboard — Ứng dụng Quản lý Học tập Đa nền tảng

Study Dashboard là ứng dụng di động được xây dựng bằng Flutter nhằm hỗ trợ sinh viên theo dõi tiến độ học tập, điểm số và hạn chót nhiệm vụ một cách trực quan, tối ưu cho thiết bị Android. Dự án được thực hiện trong khuôn khổ môn học Lập trình đa nền tảng với chủ đề **"Tổ chức bố cục linh hoạt và xử lý không gian"**, minh chứng trọn vẹn từ cơ sở lý thuyết đến thực hành xây dựng giao diện responsive và xử lý triệt để các lỗi tràn pixel (overflow).

---

## 1. Mục tiêu theo yêu cầu chủ đề

* **Cơ sở lý thuyết vững chắc:**
  * Thấu hiểu sâu sắc quy tắc layout cốt lõi của Flutter: *"Constraints Go Down, Sizes Go Up, Parent Sets Position"*.
  * Làm chủ hệ trục chính và trục phụ (*Main Axis & Cross Axis*) trong các widget flex (`Row`, `Column`).
  * Phân biệt rõ ràng cơ chế áp đặt ràng buộc chặt chẽ (*tight constraint* - `Expanded`) và ràng buộc lỏng lẻo (*loose constraint* - `Flexible`).
  * Nắm vững kỹ thuật xếp chồng lớp z-index và định vị tọa độ tương đối/tuyệt đối qua `Stack` và `Positioned` (bao gồm `clipBehavior`).
  * Nhận diện nguồn gốc bản chất gây lỗi `RenderFlex overflow` và ứng dụng các giải pháp chuẩn mực (`Expanded`, `Flexible`, `FittedBox`, `Wrap`, `SingleChildScrollView`, `TextOverflow.ellipsis`).
* **Thực hành & Trực quan hóa demo:**
  * Xây dựng màn hình Dashboard hoàn chỉnh với dữ liệu sinh viên thực tế, tự động chuyển đổi bố cục 1 cột / 2 cột theo kích thước màn hình mà không phụ thuộc vào `MediaQuery.size`.
  * Xây dựng phòng thí nghiệm **Demo Lab** tương tác trực quan với 4 phân hệ chuyên đề.
  * Tích hợp **Bảng điều khiển demo** tại chỗ cho phép mô phỏng tức thì chiều rộng (280–900 px), phóng đại cỡ chữ (*font scale* 0.8–2.0×), mở rộng chuỗi văn bản cực dài và biến động số lượng môn học để chứng minh độ bền bỉ của bố cục.

---

## 2. Yêu cầu chủ đề → Nơi thể hiện trong mã nguồn

| Yêu cầu chủ đề | File mã nguồn | Widget / Thành phần cụ thể | Vai trò & Cơ chế thể hiện |
| :--- | :--- | :--- | :--- |
| **Main Axis & Cross Axis** | `lib/screens/demo_lab/widgets/axis_playground.dart` | `AxisPlayground` | Tương tác trực tiếp đổi `direction` (Row/Column), `mainAxisAlignment`, `crossAxisAlignment`, `mainAxisSize`. |
| | `lib/screens/dashboard/widgets/dashboard_body.dart` | `DashboardBody` | Row 2 cột với `crossAxisAlignment: CrossAxisAlignment.start` giúp hai cột canh đều đỉnh trên. |
| | `lib/screens/dashboard/widgets/stats_row.dart` | `StatsRow` | Căn chỉnh `mainAxisSize: MainAxisSize.min` và phân bổ đều các thẻ thống kê. |
| **Expanded vs Flexible** | `lib/screens/demo_lab/widgets/flex_playground.dart` | `FlexPlayground` | Thanh trượt flex A/B, so sánh trực quan giữa ép buộc lấp đầy (`FlexFit.tight`) và co giãn tự nhiên (`FlexFit.loose`). |
| | `lib/screens/dashboard/widgets/stats_row.dart` | `StatsRow` | Phân chia không gian 3 thẻ thống kê theo tỷ lệ `flex: 2:1:1` (GPA chiếm ưu tiên gấp đôi). |
| | `lib/screens/dashboard/widgets/deadline_list.dart` | `DeadlineList` | `Expanded(flex: 2)` cho khối tiêu đề và `Flexible(flex: 1)` cho thẻ Chip số ngày còn lại. |
| | `lib/screens/dashboard/widgets/dashboard_body.dart` | `DashboardBody` | Row 2 cột chia tỉ lệ `flex: 3` (Môn học) và `flex: 2` (Hạn chót). |
| | `lib/screens/dashboard/widgets/profile_banner.dart` | `ProfileBanner` | `Expanded` cho tên sinh viên và `Flexible` cho nhãn MSSV. |
| **Stack & Positioned** | `lib/screens/demo_lab/widgets/stack_playground.dart` | `StackPlayground` | Trực quan hóa thứ tự lớp z-index, thay đổi tọa độ `Positioned` và hiệu ứng `clipBehavior: Clip.none` với tọa độ âm. |
| | `lib/screens/dashboard/widgets/profile_banner.dart` | `ProfileBanner` | Nền gradient, Positioned góc trên phải cho badge học kỳ, Positioned tọa độ âm `bottom: -36` đè mép bìa cho Avatar tròn (`clipBehavior: Clip.none`). |
| **Nguyên nhân overflow & Cách xử lý** | `lib/screens/demo_lab/widgets/overflow_gallery.dart` | `OverflowGallery` | Minh họa 4 ca overflow kinh điển (Text dài trong Row, danh sách dài trong Column, nhiều Chip tràn hàng, KPI số lớn) kèm nút chuyển đổi TRƯỚC (lỗi sọc vàng đen) và SAU (xử lý bằng Expanded, SingleChildScrollView, Wrap, FittedBox). |
| | `lib/screens/dashboard/widgets/course_list.dart` | `CourseList` | Tên môn học dùng `maxLines: 1` và `TextOverflow.ellipsis`, thanh tiến độ tự co giãn. |
| | `lib/screens/dashboard/widgets/deadline_list.dart` | `DeadlineList` | Thẻ Chip bọc `Flexible` + `FittedBox(fit: BoxFit.scaleDown)` triệt tiêu hoàn toàn overflow khi chữ phóng đại 2.0×. |
| | `lib/screens/dashboard/widgets/demo_control_panel.dart` | `DemoControlPanel` | Sử dụng `Wrap` cho toàn bộ Switch, ActionChip và nút bấm, không bị tràn ở màn hình hẹp (320 px). |
| **Bố cục nhiều thành phần** | `lib/screens/dashboard/widgets/dashboard_body.dart` | `DashboardBody` | Phối hợp nhịp nhàng Banner, Thẻ thống kê, Danh sách môn học và Hạn chót nhiệm vụ. |
| | `lib/screens/main_screen.dart` | `MainScreen` | Khung ứng dụng 2 tab với `NavigationBar` và `IndexedStack` bảo toàn trạng thái màn hình khi chuyển tab. |
| **Phản ứng khi đổi kích thước / nội dung** | `lib/screens/dashboard/widgets/dashboard_body.dart` | `DashboardBody` | `LayoutBuilder` đọc `constraints.maxWidth >= dashboardWideBreakpoint (600)` để chuyển đổi linh hoạt giữa 1 cột và 2 cột. |
| | `lib/screens/dashboard/widgets/preview_frame.dart` | `PreviewFrame` | Mô phỏng kích thước cố định và tỷ lệ chữ qua `MediaQuery(textScaler: ...)`, cuộn ngang linh hoạt khi mô phỏng chiều rộng lớn hơn màn hình thực tế. |
| | `lib/screens/dashboard/dashboard_screen.dart` | `DashboardScreen` | Quản lý state động: tự động tính lại GPA, tổng tín chỉ, trạng thái cột và cập nhật UI ngay lập tức khi thêm/xóa môn. |

---

## 3. Cấu trúc thư mục dự án

```text
study-dashboard/
├── lib/
│   ├── main.dart                                   # Điểm khởi chạy app, cấu hình ThemeData Material 3
│   ├── models/
│   │   └── study_models.dart                       # Định nghĩa cấu trúc dữ liệu Course và Deadline
│   ├── data/
│   │   └── mock_data.dart                          # Dữ liệu giả lập 6 môn học Kỹ thuật máy tính & 5 hạn chót
│   └── screens/
│       ├── main_screen.dart                        # Khung Scaffold chính 2 tab kèm NavigationBar và IndexedStack
│       ├── dashboard/                              # PHÂN HỆ DASHBOARD & BẢNG ĐIỀU KHIỂN
│       │   ├── dashboard_screen.dart               # Màn hình Dashboard quản lý state tương tác mô phỏng
│       │   └── widgets/
│       │       ├── dashboard_body.dart             # Thân Dashboard responsive 1 cột / 2 cột (LayoutBuilder)
│       │       ├── profile_banner.dart             # Banner sinh viên dùng Stack, Positioned và clipBehavior
│       │       ├── stats_row.dart                  # Hàng thẻ thống kê tỷ lệ 2:1:1 với FittedBox
│       │       ├── course_list.dart                # Danh sách môn học và thanh tiến độ với Row + Expanded
│       │       ├── deadline_list.dart              # Danh sách hạn chót nhiệm vụ với Flexible + FittedBox
│       │       ├── demo_control_panel.dart         # Bảng điều khiển demo (Slider width/font, Thêm/Xóa môn)
│       │       └── preview_frame.dart              # Khung xem trước mô phỏng kích thước và font scale
│       └── demo_lab/                               # PHÂN HỆ PHÒNG THÍ NGHIỆM BỐ CỤC
│           ├── demo_lab_screen.dart                # Màn hình Demo Lab 4 tab (TabBarView cố định vuốt)
│           └── widgets/
│               ├── demo_card.dart                  # Khung thẻ hiển thị tiêu đề và hướng dẫn từng thí nghiệm
│               ├── axis_playground.dart            # Sân chơi tương tác trục chính/phụ (Main & Cross Axis)
│               ├── flex_playground.dart            # Sân chơi tương tác Expanded vs Flexible
│               ├── stack_playground.dart           # Sân chơi tương tác Stack & Positioned
│               └── overflow_gallery.dart           # Thư viện so sánh trực quan 4 ca overflow Trước vs Sau
└── test/
    ├── widget_test.dart                            # Smoke test khởi chạy app và chuyển tab điều hướng
    ├── dashboard_layout_test.dart                  # Kiểm thử bố cục Dashboard ở 320, 411, 800 với font scale 1.3
    ├── demo_lab_test.dart                          # Kiểm thử tương tác toàn bộ 4 tab của Demo Lab
    └── control_panel_test.dart                     # Kiểm thử bảng điều khiển, thao tác môn học và stress test font scale 2.0
```

---

## 4. Hướng dẫn cài đặt và chạy ứng dụng

* **Yêu cầu môi trường:**
  * **Flutter SDK:** Phiên bản `3.47.x` trở lên (kênh `stable`).
  * **Dart SDK constraint:** `^3.13.5` (theo khai báo trong `pubspec.yaml`).
  * **Thiết bị:** Thiết bị thật Android hoặc máy ảo Android Emulator.

* **Các bước thực thi:**
  1. Cài đặt các gói phụ thuộc:
     ```bash
     flutter pub get
     ```
  2. Chạy ứng dụng trên thiết bị Android:
     ```bash
     flutter run -d <id-thiết-bị>
     ```
     > **Lưu ý quan trọng:** Cần chạy ở **chế độ Debug** (`flutter run` mặc định) để Flutter hiển thị các dải sọc vàng đen cảnh báo khi quan sát các case cố tình gây lỗi trong tab *Overflow* của Demo Lab.
  3. Kiểm tra phân tích mã nguồn (Lint & Conventions):
     ```bash
     flutter analyze
     ```
  4. Chạy toàn bộ bộ kiểm thử tự động (22 test cases):
     ```bash
     flutter test
     ```

---

## 5. Kịch bản Demo thuyết trình (~3 phút)

1. **Tổng quan Dashboard ở chế độ dọc mặc định (0:00 – 0:30):**
   * Mở ứng dụng ở màn hình dọc điện thoại tiêu chuẩn (chiều rộng ~411 px).
   * Giới thiệu bố cục 1 cột: Banner sinh viên xếp chồng Avatar nhô mép bìa (`Stack + Positioned`), Hàng 3 thẻ thống kê phân bổ tỷ lệ `2:1:1` (`Expanded`), Danh sách môn học và Hạn chót nhiệm vụ.
2. **Thích ứng khi xoay ngang thiết bị (0:30 – 0:50):**
   * Xoay ngang điện thoại (hoặc chuyển sang máy tính bảng).
   * Giao diện tự động phân nhánh sang **bố cục 2 cột** nhờ `LayoutBuilder` vượt ngưỡng 600 px: Cột trái hiển thị Môn học (`flex: 3`), cột phải hiển thị Hạn chót (`flex: 2`).
3. **Mô phỏng chiều rộng linh hoạt từ Bảng điều khiển (0:50 – 1:20):**
   * Mở *"Bảng điều khiển demo"*.
   * Gạt bật switch *"Mô phỏng chiều rộng"*, kéo thanh trượt qua mốc 600 px hoặc bấm trực tiếp các nút mốc nhanh:
     * Bấm **360 (điện thoại)** → Giao diện thu về 1 cột, căn giữa khung có viền nhận diện.
     * Bấm **800 (máy tính bảng)** → Giao diện mở rộng thành 2 cột; trên màn hình điện thoại hẹp, xuất hiện thanh cuộn ngang mượt mà cho phép xem trọn vẹn bố cục 2 cột.
4. **Kiểm thử chịu tải phóng to chữ (Font Scale) và Text dài (1:20 – 1:50):**
   * Kéo thanh trượt *"Cỡ chữ (Font scale)"* lên mức **×1.5** rồi cực đại **×2.0**.
   * Bật switch *"Tên dài"*: Toàn bộ tên môn và deadline được bổ sung hậu tố học phần dài.
   * Minh chứng: Các thẻ số liệu tự động co tỉ lệ chữ (`FittedBox`), văn bản tự cắt lửng bằng dấu chấm ba chấm (`ellipsis`), thẻ Chip số ngày tự co ép linh hoạt (`Flexible + FittedBox`), hoàn toàn không xuất hiện lỗi sọc vàng đen overflow.
5. **Thêm / Xóa môn học và cập nhật dữ liệu động (1:50 – 2:15):**
   * Bấm nút *"Thêm môn"* nhiều lần lên tối đa 12 môn (nút tự vô hiệu hóa khi đủ 12).
   * Quan sát điểm GPA và Tổng tín chỉ tự động tính toán lại có trọng số tức thì, danh sách cuộn mượt mà.
   * Thử nút *"Xóa môn"* về 1 môn (nút tự vô hiệu hóa để bảo toàn dữ liệu), sau đó bấm *"Đặt lại"* để khôi phục cấu hình ban đầu.
6. **Tham quan Phòng thí nghiệm Demo Lab (2:15 – 3:00):**
   * Chuyển sang tab **Demo Lab** và lướt qua 4 phân hệ chuyên sâu:
     * **Tab 1 (Trục chính/phụ):** Bấm đổi Main/Cross Axis của Row và Column trực quan.
     * **Tab 2 (Expanded vs Flexible):** Kéo slider thay đổi flex factor, quan sát trực tiếp sự khác biệt tight vs loose.
     * **Tab 3 (Stack & Positioned):** Bật/tắt clipBehavior, kéo chỉnh tọa độ và quan sát thứ tự vẽ xếp lớp.
     * **Tab 4 (Overflow Gallery):** Gạt công tắc so sánh 4 trường hợp lỗi overflow thực tế trước và sau khi được giải quyết bằng các kỹ thuật đã học.

---

## 6. Phân công nhiệm vụ nhóm

| Thành viên | Nhiệm vụ đảm trách trong dự án |
| :--- | :--- |
| `<Họ tên – MSSV>` | Phân hệ Dashboard (ProfileBanner, StatsRow, CourseList, DeadlineList, DashboardBody), Bảng điều khiển demo (DemoControlPanel, PreviewFrame), Thiết kế kịch bản kiểm thử bố cục (`dashboard_layout_test.dart`, `control_panel_test.dart`) và tài liệu README. |
| `<Họ tên – MSSV>` | Phân hệ Demo Lab (AxisPlayground, FlexPlayground, StackPlayground, OverflowGallery, DemoCard, DemoLabScreen) và bộ kiểm thử tương tác phòng thí nghiệm (`demo_lab_test.dart`). |

---

## 7. Ghi chú kỹ thuật

* **Thuần Flutter Core:** Toàn bộ dự án chỉ sử dụng các widget sẵn có của Flutter SDK (`StatelessWidget`, `StatefulWidget`), tuyệt đối không cài thêm bất kỳ thư viện bên ngoài hay state management phức tạp (Bloc, Provider, GetX...).
* **Ngưỡng Responsive:** Hằng số công khai `dashboardWideBreakpoint = 600.0` được khai báo tập trung tại `dashboard_body.dart` và tái sử dụng đồng bộ trên toàn ứng dụng.
* **Nền tảng kiểm thử và demo mục tiêu:** Hệ điều hành **Android** (tối ưu hóa hiển thị từ màn hình nhỏ 320 px đến máy tính bảng 800+ px).
