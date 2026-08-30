import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationsProvider = FutureProvider.autoDispose<NotificationListResponse>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getNotifications();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifsAsync = ref.watch(notificationsProvider);
  return notifsAsync.value?.unreadCount ?? 0;
});
