import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/notification/notification.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  // Định nghĩa màu chính - tương tự bTaskee
  static final Color primaryColor = const Color(0xFF1CAF7D);

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: Colors.red.shade400,
        child: Icon(Icons.delete_outline, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.green.shade50,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1.0,
            ),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(right: 12, top: 2),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? Colors.grey.shade100
                        : primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: notification.isRead ? Colors.grey.shade600 : primaryColor,
                    size: 22,
                  ),
                ),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(notification.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Unread indicator
                if (!notification.isRead)
                  Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.only(top: 5, left: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}