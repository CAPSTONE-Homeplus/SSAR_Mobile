import 'dart:convert';

class InviteWalletMapper {
  static Map<String, dynamic>? normalizeInviteWalletData(Object? arguments) {
    if (arguments == null) return null;

    try {
      if (arguments is List && arguments.isNotEmpty) {
        arguments = arguments.first;
      }

      Map<String, dynamic> notificationData;

      if (arguments is String) {
        notificationData = json.decode(arguments);
      } else {
        print('⚠️ Định dạng thông báo InviteWallet không hợp lệ');
        return null;
      }

      String? type = notificationData['Type'] as String?;
      dynamic data = notificationData['Data'];

      if (type == null || data == null) {
        print('⚠️ Thiếu thông tin Type hoặc Data trong InviteWallet');
        return null;
      }

      if (type != 'InviteWallet') {
        return null;
      }

      Map<String, dynamic> normalizedData = {};

      if (data is Map<String, dynamic>) {
        normalizedData = {
          'walletId': data['WalletId']?.toString(),
          'ownerId': data['OwnerId']?.toString(),
          'memberId': data['MemberId']?.toString(),
        };
      } else {
        print('⚠️ Dữ liệu của InviteWallet không hợp lệ');
        return null;
      }

      return normalizedData;
    } catch (e) {
      print('❌ Lỗi khi chuẩn hóa dữ liệu InviteWallet: $e');
      return null;
    }
  }
}
