import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onCartPressed;
  final Future<int> Function()? getCartCount;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.onNotificationPressed,
    this.onSearchPressed,
    this.onCartPressed,
    this.getCartCount,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  int cartCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAppbar();
  }

  Widget _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Text(
        widget.title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
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
          icon: Icon(
            Icons.notifications_none_rounded,
            color: Colors.black87,
            size: 24,
          ),
          onPressed: widget.onNotificationPressed ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No new notifications')),
                );
              },
        ),
        Stack(
          children: [
            if (cartCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$cartCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 8),
      ],
    );
  }
}
