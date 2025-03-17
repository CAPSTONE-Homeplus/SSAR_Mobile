import 'package:flutter/material.dart';
import 'package:home_clean/presentation/screens/register/screens/account_info_screen.dart';
import 'package:home_clean/presentation/screens/register/screens/building_info_screen.dart';
import 'package:home_clean/presentation/screens/register/screens/personal_info_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  String _fullName = '';
  String _phoneNumber = '';
  String _email = '';
  String _buildingCode = '';
  String _houseCode = '';

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return PersonalInfoScreen(
          onNext: (fullName, phoneNumber, email) {
            setState(() {
              _fullName = fullName;
              _phoneNumber = phoneNumber;
              _email = email;
              _currentStep = 1;
            });
          },
        );
      case 1:
        return BuildingInfoScreen(
          fullName: _fullName,
          phoneNumber: _phoneNumber,
          email: _email,
          onNext: (fullName, phoneNumber, email, buildingCode, houseCode) {
            setState(() {
              _buildingCode = buildingCode;
              _houseCode = houseCode;
              _currentStep = 2;
            });
          },
          onBack: () {
            setState(() {
              _currentStep = 0;
            });
          },
        );
      case 2:
        return AccountInfoScreen(
          fullName: _fullName,
          phoneNumber: _phoneNumber,
          email: _email,
          buildingCode: _buildingCode,
          houseCode: _houseCode,
          onRegister: (fullName, phoneNumber, email, buildingCode, houseCode, username, password) {
            // Xử lý đăng ký
            print('Đăng ký với thông tin:');
            print('- Họ tên: $fullName');
            print('- SĐT: $phoneNumber');
            print('- Email: $email');
            print('- Mã tòa nhà: $buildingCode');
            print('- Mã căn hộ: $houseCode');
            print('- Tên đăng nhập: $username');
            print('- Mật khẩu: $password');
          },
          onBack: () {
            setState(() {
              _currentStep = 1;
            });
          },
        );
      default:
        return Container();
    }
  }
}