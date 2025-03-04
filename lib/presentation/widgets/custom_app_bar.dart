import 'package:flutter/material.dart';
import 'package:home_clean/core/constant/colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onCartPressed;
  final VoidCallback? onHelpPressed;
  final Future<int> Function()? getCartCount;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.onNotificationPressed,
    this.onSearchPressed,
    this.onCartPressed,
    this.onHelpPressed,
    this.getCartCount,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  int cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0.5,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      leading: widget.onBackPressed != null
          ? IconButton(
        icon: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
        ),
        onPressed:
        widget.onBackPressed ?? () => Navigator.of(context).pop(),
      )
          : null,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: widget.onNotificationPressed ??
                  () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No new notifications')),
                );
              },
        ),
        if (widget.onHelpPressed != null)
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: Colors.white,
              size: 24,
            ),
            onPressed: widget.onHelpPressed,
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
