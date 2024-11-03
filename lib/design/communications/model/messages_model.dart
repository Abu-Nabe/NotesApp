class MessageModel {
  final String id;
  final String name;
  final String message;
  final String createdAt;
  final bool seen;

  MessageModel({
    required this.id,
    required this.name,
    required this.message,
    required this.createdAt,
    required this.seen,
  });

  // Factory constructor with `id` as a separate parameter
  factory MessageModel.fromMap(String id, Map<String, dynamic> data) {
    return MessageModel(
      id: id,
      name: data['name'] ?? 'No Name',
      message: data['message'] ?? 'No Message',
      createdAt: data['created_at'] ?? "0",
      seen: data['seen'] ?? false,
    );
  }

  // Convert the UserModel to a Map for Firestore or other uses
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': message,
      'created_at': createdAt,
      'seen': seen,
    };
  }
}
