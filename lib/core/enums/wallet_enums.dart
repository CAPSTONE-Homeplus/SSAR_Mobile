enum WalletType {
  personal,
  shared,
}

extension WalletTypeExtension on WalletType {
  String get displayName {
    switch (this) {
      case WalletType.personal:
        return "Ví riêng";
      case WalletType.shared:
        return "Ví chung";
    }
  }

  static WalletType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'Personal':
        return WalletType.personal;
      case 'Shared':
        return WalletType.shared;
      default:
        throw Exception("Loại ví không hợp lệ: $type");
    }
  }
}