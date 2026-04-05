# Cancer Regression Analysis - Probability and Statistics Project

## Description
Dự án tập trung nghiên cứu và phân tích mối liên hệ giữa các chỉ số kinh tế - xã hội, điều kiện y tế và tỷ lệ tử vong do ung thư tại các khu vực dân cư thuộc Hoa Kỳ. Mục tiêu cốt lõi là ứng dụng các phương pháp thống kê để dự đoán tỷ lệ tử vong (biến mục tiêu `target_deathrate`) dựa trên các biến độc lập như thu nhập trung bình, tỷ lệ hộ nghèo và đặc điểm dân số.

Nội dung nghiên cứu bao gồm:
* Thực hiện thống kê mô tả và trực quan hóa phân phối dữ liệu.
* Kiểm định giả thuyết ANOVA một nhân tố và kiểm định Levene về tính đồng nhất của phương sai giữa các bang.
* Xây dựng và đánh giá mô hình hồi quy tuyến tính bội để xác định các nhân tố ảnh hưởng trọng yếu.

## Dataset
**Nguồn dữ liệu**: Tổng hợp từ Trung tâm Kiểm soát và Phòng ngừa Dịch bệnh (CDC), Cục điều tra dân số Hoa Kỳ và các hệ thống dữ liệu bảo hiểm y tế.
**Quy mô**: Tập dữ liệu bao gồm 3.047 quan sát với 33 biến số định tính và định lượng.
**Đặc điểm**: Dữ liệu phản ánh thực trạng y tế cộng đồng và dịch tễ học tại nhiều khu vực địa lý khác nhau.

## Tech Stack
 **Ngôn ngữ lập trình**: R.
 **Thư viện hỗ trợ**:
    * `dplyr`, `readr`: Quản lý, trích xuất và tiền xử lý dữ liệu.
    * `ggplot2`, `reshape2`: Trực quan hóa biểu đồ phân tán, biểu đồ hộp và heatmap tương quan.
    * `car`: Thực hiện kiểm định Levene.
    * `questionr`: Kiểm tra và xử lý dữ liệu khuyết.

## Result
**Phân tích tương quan**: Xác định mối tương quan thuận giữa số ca tử vong trung bình hàng năm với tổng dân số và số ca mắc mới được chẩn đoán.
**Kiểm chứng thống kê**: Kết quả ANOVA cho thấy sự khác biệt có ý nghĩa thống kê về tỷ lệ mắc bệnh giữa các bang (với giá trị $p < 2e-16$).
**Hiệu quả mô hình**: Mô hình hồi quy tuyến tính bội đạt hệ số xác định hiệu chỉnh $R^2 = 0.9636$, cho thấy khả năng giải thích biến thiên ở mức rất cao.

## Contributors
Dự án được thực hiện bởi Nhóm 11 - Lớp CN02, Trường Đại học Bách Khoa TP.HCM dưới sự hướng dẫn của PGS.TS.Nguyễn Đình Huy.

**Danh sách thành viên:**
* Yeh Tzu (MSSV: 2353305) 
* Lê Trần Như Quỳnh (MSSV: 2353038) 
* Trần Đức Khôi Nguyên (MSSV: 2352837) 
* Nguyễn Ngọc Lan Vy (MSSV: 2353358)
* Đinh Trần Anh Khoa (MSSV: 2352553)
* Nguyễn Lê Minh Nhật (MSSV: 2352860)
