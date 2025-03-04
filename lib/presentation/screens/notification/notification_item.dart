import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/notification/notification.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

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
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      child: ListTile(
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: notification.isRead ? Colors.grey : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(notification.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.grey.shade200 : Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications,
            color: notification.isRead ? Colors.grey : Colors.blue,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        trailing: notification.isRead
            ? null
            : Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}