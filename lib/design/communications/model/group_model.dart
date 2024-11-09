class GroupUserModel {
  final String id;
  final String name;
  final String email;
  final int createdAt;
  final bool host;

  GroupUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.host,
  });

  // Factory constructor with `id` as a separate parameter
  factory GroupUserModel.fromMap(String id, Map<String, dynamic> data) {
    return GroupUserModel(
      id: id,
      name: data['name'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      createdAt: data['created_at'] ?? 0,
      host: data['host'] ?? false,
    );
  }

  // Convert the UserModel to a Map for Firestore or other uses
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt,
      'host': host,
    };
  }
}
