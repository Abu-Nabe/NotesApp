class NotesModel {
  final String id;
  final String name;
  final String message;
  final int createdAt;

  NotesModel({
    required this.id,
    required this.name,
    required this.message,
    required this.createdAt,
  });

  // Factory constructor with `id` as a separate parameter
  factory NotesModel.fromMap(String id, Map<String, dynamic> data) {
    return NotesModel(
      id: id,
      name: data['name'] ?? 'No Name',
      message: data['message'] ?? 'No Message',
      createdAt: data['created_at'] ?? 0,
    );
  }

  // Convert the UserModel to a Map for Firestore or other uses
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': message,
      'created_at': createdAt,
    };
  }
}
