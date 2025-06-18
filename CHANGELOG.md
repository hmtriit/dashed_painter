# Changelog

Tất cả các thay đổi đáng chú ý cho package `flutter_dash_painter` sẽ được ghi lại tại đây.

---

## [1.0.0] - 2025-06-17

🎉 **Phiên bản đầu tiên phát hành**

- Hỗ trợ vẽ đường nét đứt (dash line) cho mọi `Path`
- Hỗ trợ `CustomPainter` để vẽ:
  - Đường thẳng (ngang, dọc)
  - Hình tròn (`addOval`)
  - Hình chữ nhật bo góc (`addRRect`)
- Hỗ trợ cấu hình:
  - `step`: độ dài mỗi nét vẽ
  - `span`: khoảng trắng giữa các nét
  - `pointCount`: số lượng chấm nhỏ
  - `pointWidth`: chiều dài mỗi chấm
- Thêm `DashDecoration` để sử dụng trong `Container` dễ dàng

---

## [1.0.1] - 2025-06-17

- Fix minor export issues
- Add documentation and public API exports

## [1.0.2] - 2025-06-18

- Fix minor export issues
- Add documentation and formatting
- Add Testting
