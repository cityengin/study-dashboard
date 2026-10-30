import 'package:flutter/material.dart';

class PreviewFrame extends StatelessWidget {
  final bool simulate;
  final double width;
  final double fontScale;
  final Widget child;

  const PreviewFrame({
    super.key,
    required this.simulate,
    required this.width,
    required this.fontScale,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // [MediaQuery + textScaler] Bọc khung xem trước bằng MediaQuery để mô phỏng tỷ lệ fontScale mà không ảnh hưởng bảng điều khiển
    final scaledChild = MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(fontScale),
      ),
      child: child,
    );

    // Khi không bật mô phỏng chiều rộng, child chiếm toàn bộ chiều rộng thực tế
    if (!simulate) {
      return scaledChild;
    }

    // [LayoutBuilder] Nhận biết chiều rộng khả dụng của khung nhìn để quyết định căn giữa hay cho phép cuộn ngang
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final availableWidth = constraints.maxWidth;
        final theme = Theme.of(context);

        // Khung mô phỏng có viền mỏng và nền nhận diện
        final Widget framedChild = Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: scaledChild,
        );

        if (width <= availableWidth) {
          // [Center + SizedBox] Căn giữa khung mô phỏng kích thước cố định khi bề rộng nhỏ hơn hoặc bằng màn hình
          return Container(
            color: theme.colorScheme.surfaceContainerLowest,
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            child: SizedBox(
              width: width,
              height: constraints.maxHeight,
              child: framedChild,
            ),
          );
        } else {
          // [SingleChildScrollView ngang] Cho phép cuộn ngang khi mô phỏng chiều rộng lớn hơn màn hình thực tế (như xem 2 cột trên điện thoại)
          return Container(
            color: theme.colorScheme.surfaceContainerLowest,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: width,
                height: constraints.maxHeight,
                child: framedChild,
              ),
            ),
          );
        }
      },
    );
  }
}
