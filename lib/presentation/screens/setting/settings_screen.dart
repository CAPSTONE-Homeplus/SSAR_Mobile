import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/blocs/theme/theme_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = false;
  bool _isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
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
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xFF1CAF7D),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '+84 123 456 789',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Account Settings
            _buildSectionHeader('Account Settings'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    subtitle: 'Change your personal information',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: 'Manage your saved locations',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Add or remove payment options',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // App Settings
            _buildSectionHeader('App Settings'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage your notifications',
                    showToggle: true,
                    value: _isNotificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isNotificationsEnabled = value;
                      });
                    },
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'English',
                    showArrow: true,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Change app appearance',
                    showToggle: true,
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      context.read<ThemeBloc>().add(ToggleTheme());
                    },
                    onTap: () {
                      context.read<ThemeBloc>().add(ToggleTheme());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Security
            _buildSectionHeader('Security'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.fingerprint,
                    title: 'Biometric Authentication',
                    subtitle: 'Enable fingerprint login',
                    showToggle: true,
                    value: _isBiometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isBiometricEnabled = value;
                      });
                    },
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Support & About
            _buildSectionHeader('Support & About'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    subtitle: 'Read our terms of service',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: 'About',
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Log Out',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
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
    required VoidCallback onTap,
    ValueChanged<bool>? onChanged,
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
            else if (showArrow)
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
