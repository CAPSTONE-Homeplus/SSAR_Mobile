import 'package:flutter/material.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/widgets/sparklePaint.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final int unreadCount;
  final Color? backgroundColor;
  final bool isHomePage;
  final String? roomAddress;
  final bool? isVerified;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.onBackPressed,
    this.unreadCount = 0,
    this.backgroundColor,
    this.isHomePage = false,
    this.roomAddress,
    this.isVerified = false,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => isHomePage
      ? const Size.fromHeight(72.0)
      : const Size.fromHeight(56.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  // Use a single key for both AppBar variants
  final GlobalKey _notificationButtonKey = GlobalKey();

  void _showNotificationDialog(BuildContext context) {
    // Make sure the key is attached to a rendered object
    final RenderBox? renderBox =
    _notificationButtonKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      debugPrint("Notification button render box is null");
      return;
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + size.width,
        position.dy,
      ),
      items: [
        PopupMenuItem(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Thông báo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                if (widget.unreadCount > 0)
                  ..._buildNotificationItems()
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Text('Không có thông báo mới')),
                  ),

              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  List<Widget> _buildNotificationItems() {
    return List.generate(
      widget.unreadCount,
          (index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.only(right: 8),
                ),
                Expanded(
                  child: Text(
                    'Thông báo ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          if (index < widget.unreadCount - 1) const Divider(height: 4),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final background = widget.backgroundColor ?? AppColors.primaryColor;

    if (widget.isHomePage) {
      return _buildHomePageAppBar(background, context);
    } else {
      return _buildRegularAppBar(background, context);
    }
  }

  AppBar _buildRegularAppBar(Color background, BuildContext context) {
    return AppBar(
      backgroundColor: background,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      title: Text(
        widget.title ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      leading: widget.onBackPressed != null
          ? IconButton(
        icon: Container(
          width: 36,
          height: 36,
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
        onPressed: widget.onBackPressed ?? () => Navigator.of(context).pop(),
      )
          : null,
      // actions: [
      //   _buildNotificationButton(context),
      //   const SizedBox(width: 8),
      // ],
    );
  }

  AppBar _buildHomePageAppBar(Color background, BuildContext context) {
    return AppBar(
      backgroundColor: background,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: _buildRoomHeader(widget.roomAddress ?? ''),
      centerTitle: false,
      actions: [
        if (widget.isVerified == true)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Tooltip(
              message: 'Đã xác thực',
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade300,
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade200,
                      Colors.amber.shade300,
                      Colors.amber.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Đã xác thực',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (widget.isVerified == false)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Tooltip(
              message: 'Chưa xác thực',
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade600,
                      Colors.grey.shade700,
                      Colors.grey.shade800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Chưa xác thực',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildRoomHeader(String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Phòng bạn đang ở',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}