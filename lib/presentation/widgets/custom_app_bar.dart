import 'package:flutter/material.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final Function(BuildContext context)? onNotificationPressed;
  final int unreadCount;
  final Color? backgroundColor;
  final bool isHomePage;
  final String? roomAddress;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.onBackPressed,
    this.onNotificationPressed,
    this.unreadCount = 0,
    this.backgroundColor,
    this.isHomePage = false,
    this.roomAddress,
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
      actions: [
        _buildNotificationButton(context),
        const SizedBox(width: 8),
      ],
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
        _buildNotificationButton(context),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    // Use a single container with the key to ensure proper rendering
    return Container(
      key: _notificationButtonKey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              if (widget.onNotificationPressed != null) {
                widget.onNotificationPressed!(context);
              } else {
                // Add a small delay to ensure UI is fully rendered
                Future.delayed(Duration.zero, () {
                  _showNotificationDialog(context);
                });
              }
            },
          ),
          if (widget.unreadCount > 0)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  widget.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
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