import 'package:flutter/material.dart';
import 'package:home_clean/presentation/screens/register/screens/account_info_screen.dart';
import 'package:home_clean/presentation/screens/register/screens/building_info_screen.dart';
import 'package:home_clean/presentation/screens/register/screens/personal_info_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
  String _username = '';
  String _citizenCode = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return PersonalInfoScreen(
          initialFullName: _fullName,
          initialPhoneNumber: _phoneNumber,
          initialEmail: _email,
          initialCitizenCode: _citizenCode,
          onNext: (fullName, phoneNumber, email, citizenCode) {
            setState(() {
              _fullName = fullName;
              _phoneNumber = phoneNumber;
              _email = email;
              _citizenCode = citizenCode;
              _currentStep = 1;
            });
          },
        );
      case 1:
        return BuildingInfoScreen(
          initialBuildingCode: _buildingCode,
          initialHouseCode: _houseCode,
          fullName: _fullName,
          phoneNumber: _phoneNumber,
          email: _email,
          citizenCode: _citizenCode,
          onNext:
              (fullName, phoneNumber, email, citizen, buildingCode, houseCode) {
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
          username: _username,
          fullName: _fullName,
          phoneNumber: _phoneNumber,
          email: _email,
          buildingCode: _buildingCode,
          houseCode: _houseCode,
          citizenCode: _citizenCode,
          onRegister: (fullName, phoneNumber, email, buildingCode, houseCode,
              username, password, citizenCode) {
            setState(() {
              _username = username;
              _password = password;
            });

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
