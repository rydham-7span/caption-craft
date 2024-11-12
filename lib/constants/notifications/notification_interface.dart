import 'dart:async';

import 'package:caption_craft/constants/notifications/user_model.dart';

import 'notification_observer_event.dart';

abstract interface class NotificationServiceInterface {
  late final StreamController<NotificationObserverEvent> notificationObserverStream;

  Stream<NotificationObserverEvent> get listenForNotifications;

  Future<void> init(String? appId);

  Future<void> setData(NotificationUserModel model);

  Future<String> getNotificationSubscriptionId();

  Future<bool> requestNotificationPermission();

  void listenForNotification();

  void dispose();
}
