class MessageModel {
  final String id;
  final String name;
  final String message;
  final String createdAt;
  final bool seen;
  final bool isGroup;

  MessageModel({
    required this.id,
    required this.name,
    required this.message,
    required this.createdAt,
    required this.seen,
    required this.isGroup,
  });

  // Factory constructor with `id` as a separate parameter
  factory MessageModel.fromMap(String id, Map<String, dynamic> data) {
    return MessageModel(
      id: id,
      name: data['name'] ?? 'No Name',
      message: data['message'] ?? 'No Message',
      createdAt: data['created_at'] ?? "0",  // Consider using DateTime or a more consistent format
      seen: data['seen'] ?? false,
      isGroup: data['is_group'] ?? false,
    );
  }

  // Convert the MessageModel to a Map for Firestore or other uses
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'message': message,  // Fixed key mismatch
      'created_at': createdAt,
      'seen': seen,
      'is_group': isGroup
    };
  }
}
