import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Chính Sách Quyền Riêng Tư",
        onBackPressed: () {
          Get.back();
        },
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chính Sách Quyền Riêng Tư - Ứng Dụng Dịch Vụ Chung Cư",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Điều Khoản Dịch Vụ\n\nChào mừng bạn đến với ứng dụng dịch vụ chung cư – nền tảng kết nối khách hàng với các dịch vụ như dọn dẹp nhà, vệ sinh máy lạnh, giặt rèm, diệt côn trùng... được cung cấp bởi các đối tác chuyên nghiệp.",
            ),
            SizedBox(height: 24),
            Text(
              "1. Thông tin cá nhân mà chúng tôi thu thập",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "- Họ và tên\n"
                  "- Số điện thoại\n"
                  "- Địa chỉ email\n"
                  "- Địa chỉ căn hộ/chung cư\n"
                  "- Thông tin thanh toán (nếu có)\n"
                  "- Lịch sử đặt dịch vụ\n"
                  "- Thông tin phản hồi hoặc đánh giá dịch vụ",
            ),
            SizedBox(height: 16),
            Text(
              "2. Mục đích thu thập thông tin",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "- Xác minh tài khoản người dùng\n"
                  "- Cung cấp và vận hành dịch vụ\n"
                  "- Gửi thông báo xác nhận và cập nhật trạng thái đơn hàng\n"
                  "- Cải thiện trải nghiệm người dùng\n"
                  "- Gửi ưu đãi, khuyến mãi phù hợp\n"
                  "- Tuân thủ các quy định pháp luật hiện hành",
            ),
            SizedBox(height: 16),
            Text(
              "3. Chia sẻ thông tin",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Chúng tôi không bán hoặc chia sẻ thông tin cá nhân của bạn trừ khi:\n"
                  "- Với đối tác, nhân viên dịch vụ cần thiết để thực hiện đơn hàng\n"
                  "- Với cơ quan chức năng nếu có yêu cầu theo pháp luật\n"
                  "- Trong trường hợp sáp nhập, chuyển nhượng doanh nghiệp",
            ),
            SizedBox(height: 16),
            Text(
              "4. Bảo vệ thông tin cá nhân",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "- Không chia sẻ tài khoản cho người khác\n"
                  "- Đăng xuất sau khi sử dụng\n"
                  "- Sử dụng mật khẩu mạnh và bảo mật thiết bị của mình",
            ),
            SizedBox(height: 16),
            Text(
              "5. Quyền và nghĩa vụ của người dùng",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Bạn có quyền yêu cầu truy cập, chỉnh sửa, xoá thông tin cá nhân bằng cách liên hệ với chúng tôi qua email support@chungcuservice.vn.",
            ),
            Text(
              "Bạn cũng có trách nhiệm cung cấp thông tin chính xác và tuân thủ điều khoản sử dụng dịch vụ.",
            ),
            SizedBox(height: 16),
            Text(
              "6. Thay đổi chính sách",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Chính sách có thể được cập nhật theo thời gian. Chúng tôi sẽ thông báo khi có thay đổi thông qua ứng dụng hoặc email. Việc tiếp tục sử dụng ứng dụng nghĩa là bạn đồng ý với các thay đổi đó.",
            ),
            SizedBox(height: 16),
            Text(
              "7. Liên hệ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Mọi thắc mắc, khiếu nại xin gửi về:\ndoanhkhoa031103@gmail.com",
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
