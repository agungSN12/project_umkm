class Users {
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final String role;

  Users({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
    required this.role,
  });

  factory Users.fromMap(Map<String, dynamic> map, String documentId) {
    return Users(
      uid: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoURL: map['photoURL'] ?? '',
      role: map['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'role': role,
    };
  }
}
