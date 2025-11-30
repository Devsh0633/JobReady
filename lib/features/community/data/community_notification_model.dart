class CommunityNotification {
  final String id;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const CommunityNotification({
    required this.id,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  CommunityNotification copyWith({
    String? id,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return CommunityNotification(
      id: id ?? this.id,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
