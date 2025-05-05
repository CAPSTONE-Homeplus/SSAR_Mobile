import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../domain/entities/notification/notification.dart';
import '../../../domain/use_cases/notification/connect_to_notification_hub_use_case.dart';
import '../../../domain/use_cases/notification/disconnect_from_notification_hub_use_case.dart';
import '../../../domain/use_cases/notification/get_notifications_use_case.dart';
import '../../../domain/use_cases/notification/listen_for_notifications_use_case.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final ConnectToNotificationHubUseCase connectToHubUseCase;
  final DisconnectFromNotificationHubUseCase disconnectFromHubUseCase;
  final ListenForNotificationsUseCase listenForNotificationsUseCase;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  StreamSubscription? _notificationSubscription;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.connectToHubUseCase,
    required this.disconnectFromHubUseCase,
    required this.listenForNotificationsUseCase,
    required this.flutterLocalNotificationsPlugin,
  }) : super(NotificationInitial()) {
    // on<LoadNotificationsEvent>(_onLoadNotifications);
    // on<RefreshNotificationsEvent>(_onRefreshNotifications);
    // on<NewNotificationReceivedEvent>(_onNewNotificationReceived);
    // on<ConnectToHubEvent>(_onConnectToHub);
    // on<DisconnectFromHubEvent>(_onDisconnectFromHub);
    //
    // // Khởi tạo các thông số cho notifications plugin
    // _initNotifications();
  }
  //
  // Future<void> _initNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const InitializationSettings initializationSettings =
  //   InitializationSettings(android: initializationSettingsAndroid);
  //
  //   // Thêm callback để xử lý khi người dùng nhấn vào thông báo
  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (NotificationResponse details) {
  //       // Khi người dùng nhấn vào thông báo, load lại danh sách
  //       add(RefreshNotificationsEvent());
  //     },
  //   );
  // }
  // Future<void> _onLoadNotifications(
  //     LoadNotificationsEvent event,
  //     Emitter<NotificationState> emit,
  //     ) async {
  //   emit(NotificationLoading());
  //   try {
  //     final notifications = await getNotificationsUseCase();
  //
  //     emit(NotificationLoaded(notifications));
  //   } catch (e) {
  //     emit(NotificationError(e.toString()));
  //   }
  // }
  //
  // Future<void> _onRefreshNotifications(
  //     RefreshNotificationsEvent event,
  //     Emitter<NotificationState> emit,
  //     ) async {
  //   try {
  //     final notifications = await getNotificationsUseCase();
  //     emit(NotificationLoaded(notifications));
  //   } catch (e) {
  //     emit(NotificationError(e.toString()));
  //   }
  // }
  //
  // Future<void> _onNewNotificationReceived(
  //     NewNotificationReceivedEvent event,
  //     Emitter<NotificationState> emit,
  //     ) async {
  //   // Hiển thị thông báo push
  //   await _showNotification(
  //     title: event.notification.title,
  //     message: event.notification.message,
  //   );
  //
  //   // Cập nhật trạng thái hiện tại nếu đang ở trạng thái loaded
  //   if (state is NotificationLoaded) {
  //     final currentNotifications = (state as NotificationLoaded).notifications;
  //     final updatedNotifications = [event.notification, ...currentNotifications];
  //     emit(NotificationLoaded(updatedNotifications));
  //   } else {
  //     // Nếu không ở trạng thái loaded, load lại toàn bộ
  //     add(RefreshNotificationsEvent());
  //   }
  // }
  // Future<void> _onConnectToHub(
  //     ConnectToHubEvent event,
  //     Emitter<NotificationState> emit,
  //     ) async {
  //   try {
  //     await connectToHubUseCase();
  //
  //     // Lắng nghe các thông báo mới
  //     _notificationSubscription?.cancel();
  //     _notificationSubscription = listenForNotificationsUseCase().listen(
  //           (notification) {
  //         add(NewNotificationReceivedEvent(notification));
  //       },
  //     );
  //   } catch (e) {
  //     emit(NotificationError(e.toString()));
  //   }
  // }
  //
  // Future<void> _onDisconnectFromHub(
  //     DisconnectFromHubEvent event,
  //     Emitter<NotificationState> emit,
  //     ) async {
  //   try {
  //     _notificationSubscription?.cancel();
  //     await disconnectFromHubUseCase();
  //   } catch (e) {
  //     emit(NotificationError(e.toString()));
  //   }
  // }
  //
  // Future<void> _showNotification({
  //   required String title,
  //   required String message,
  // }) async {
  //   AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
  //     'channel_id',
  //     'Thông báo',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     icon: '@mipmap/ic_launcher',
  //     autoCancel: true,
  //   );
  //   NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
  //   await flutterLocalNotificationsPlugin.show(
  //     DateTime.now().millisecondsSinceEpoch % 10000,
  //     title,
  //     message,
  //     platformDetails,
  //   );
  // }
  //
  // @override
  // Future<void> close() {
  //   _notificationSubscription?.cancel();
  //   return super.close();
  // }
}