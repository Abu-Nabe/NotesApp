class UserModel {
  final String name;
  final String email;
  final int createdAt;

  UserModel({
    required this.name,
    required this.email,
    required this.createdAt,
  });

  // Factory constructor to create a UserModel instance from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      createdAt: data['created_at'] ?? 0,
    );
  }

  // Convert the UserModel to a Map for Firestore or other uses
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'created_at': createdAt,
    };
  }
}
