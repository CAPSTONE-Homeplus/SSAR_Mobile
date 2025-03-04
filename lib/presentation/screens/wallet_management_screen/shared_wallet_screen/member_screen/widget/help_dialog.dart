import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/constant/colors.dart';


class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Trợ giúp về Thành viên',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            HelpItem(
              icon: Icons.admin_panel_settings,
              title: 'Admin (Chủ sở hữu)',
              description: 'Có quyền quản lý tất cả thành viên, mời thêm người và xóa thành viên.',
            ),
            SizedBox(height: 16),
            HelpItem(
              icon: Icons.people,
              title: 'Thành viên',
              description: 'Có thể xem và thực hiện các giao dịch nhưng không thể quản lý thành viên khác.',
            ),
            SizedBox(height: 16),
            HelpItem(
              icon: Icons.pending_actions,
              title: 'Lời mời đang chờ',
              description: 'Những người đã được mời nhưng chưa tham gia vào ví chung.',
            ),
            SizedBox(height: 16),
            HelpItem(
              icon: Icons.circle,
              title: 'Trạng thái trực tuyến',
              description: 'Chấm xanh cho biết thành viên đang online và có thể nhận thông báo ngay lập tức.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Đã hiểu',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class HelpItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const HelpItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

