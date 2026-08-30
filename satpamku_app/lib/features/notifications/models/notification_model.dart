class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic> payload;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.payload,
    this.readAt,
    required this.createdAt,
  });

  bool get isRead => readAt != null;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      type: json['type'] as String? ?? 'general',
      title: json['title'] as String? ?? 'Pemberitahuan',
      message: json['message'] as String? ?? '',
      payload: json['payload'] != null ? Map<String, dynamic>.from(json['payload'] as Map) : {},
      readAt: json['read_at'] != null ? DateTime.tryParse(json['read_at']) : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class NotificationListResponse {
  final int unreadCount;
  final List<NotificationModel> items;

  NotificationListResponse({
    required this.unreadCount,
    required this.items,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List?)
            ?.map((i) => NotificationModel.fromJson(Map<String, dynamic>.from(i as Map)))
            .toList() ??
        [];

    return NotificationListResponse(
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      items: list,
    );
  }
}
