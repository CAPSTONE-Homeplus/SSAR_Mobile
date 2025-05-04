import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/size_config.dart';
import 'package:home_clean/data/datasource/local/local_data_source.dart';
import 'package:home_clean/domain/entities/user/create_user.dart';
import 'package:home_clean/globals.dart';
import 'package:home_clean/presentation/blocs/theme/theme_bloc.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/dependencies_injection/service_locator.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/use_cases/local/cear_all_data_use_case.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User currentUser = User(id: '', fullName: '', phoneNumber: '');

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(GetUserFromLocal());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthenticationLoading) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Cài đặt'),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authState is AuthenticationFromLocal) {
          context.read<UserBloc>().add(GetUserEvent(authState.user.id ?? ''));
          return BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState is UserLoading) {
                return Scaffold(
                  appBar: CustomAppBar(title: 'Cài đặt'),
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (userState is GetUserSuccess) {
                final user = userState.user;
                return Scaffold(
                  appBar: CustomAppBar(title: 'Cài đặt'),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Color(0xFF1CAF7D).withOpacity(0.1),
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Color(0xFF1CAF7D),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                user.fullName ?? 'Người dùng',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${user.phoneNumber}',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildSectionHeader('Cài đặt tài khoản'),
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              _buildSettingItem(
                                icon: Icons.person_outline,
                                title: 'Thông tin cá nhân',
                                subtitle: 'Cập nhật thông tin cá nhân',
                                onTap: () {
                                  AppRouter.navigateToUpdateProfile(CreateUser(
                                    id: user.id,
                                    fullName: user.fullName,
                                    phoneNumber: user.phoneNumber,
                                    email: user.email,
                                    username: user.username,
                                    buildingCode: user.buildingCode,
                                    houseCode: user.houseCode,
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildSectionHeader('Hỗ trợ & Thông tin'),
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              _buildSettingItem(
                                icon: Icons.privacy_tip_outlined,
                                title: 'Chính sách quyền riêng tư',
                                subtitle: 'Chính sách bảo mật của chúng tôi',
                                onTap: () {
                                  AppRouter.navigateToPolicy();
                                },
                              ),
                              _buildDivider(),
                              _buildSettingItem(
                                icon: Icons.info_outline,
                                title: 'Phiên bản',
                                subtitle: 'Version 1.0.0',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Logout Button
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: ElevatedButton(
                            onPressed: () {
                              sl<ClearAllDataUseCase>().call();
                              AppRouter.navigateToLogin();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Đăng xuất',
                                style: TextStyle(fontSize: 16 * SizeConfig.ffem)),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              }

              // Trường hợp UserError hoặc trạng thái khác
              return Scaffold(
                appBar: CustomAppBar(title: 'Cài đặt'),
                body: Center(child: Text('Không thể tải thông tin người dùng')),
              );
            },
          );
        }

        // Trường hợp không có thông tin authentication
        return Scaffold(
          appBar: CustomAppBar(title: 'Cài đặt'),
          body: Center(child: Text('Vui lòng đăng nhập')),
        );
      },
    );
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showArrow = false,
    bool showToggle = false,
    bool value = false,
    Function(bool)? onChanged,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF1CAF7D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Color(0xFF1CAF7D)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (showToggle)
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Color(0xFF1CAF7D),
              )
            else
              if (showArrow)
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 16,
      endIndent: 16,
    );
  }
}
